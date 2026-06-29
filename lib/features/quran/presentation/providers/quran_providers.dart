import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/services/sync_service.dart';
import '../../../../shared/providers.dart';
import '../../../ibadah/presentation/controllers/ibadah_controller.dart';
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
  final Ref _ref;

  BookmarkNotifier(this._repository, this._ref) : super([]) {
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
        try {
          await _ref.read(syncServiceProvider).deleteSingleBookmark(surahNumber, verseNumber);
        } catch (_) {}
      } else {
        final createdAt = DateTime.now().toIso8601String();
        await _repository.addBookmark(
          surahNumber: surahNumber,
          surahName: surahName,
          verseNumber: verseNumber,
        );
        try {
          await _ref.read(syncServiceProvider).uploadSingleBookmark({
            'surah_number': surahNumber,
            'surah_name': surahName,
            'verse_number': verseNumber,
            'created_at': createdAt,
          });
        } catch (_) {}
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
  return BookmarkNotifier(repo, ref);
});

// Mushaf Madinah Page mapping arrays
const List<int> _surahStartPages = [
  1, 2, 50, 77, 106, 128, 151, 177, 187, 208, // 1-10
  221, 235, 249, 255, 262, 267, 282, 293, 305, 312, // 11-20
  322, 332, 342, 350, 359, 367, 377, 385, 396, 404, // 21-30
  411, 415, 418, 428, 434, 440, 446, 453, 458, 467, // 31-40
  477, 483, 489, 496, 499, 502, 507, 511, 515, 518, // 41-50
  520, 526, 528, 531, 534, 537, 542, 545, 549, 551, // 51-60
  553, 554, 556, 558, 560, 562, 564, 566, 568, 570, // 61-70
  572, 574, 575, 577, 578, 580, 582, 583, 585, 587, // 71-80
  589, 590, 591, 592, 593, 594, 595, 596, 597, 597, // 81-90
  598, 599, 600, 601, 601, 602, 602, 603, 603, 603, // 91-100
  604, 604, 604, 604, 604, 604, 604, 604, 604, 604, // 101-110
  604, 604, 604, 604 // 111-114
];

const List<int> _surahTotalVerses = [
  7, 286, 200, 176, 120, 165, 206, 75, 129, 109, // 1-10
  123, 111, 43, 52, 99, 128, 111, 110, 98, 135, // 11-20
  112, 78, 118, 64, 77, 227, 93, 88, 69, 60, // 21-30
  34, 30, 73, 54, 45, 83, 182, 88, 75, 85, // 31-40
  54, 53, 89, 59, 37, 35, 38, 29, 18, 45, // 41-50
  60, 49, 62, 55, 78, 96, 29, 22, 24, 13, // 51-60
  14, 11, 11, 18, 12, 12, 30, 52, 52, 44, // 61-70
  28, 28, 20, 56, 40, 31, 50, 40, 46, 29, // 71-80
  19, 36, 25, 22, 17, 19, 26, 30, 20, 15, // 81-90
  21, 11, 8, 8, 8, 19, 5, 8, 8, 11, // 91-100
  11, 8, 3, 9, 5, 4, 7, 3, 6, 3, // 101-110
  5, 4, 5, 6 // 111-114
];

int _getPageNumber(int surahNum, int verseNum) {
  if (surahNum < 1 || surahNum > 114) return 1;
  final startPage = _surahStartPages[surahNum - 1];
  final nextStartPage = surahNum == 114 ? 605 : _surahStartPages[surahNum];
  final totalPages = nextStartPage - startPage;
  final totalVerses = _surahTotalVerses[surahNum - 1];

  if (totalPages <= 1) return startPage;

  final offset = ((verseNum - 1) / totalVerses) * totalPages;
  final page = startPage + offset.floor();

  return page.clamp(startPage, nextStartPage - 1);
}

// Last Read State Notifier
class LastReadNotifier extends StateNotifier<Map<String, dynamic>?> {
  final QuranRepository _repository;
  final Ref _ref;

  LastReadNotifier(this._repository, this._ref) : super(null) {
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
      final oldLastRead = await _repository.getLastRead();

      final createdAt = DateTime.now().toIso8601String();
      await _repository.saveLastRead(
        surahNumber: surahNumber,
        surahName: surahName,
        verseNumber: verseNumber,
        verseTextLatin: verseTextLatin,
      );
      await loadLastRead();

      // Sinkronkan ke Ibadah Log secara otomatis berdasarkan perbedaan halaman yang dibaca
      if (oldLastRead != null) {
        final oldSurah = oldLastRead['surah_number'] as int?;
        final oldVerse = oldLastRead['verse_number'] as int?;
        if (oldSurah != null && oldVerse != null) {
          final oldPage = _getPageNumber(oldSurah, oldVerse);
          final newPage = _getPageNumber(surahNumber, verseNumber);
          final pagesRead = newPage - oldPage;
          
          if (pagesRead > 0) {
            final ibadahController = _ref.read(ibadahControllerProvider.notifier);
            final addedPages = pagesRead <= 30 ? pagesRead : 1;
            await ibadahController.incrementQuranPages(addedPages);
          }
        }
      }

      try {
        await _ref.read(syncServiceProvider).uploadLastRead({
          'surah_number': surahNumber,
          'surah_name': surahName,
          'verse_number': verseNumber,
          'verse_text_latin': verseTextLatin,
          'created_at': createdAt,
        });
      } catch (_) {}
    } catch (_) {}
  }
}

final lastReadProvider = StateNotifierProvider<LastReadNotifier, Map<String, dynamic>?>((ref) {
  final repo = ref.watch(quranRepositoryProvider);
  return LastReadNotifier(repo, ref);
});

// --- QURAN FONT SETTINGS ---
class QuranFontSettings {
  final double arabicFontSize;
  final double latinFontSize;

  QuranFontSettings({
    required this.arabicFontSize,
    required this.latinFontSize,
  });

  QuranFontSettings copyWith({
    double? arabicFontSize,
    double? latinFontSize,
  }) {
    return QuranFontSettings(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      latinFontSize: latinFontSize ?? this.latinFontSize,
    );
  }
}

class QuranFontSettingsNotifier extends StateNotifier<QuranFontSettings> {
  final Ref _ref;

  QuranFontSettingsNotifier(this._ref)
      : super(QuranFontSettings(arabicFontSize: 28.0, latinFontSize: 14.0)) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      final arabicSize = prefs.getDouble('quran_arabic_font_size') ?? 28.0;
      final latinSize = prefs.getDouble('quran_latin_font_size') ?? 14.0;
      state = QuranFontSettings(
        arabicFontSize: arabicSize,
        latinFontSize: latinSize,
      );
    } catch (_) {}
  }

  Future<void> setArabicFontSize(double size) async {
    state = state.copyWith(arabicFontSize: size);
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.setDouble('quran_arabic_font_size', size);
    } catch (_) {}
  }

  Future<void> setLatinFontSize(double size) async {
    state = state.copyWith(latinFontSize: size);
    try {
      final prefs = _ref.read(sharedPreferencesProvider);
      await prefs.setDouble('quran_latin_font_size', size);
    } catch (_) {}
  }
}

final quranFontSettingsProvider =
    StateNotifierProvider<QuranFontSettingsNotifier, QuranFontSettings>((ref) {
  return QuranFontSettingsNotifier(ref);
});
