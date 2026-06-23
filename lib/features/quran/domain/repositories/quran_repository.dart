import '../../data/models/surah_model.dart';
import '../../data/models/ayat_model.dart';
import '../../data/models/tafsir_model.dart';

abstract class QuranRepository {
  // Remote
  Future<List<SurahModel>> getSurahList();
  Future<List<AyatModel>> getSurahDetail(int surahNumber);
  Future<List<TafsirModel>> getSurahTafsir(int surahNumber);

  // Local - Bookmarks
  Future<void> addBookmark({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
  });
  Future<void> deleteBookmark(int surahNumber, int verseNumber);
  Future<List<Map<String, dynamic>>> getBookmarks();
  Future<bool> isBookmarked(int surahNumber, int verseNumber);

  // Local - Last Read
  Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
    required String verseTextLatin,
  });
  Future<Map<String, dynamic>?> getLastRead();
}
