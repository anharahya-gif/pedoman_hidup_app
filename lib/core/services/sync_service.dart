import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../../shared/providers.dart';
import 'auth_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final dbHelper = ref.watch(databaseHelperProvider);
  final authService = ref.watch(authServiceProvider);
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return SyncService(
    dbHelper: dbHelper,
    authService: authService,
    sharedPrefs: sharedPrefs,
  );
});

final syncStatusProvider = StateProvider<SyncStatus>((ref) => SyncStatus.idle);

enum SyncStatus { idle, syncing, success, failure }

class SyncService {
  final DatabaseHelper _dbHelper;
  final AuthService _authService;
  final SharedPreferences _sharedPrefs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SyncService({
    required DatabaseHelper dbHelper,
    required AuthService authService,
    required SharedPreferences sharedPrefs,
  })  : _dbHelper = dbHelper,
        _authService = authService,
        _sharedPrefs = sharedPrefs;

  String? get _uid => _authService.currentUser?.uid;

  /// Sinkronisasi penuh dua arah (Local <-> Cloud)
  Future<void> syncAllData(WidgetRef ref) async {
    final uid = _uid;
    if (uid == null) return;

    ref.read(syncStatusProvider.notifier).state = SyncStatus.syncing;

    try {
      final db = await _dbHelper.database;

      await _syncBookmarks(db, uid);
      await _syncLastRead(db, uid);
      await _syncIbadahLogs(db, uid);
      await _syncFavoriteDoas(db, uid);
      await _syncPlaylists(db, uid);
      await _syncPlaylistItems(db, uid);

      // Simpan waktu sinkronisasi terakhir
      await _sharedPrefs.setString('last_sync_time', DateTime.now().toIso8601String());

      ref.read(syncStatusProvider.notifier).state = SyncStatus.success;
    } catch (e) {
      print('Error during syncAllData: $e');
      ref.read(syncStatusProvider.notifier).state = SyncStatus.failure;
      rethrow;
    }
  }

  /// Sinkronkan Bookmarks
  Future<void> _syncBookmarks(Database db, String uid) async {
    final bookmarksRef = _firestore.collection('users').doc(uid).collection('bookmarks');

    // 1. Dapatkan Bookmarks dari Firestore
    final firestoreSnapshot = await bookmarksRef.get();
    final cloudBookmarks = {
      for (var doc in firestoreSnapshot.docs)
        '${doc.data()['surah_number']}_${doc.data()['verse_number']}': doc.data()
    };

    // 2. Dapatkan Bookmarks lokal
    final localBookmarksList = await db.query('bookmarks');
    final localBookmarks = {
      for (var row in localBookmarksList)
        '${row['surah_number']}_${row['verse_number']}': row
    };

    // 3. Gabungkan: jika ada di lokal tapi tidak di cloud -> Upload
    for (var key in localBookmarks.keys) {
      if (!cloudBookmarks.containsKey(key)) {
        final localData = localBookmarks[key]!;
        await bookmarksRef.doc(key).set({
          'surah_number': localData['surah_number'],
          'surah_name': localData['surah_name'],
          'verse_number': localData['verse_number'],
          'created_at': localData['created_at'] ?? DateTime.now().toIso8601String(),
        });
      }
    }

    // 4. Gabungkan: jika ada di cloud tapi tidak di lokal -> Download
    for (var key in cloudBookmarks.keys) {
      if (!localBookmarks.containsKey(key)) {
        final cloudData = cloudBookmarks[key]!;
        await db.insert('bookmarks', {
          'surah_number': cloudData['surah_number'],
          'surah_name': cloudData['surah_name'],
          'verse_number': cloudData['verse_number'],
          'created_at': cloudData['created_at'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
  }

  /// Sinkronkan Last Read
  Future<void> _syncLastRead(Database db, String uid) async {
    final lastReadDocRef = _firestore.collection('users').doc(uid).collection('last_read').doc('state');

    // 1. Ambil dari cloud
    final cloudDoc = await lastReadDocRef.get();
    final cloudData = cloudDoc.data();

    // 2. Ambil dari lokal
    final localList = await db.query('last_read', limit: 1);
    final localData = localList.isNotEmpty ? localList.first : null;

    if (localData != null) {
      final localTime = DateTime.parse(localData['created_at'] as String);
      final cloudTime = cloudData != null ? DateTime.parse(cloudData['created_at'] as String) : null;

      if (cloudTime == null || localTime.isAfter(cloudTime)) {
        // Upload lokal yang lebih baru ke cloud
        await lastReadDocRef.set({
          'surah_number': localData['surah_number'],
          'surah_name': localData['surah_name'],
          'verse_number': localData['verse_number'],
          'verse_text_latin': localData['verse_text_latin'],
          'created_at': localData['created_at'],
        });
      } else if (cloudTime != null && localTime.isBefore(cloudTime) && cloudData != null) {
        // Download cloud yang lebih baru ke lokal
        await db.transaction((txn) async {
          await txn.delete('last_read');
          await txn.insert('last_read', {
            'id': 1,
            'surah_number': cloudData['surah_number'],
            'surah_name': cloudData['surah_name'],
            'verse_number': cloudData['verse_number'],
            'verse_text_latin': cloudData['verse_text_latin'],
            'created_at': cloudData['created_at'],
          });
        });
      }
    } else if (cloudData != null) {
      // Tidak ada data lokal tapi ada di cloud -> Download
      await db.insert('last_read', {
        'id': 1,
        'surah_number': cloudData['surah_number'],
        'surah_name': cloudData['surah_name'],
        'verse_number': cloudData['verse_number'],
        'verse_text_latin': cloudData['verse_text_latin'],
        'created_at': cloudData['created_at'],
      });
    }
  }

  /// Sinkronkan Ibadah Logs
  Future<void> _syncIbadahLogs(Database db, String uid) async {
    final logsRef = _firestore.collection('users').doc(uid).collection('ibadah_logs');

    // 1. Dapatkan logs dari Firestore
    final firestoreSnapshot = await logsRef.get();
    final cloudLogs = {
      for (var doc in firestoreSnapshot.docs)
        doc.id: doc.data()
    };

    // 2. Dapatkan logs lokal
    final localLogsList = await db.query('ibadah_logs');
    final localLogs = {
      for (var row in localLogsList)
        row['date'] as String: row
    };

    // 3. Bandingkan dan Sinkronisasi
    // Gabungkan data lokal -> Cloud
    for (var date in localLogs.keys) {
      final localData = localLogs[date]!;
      final cloudData = cloudLogs[date];

      if (cloudData == null) {
        // Upload data yang tidak ada di cloud
        await logsRef.doc(date).set(_cleanMap(localData));
      } else {
        // Jika dua-duanya ada, bandingkan updated_at
        final localUpdate = DateTime.parse(localData['updated_at'] as String);
        final cloudUpdate = DateTime.parse(cloudData['updated_at'] as String);

        if (localUpdate.isAfter(cloudUpdate)) {
          // Upload data lokal yang lebih baru
          await logsRef.doc(date).set(_cleanMap(localData));
        } else if (localUpdate.isBefore(cloudUpdate)) {
          // Update data lokal dengan cloud yang lebih baru
          await db.update(
            'ibadah_logs',
            _cleanMap(cloudData),
            where: 'date = ?',
            whereArgs: [date],
          );
        }
      }
    }

    // Gabungkan data cloud -> Lokal (jika tidak ada di lokal)
    for (var date in cloudLogs.keys) {
      if (!localLogs.containsKey(date)) {
        final cloudData = cloudLogs[date]!;
        await db.insert('ibadah_logs', _cleanMap(cloudData));
      }
    }
  }

  /// Sinkronkan Doa Favorit
  Future<void> _syncFavoriteDoas(Database db, String uid) async {
    final doasRef = _firestore.collection('users').doc(uid).collection('favorite_doas');

    // 1. Ambil dari cloud
    final firestoreSnapshot = await doasRef.get();
    final cloudDoas = {
      for (var doc in firestoreSnapshot.docs)
        doc.id: doc.data()
    };

    // 2. Ambil dari lokal
    final localDoasList = await db.query('favorite_doas');
    final localDoas = {
      for (var row in localDoasList)
        row['doa_id'] as String: row
    };

    // 3. Upload dari lokal -> Cloud
    for (var doaId in localDoas.keys) {
      if (!cloudDoas.containsKey(doaId)) {
        final localData = localDoas[doaId]!;
        await doasRef.doc(doaId).set({
          'doa_id': localData['doa_id'],
          'saved_at': localData['saved_at'],
        });
      }
    }

    // 4. Download dari cloud -> Lokal
    for (var doaId in cloudDoas.keys) {
      if (!localDoas.containsKey(doaId)) {
        final cloudData = cloudDoas[doaId]!;
        await db.insert('favorite_doas', {
          'doa_id': cloudData['doa_id'],
          'saved_at': cloudData['saved_at'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
  }

  /// Hapus kolom auto-increment agar aman ditransfer
  Map<String, dynamic> _cleanMap(Map<String, dynamic> original) {
    final cleaned = Map<String, dynamic>.from(original);
    cleaned.remove('id'); // ID primary key lokal sqlite dihilangkan jika ada
    return cleaned;
  }

  /// Instant Save / Push per Baris ke Firestore (saat user mengubah ibadah log, menambah bookmark, dll)
  Future<void> uploadSingleLog(Map<String, dynamic> logData) async {
    final uid = _uid;
    if (uid == null) return;
    final date = logData['date'] as String;
    await _firestore.collection('users').doc(uid).collection('ibadah_logs').doc(date).set(_cleanMap(logData));
  }

  Future<void> uploadSingleBookmark(Map<String, dynamic> bookmarkData) async {
    final uid = _uid;
    if (uid == null) return;
    final key = '${bookmarkData['surah_number']}_${bookmarkData['verse_number']}';
    await _firestore.collection('users').doc(uid).collection('bookmarks').doc(key).set({
      'surah_number': bookmarkData['surah_number'],
      'surah_name': bookmarkData['surah_name'],
      'verse_number': bookmarkData['verse_number'],
      'created_at': bookmarkData['created_at'] ?? DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteSingleBookmark(int surahNumber, int verseNumber) async {
    final uid = _uid;
    if (uid == null) return;
    final key = '${surahNumber}_${verseNumber}';
    await _firestore.collection('users').doc(uid).collection('bookmarks').doc(key).delete();
  }

  Future<void> uploadLastRead(Map<String, dynamic> lastReadData) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('last_read').doc('state').set({
      'surah_number': lastReadData['surah_number'],
      'surah_name': lastReadData['surah_name'],
      'verse_number': lastReadData['verse_number'],
      'verse_text_latin': lastReadData['verse_text_latin'],
      'created_at': lastReadData['created_at'] ?? DateTime.now().toIso8601String(),
    });
  }

  Future<void> uploadSingleFavoriteDoa(String doaId, String savedAt) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('favorite_doas').doc(doaId).set({
      'doa_id': doaId,
      'saved_at': savedAt,
    });
  }

  Future<void> deleteSingleFavoriteDoa(String doaId) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('favorite_doas').doc(doaId).delete();
  }

  /// Sinkronkan playlists
  Future<void> _syncPlaylists(Database db, String uid) async {
    final playlistsRef = _firestore.collection('users').doc(uid).collection('playlists');
    final cloudSnap = await playlistsRef.get();
    final cloudPlaylists = {for (var doc in cloudSnap.docs) doc.id: doc.data()};

    final localPlaylistsList = await db.query('prayer_playlists');
    final localPlaylists = {for (var row in localPlaylistsList) row['id'] as String: row};

    // Upload local -> Cloud
    for (var id in localPlaylists.keys) {
      if (!cloudPlaylists.containsKey(id)) {
        await playlistsRef.doc(id).set(localPlaylists[id]!);
      }
    }

    // Download cloud -> Local
    for (var id in cloudPlaylists.keys) {
      if (!localPlaylists.containsKey(id)) {
        await db.insert('prayer_playlists', cloudPlaylists[id]!, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
  }

  /// Sinkronkan playlist items
  Future<void> _syncPlaylistItems(Database db, String uid) async {
    final itemsRef = _firestore.collection('users').doc(uid).collection('playlist_items');
    final cloudSnap = await itemsRef.get();
    final cloudItems = {for (var doc in cloudSnap.docs) doc.id: doc.data()};

    final localItemsList = await db.query('playlist_items');
    final localItems = {for (var row in localItemsList) '${row['playlist_id']}_${row['doa_id']}': row};

    // Upload local -> Cloud
    for (var key in localItems.keys) {
      if (!cloudItems.containsKey(key)) {
        final row = localItems[key]!;
        await itemsRef.doc(key).set({
          'playlist_id': row['playlist_id'],
          'doa_id': row['doa_id'],
        });
      }
    }

    // Download cloud -> Local
    for (var key in cloudItems.keys) {
      if (!localItems.containsKey(key)) {
        final data = cloudItems[key]!;
        await db.insert('playlist_items', {
          'playlist_id': data['playlist_id'],
          'doa_id': data['doa_id'],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
  }

  Future<void> uploadPlaylist(String playlistId, String title, String createdAt) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('playlists').doc(playlistId).set({
      'id': playlistId,
      'title': title,
      'created_at': createdAt,
    });
  }

  Future<void> deletePlaylistCloud(String playlistId) async {
    final uid = _uid;
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).collection('playlists').doc(playlistId).delete();
    
    // Delete all cloud items for this playlist
    final itemsSnap = await _firestore
        .collection('users')
        .doc(uid)
        .collection('playlist_items')
        .where('playlist_id', isEqualTo: playlistId)
        .get();
    for (var doc in itemsSnap.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> addPlaylistItemCloud(String playlistId, String doaId) async {
    final uid = _uid;
    if (uid == null) return;
    final key = '${playlistId}_$doaId';
    await _firestore.collection('users').doc(uid).collection('playlist_items').doc(key).set({
      'playlist_id': playlistId,
      'doa_id': doaId,
    });
  }

  Future<void> removePlaylistItemCloud(String playlistId, String doaId) async {
    final uid = _uid;
    if (uid == null) return;
    final key = '${playlistId}_$doaId';
    await _firestore.collection('users').doc(uid).collection('playlist_items').doc(key).delete();
  }
}
