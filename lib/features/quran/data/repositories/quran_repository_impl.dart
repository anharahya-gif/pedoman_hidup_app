import '../../domain/repositories/quran_repository.dart';
import '../datasources/quran_local_datasource.dart';
import '../datasources/quran_remote_datasource.dart';
import '../models/surah_model.dart';
import '../models/ayat_model.dart';
import '../models/tafsir_model.dart';

class QuranRepositoryImpl implements QuranRepository {
  final QuranRemoteDataSource remoteDataSource;
  final QuranLocalDataSource localDataSource;

  QuranRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<SurahModel>> getSurahList() {
    return remoteDataSource.getSurahList();
  }

  @override
  Future<List<AyatModel>> getSurahDetail(int surahNumber) {
    return remoteDataSource.getSurahDetail(surahNumber);
  }

  @override
  Future<List<TafsirModel>> getSurahTafsir(int surahNumber) {
    return remoteDataSource.getSurahTafsir(surahNumber);
  }

  @override
  Future<void> addBookmark({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
  }) {
    return localDataSource.addBookmark(
      surahNumber: surahNumber,
      surahName: surahName,
      verseNumber: verseNumber,
    );
  }

  @override
  Future<void> deleteBookmark(int surahNumber, int verseNumber) {
    return localDataSource.deleteBookmark(surahNumber, verseNumber);
  }

  @override
  Future<List<Map<String, dynamic>>> getBookmarks() {
    return localDataSource.getBookmarks();
  }

  @override
  Future<bool> isBookmarked(int surahNumber, int verseNumber) {
    return localDataSource.isBookmarked(surahNumber, verseNumber);
  }

  @override
  Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
    required String verseTextLatin,
  }) {
    return localDataSource.saveLastRead(
      surahNumber: surahNumber,
      surahName: surahName,
      verseNumber: verseNumber,
      verseTextLatin: verseTextLatin,
    );
  }

  @override
  Future<Map<String, dynamic>?> getLastRead() {
    return localDataSource.getLastRead();
  }
}
