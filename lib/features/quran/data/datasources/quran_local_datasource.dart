import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';

class QuranLocalDataSource {
  final DatabaseHelper _dbHelper;

  QuranLocalDataSource({DatabaseHelper? dbHelper}) : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<Database> get _database => _dbHelper.database;

  // --- BOOKMARKS ---
  Future<void> addBookmark({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
  }) async {
    final db = await _database;
    final existing = await db.query(
      'bookmarks',
      where: 'surah_number = ? AND verse_number = ?',
      whereArgs: [surahNumber, verseNumber],
    );

    if (existing.isEmpty) {
      await db.insert('bookmarks', {
        'surah_number': surahNumber,
        'surah_name': surahName,
        'verse_number': verseNumber,
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> deleteBookmark(int surahNumber, int verseNumber) async {
    final db = await _database;
    await db.delete(
      'bookmarks',
      where: 'surah_number = ? AND verse_number = ?',
      whereArgs: [surahNumber, verseNumber],
    );
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    final db = await _database;
    return await db.query('bookmarks', orderBy: 'id DESC');
  }

  Future<bool> isBookmarked(int surahNumber, int verseNumber) async {
    final db = await _database;
    final res = await db.query(
      'bookmarks',
      where: 'surah_number = ? AND verse_number = ?',
      whereArgs: [surahNumber, verseNumber],
    );
    return res.isNotEmpty;
  }

  // --- LAST READ ---
  Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
    required String verseTextLatin,
  }) async {
    final db = await _database;
    await db.insert(
      'last_read',
      {
        'id': 1, // Always overwrite the single entry
        'surah_number': surahNumber,
        'surah_name': surahName,
        'verse_number': verseNumber,
        'verse_text_latin': verseTextLatin,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getLastRead() async {
    final db = await _database;
    final maps = await db.query(
      'last_read',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }
}
