import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../data/datasources/quran_local_datasource.dart';
import '../../data/datasources/quran_remote_datasource.dart';
import '../../data/models/surah_model.dart';
import '../../data/models/ayat_model.dart';
import '../../data/models/tafsir_model.dart';
import '../../data/repositories/quran_repository_impl.dart';
import '../../domain/repositories/quran_repository.dart';

// Foundation Providers
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final quranRemoteDataSourceProvider = Provider<QuranRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QuranRemoteDataSource(apiClient);
});

final quranLocalDataSourceProvider = Provider<QuranLocalDataSource>((ref) {
  return QuranLocalDataSource();
});

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  final remote = ref.watch(quranRemoteDataSourceProvider);
  final local = ref.watch(quranLocalDataSourceProvider);
  return QuranRepositoryImpl(remoteDataSource: remote, localDataSource: local);
});

// Future Providers
final surahListProvider = FutureProvider<List<SurahModel>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahList();
});

final surahDetailProvider = FutureProvider.family<List<AyatModel>, int>((ref, surahNumber) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahDetail(surahNumber);
});

final tafsirProvider = FutureProvider.family<List<TafsirModel>, int>((ref, surahNumber) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahTafsir(surahNumber);
});

// Search & Filter Providers
final quranSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredSurahProvider = Provider<AsyncValue<List<SurahModel>>>((ref) {
  final surahListAsync = ref.watch(surahListProvider);
  final query = ref.watch(quranSearchQueryProvider).toLowerCase();

  return surahListAsync.whenData((surahs) {
    if (query.isEmpty) return surahs;
    return surahs.where((surah) {
      return surah.namaLatin.toLowerCase().contains(query) ||
          surah.arti.toLowerCase().contains(query) ||
          surah.nomor.toString() == query;
    }).toList();
  });
});

// Bookmark State Notifier
class BookmarkNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final QuranRepository _repository;

  BookmarkNotifier(this._repository) : super([]) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      final list = await _repository.getBookmarks();
      state = list;
    } catch (_) {}
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
  }) async {
    try {
      final isBookmarked = await _repository.isBookmarked(surahNumber, verseNumber);
      if (isBookmarked) {
        await _repository.deleteBookmark(surahNumber, verseNumber);
      } else {
        await _repository.addBookmark(
          surahNumber: surahNumber,
          surahName: surahName,
          verseNumber: verseNumber,
        );
      }
      await loadBookmarks();
    } catch (_) {}
  }

  Future<bool> isBookmarked(int surahNumber, int verseNumber) async {
    try {
      return await _repository.isBookmarked(surahNumber, verseNumber);
    } catch (_) {
      return false;
    }
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkNotifier, List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(quranRepositoryProvider);
  return BookmarkNotifier(repo);
});

// Last Read State Notifier
class LastReadNotifier extends StateNotifier<Map<String, dynamic>?> {
  final QuranRepository _repository;

  LastReadNotifier(this._repository) : super(null) {
    loadLastRead();
  }

  Future<void> loadLastRead() async {
    try {
      final data = await _repository.getLastRead();
      state = data;
    } catch (_) {}
  }

  Future<void> saveLastRead({
    required int surahNumber,
    required String surahName,
    required int verseNumber,
    required String verseTextLatin,
  }) async {
    try {
      await _repository.saveLastRead(
        surahNumber: surahNumber,
        surahName: surahName,
        verseNumber: verseNumber,
        verseTextLatin: verseTextLatin,
      );
      await loadLastRead();
    } catch (_) {}
  }
}

final lastReadProvider = StateNotifierProvider<LastReadNotifier, Map<String, dynamic>?>((ref) {
  final repo = ref.watch(quranRepositoryProvider);
  return LastReadNotifier(repo);
});
