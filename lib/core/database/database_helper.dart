import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pedoman_hidup.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final pathString = join(dbPath, filePath);

    return await openDatabase(
      pathString,
      version: 2,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Create bookmarks table (Quran)
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        surah_number INTEGER,
        surah_name TEXT,
        verse_number INTEGER,
        created_at TEXT
      )
    ''');

    // 2. Create last_read table (Quran)
    await db.execute('''
      CREATE TABLE last_read (
        id INTEGER PRIMARY KEY,
        surah_number INTEGER,
        surah_name TEXT,
        verse_number INTEGER,
        verse_text_latin TEXT,
        created_at TEXT
      )
    ''');

    // 3. Create prayer_times table (Ibadah Hub)
    await db.execute('''
      CREATE TABLE prayer_times (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        city TEXT NOT NULL,
        fajr TEXT NOT NULL,
        dhuhr TEXT NOT NULL,
        asr TEXT NOT NULL,
        maghrib TEXT NOT NULL,
        isha TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // 4. Create ibadah_logs table (Ibadah Hub)
    await db.execute('''
      CREATE TABLE ibadah_logs (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL UNIQUE,
        subuh TEXT NOT NULL DEFAULT 'belum',
        dzuhur TEXT NOT NULL DEFAULT 'belum',
        ashar TEXT NOT NULL DEFAULT 'belum',
        maghrib TEXT NOT NULL DEFAULT 'belum',
        isya TEXT NOT NULL DEFAULT 'belum',
        quran_pages INTEGER NOT NULL DEFAULT 0,
        dhikr_count INTEGER NOT NULL DEFAULT 0,
        duha INTEGER NOT NULL DEFAULT 0,
        tahajjud INTEGER NOT NULL DEFAULT 0,
        sedekah INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');

    // 5. Create favorite_doas table (Doa)
    await db.execute('''
      CREATE TABLE favorite_doas (
        doa_id TEXT PRIMARY KEY,
        saved_at TEXT NOT NULL
      )
    ''');

    // 6. Create prayer_playlists table (Doa Playlist)
    await db.execute('''
      CREATE TABLE prayer_playlists (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // 7. Create playlist_items table (Doa Playlist Items)
    await db.execute('''
      CREATE TABLE playlist_items (
        playlist_id TEXT NOT NULL,
        doa_id TEXT NOT NULL,
        PRIMARY KEY (playlist_id, doa_id),
        FOREIGN KEY (playlist_id) REFERENCES prayer_playlists (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE prayer_playlists (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          created_at TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE playlist_items (
          playlist_id TEXT NOT NULL,
          doa_id TEXT NOT NULL,
          PRIMARY KEY (playlist_id, doa_id),
          FOREIGN KEY (playlist_id) REFERENCES prayer_playlists (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      try {
        await db.close();
      } catch (_) {}
      _database = null;
    }
  }
}
