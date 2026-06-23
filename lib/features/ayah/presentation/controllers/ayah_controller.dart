import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/audio_player_helper.dart';
import '../../data/constants/curated_ayahs.dart';
import '../../data/repositories/tajwid_repository_impl.dart';
import '../../domain/entities/daily_ayah.dart';

class AyahState {
  final DailyAyah? todayAyah;
  final bool isLoading;
  final String errorMessage;
  final bool isAudioPlaying;
  final bool isAudioLoading;

  const AyahState({
    this.todayAyah,
    this.isLoading = false,
    this.errorMessage = '',
    this.isAudioPlaying = false,
    this.isAudioLoading = false,
  });

  AyahState copyWith({
    DailyAyah? todayAyah,
    bool? isLoading,
    String? errorMessage,
    bool? isAudioPlaying,
    bool? isAudioLoading,
  }) {
    return AyahState(
      todayAyah: todayAyah ?? this.todayAyah,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isAudioPlaying: isAudioPlaying ?? this.isAudioPlaying,
      isAudioLoading: isAudioLoading ?? this.isAudioLoading,
    );
  }
}

// ─── RIVERPOD PROVIDERS ──────────────────────────────────────────────────────

final tajwidRepositoryProvider = Provider<TajwidRepository>((ref) {
  return TajwidRepositoryImpl();
});

final ayahControllerProvider = StateNotifierProvider<AyahController, AyahState>((ref) {
  return AyahController(ref);
});

// ─── CONTROLLER CLASS ────────────────────────────────────────────────────────

class AyahController extends StateNotifier<AyahState> {
  final Ref _ref;

  AyahController(this._ref) : super(const AyahState()) {
    _init();
  }

  void _init() {
    // Listen to unified AudioPlayerHelper state changes
    AudioPlayerHelper().onStateChanged = (url, isPlaying) {
      if (mounted && state.todayAyah != null && url == state.todayAyah!.audioUrl) {
        state = state.copyWith(
          isAudioPlaying: isPlaying,
          isAudioLoading: false,
        );
      }
    };

    loadTodayAyah();
  }

  /// Memuat Ayat Hari Ini secara luring dari daftar terkurasi berdasarkan tanggal
  Future<void> loadTodayAyah() async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    try {
      final now = DateTime.now();
      // Menentukan indeks berdasarkan hari dalam sebulan (1 s.d. 31)
      final index = (now.day - 1) % curatedAyahsList.length;
      final curated = curatedAyahsList[index];

      final today = DailyAyah(
        id: '${curated.surahNumber}:${curated.ayahNumber}',
        date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        surahNumber: curated.surahNumber,
        ayahNumber: curated.ayahNumber,
        surahName: curated.surahName,
        arabicText: curated.arabicText,
        translation: curated.translation,
        audioUrl: curated.audioUrl,
        tajwidOccurrences: curated.tajwidList,
        createdAt: now,
      );

      state = state.copyWith(todayAyah: today, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat ayat harian: $e',
      );
    }
  }

  // ─── AUDIO PLAYBACK METHODS ────────────────────────────────────────────────

  /// Memutar atau menjeda audio murattal menggunakan AudioPlayerHelper
  Future<void> toggleAudioPlayback(String? url) async {
    if (url == null || url.isEmpty) return;

    if (state.isAudioPlaying) {
      await AudioPlayerHelper().pause();
      if (mounted) {
        state = state.copyWith(isAudioPlaying: false);
      }
    } else {
      try {
        if (mounted) {
          state = state.copyWith(isAudioLoading: true);
        }
        await AudioPlayerHelper().play(url);
        if (mounted) {
          state = state.copyWith(isAudioLoading: false, isAudioPlaying: true);
        }
      } catch (e) {
        if (mounted) {
          state = state.copyWith(
            isAudioLoading: false,
            errorMessage: 'Gagal memutar audio: $e',
          );
        }
      }
    }
  }

  /// Menghentikan pemutaran audio
  Future<void> stopAudio() async {
    await AudioPlayerHelper().stop();
    if (mounted) {
      state = state.copyWith(isAudioPlaying: false, isAudioLoading: false);
    }
  }

  // Offline mode doesn't need DB favorites caching, returns false
  bool isFavorited(DailyAyah ayah) => false;
  void toggleFavorite(DailyAyah ayah) {}
}
