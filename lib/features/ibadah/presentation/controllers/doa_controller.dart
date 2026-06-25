import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/sync_service.dart';
import '../../data/constants/prayers_after_shalat.dart';
import '../../data/constants/curated_prayers.dart';
import 'ibadah_controller.dart';
import 'playlist_controller.dart';

/// State lengkap untuk fitur kumpulan doa dan dzikir setelah shalat.
class DoaState {
  final List<String> favoriteDoaIds;
  final String searchQuery;
  final String selectedCategory;
  final int activeDhikrStepIndex;
  final int activeDhikrCount;
  final bool isDhikrCompleted;
  final bool isLoading;
  final String? selectedPlaylistId;

  DoaState({
    this.favoriteDoaIds = const [],
    this.searchQuery = '',
    this.selectedCategory = 'Semua',
    this.activeDhikrStepIndex = 0,
    this.activeDhikrCount = 0,
    this.isDhikrCompleted = false,
    this.isLoading = false,
    this.selectedPlaylistId,
  });

  DoaState copyWith({
    List<String>? favoriteDoaIds,
    String? searchQuery,
    String? selectedCategory,
    int? activeDhikrStepIndex,
    int? activeDhikrCount,
    bool? isDhikrCompleted,
    bool? isLoading,
    String? selectedPlaylistId,
  }) {
    return DoaState(
      favoriteDoaIds: favoriteDoaIds ?? this.favoriteDoaIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      activeDhikrStepIndex: activeDhikrStepIndex ?? this.activeDhikrStepIndex,
      activeDhikrCount: activeDhikrCount ?? this.activeDhikrCount,
      isDhikrCompleted: isDhikrCompleted ?? this.isDhikrCompleted,
      isLoading: isLoading ?? this.isLoading,
      selectedPlaylistId: selectedPlaylistId ?? this.selectedPlaylistId,
    );
  }
}

/// Controller reaktif global untuk Doa & Dzikir.
class DoaController extends StateNotifier<DoaState> {
  final Ref _ref;

  DoaController(this._ref) : super(DoaState()) {
    _init();
  }

  /// Memuat ID doa yang difavoritkan dari SQLite.
  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      final localDS = _ref.read(ibadahLocalDataSourceProvider);
      final list = await localDS.getFavoriteDoaIds();
      state = state.copyWith(favoriteDoaIds: list, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Menambah atau menghapus doa dari daftar favorit.
  Future<void> toggleFavoriteDoa(String id) async {
    final localDS = _ref.read(ibadahLocalDataSourceProvider);
    final currentFavorites = List<String>.from(state.favoriteDoaIds);
    final syncService = _ref.read(syncServiceProvider);

    if (currentFavorites.contains(id)) {
      currentFavorites.remove(id);
      await localDS.removeFavoriteDoa(id);
      try {
        await syncService.deleteSingleFavoriteDoa(id);
      } catch (_) {}
    } else {
      final savedAt = DateTime.now().toIso8601String();
      currentFavorites.add(id);
      await localDS.addFavoriteDoa(id);
      try {
        await syncService.uploadSingleFavoriteDoa(id, savedAt);
      } catch (_) {}
    }

    state = state.copyWith(favoriteDoaIds: currentFavorites);
  }

  /// Memperbarui kata kunci pencarian.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Memperbarui kategori yang dipilih.
  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Mengeset ulang sesi dzikir setelah shalat.
  void resetDhikrSession() {
    state = state.copyWith(
      activeDhikrStepIndex: 0,
      activeDhikrCount: 0,
      isDhikrCompleted: false,
    );
  }

  /// Mengatur playlist doa kustom untuk disisipkan dalam dzikir.
  void setDhikrPlaylistId(String? id) {
    state = DoaState(
      favoriteDoaIds: state.favoriteDoaIds,
      searchQuery: state.searchQuery,
      selectedCategory: state.selectedCategory,
      activeDhikrStepIndex: 0,
      activeDhikrCount: 0,
      isDhikrCompleted: false,
      isLoading: state.isLoading,
      selectedPlaylistId: id,
    );
  }

  /// Mendapatkan seluruh langkah dzikir (default + playlist doa tambahan).
  List<DhikrStep> getDhikrSteps() {
    final baseSteps = prayersAfterShalatSteps;
    final playlistId = state.selectedPlaylistId;
    if (playlistId == null) return baseSteps;

    final playlists = _ref.read(playlistControllerProvider).playlists;
    final index = playlists.indexWhere((p) => p.id == playlistId);
    if (index == -1) return baseSteps;

    final playlist = playlists[index];
    final List<DhikrStep> dynamicSteps = List.from(baseSteps);

    int stepNum = baseSteps.length + 1;
    for (final doaId in playlist.doaIds) {
      final idx = curatedPrayers.indexWhere((p) => p.id == doaId);
      if (idx != -1) {
        final prayer = curatedPrayers[idx];
        dynamicSteps.add(DhikrStep(
          stepNumber: stepNum++,
          title: prayer.title,
          arabic: prayer.arabic,
          latin: prayer.latin,
          translation: prayer.translation,
          targetCount: 1,
        ));
      }
    }
    return dynamicSteps;
  }

  /// Melewati ke langkah berikutnya secara manual.
  void skipToNextStep() {
    final steps = getDhikrSteps();
    if (state.activeDhikrStepIndex < steps.length - 1) {
      state = state.copyWith(
        activeDhikrStepIndex: state.activeDhikrStepIndex + 1,
        activeDhikrCount: 0,
      );
    } else {
      _completeSession();
    }
  }

  /// Menambah hitungan dzikir aktif pada langkah saat ini.
  Future<void> incrementDhikr() async {
    if (state.isDhikrCompleted) return;

    final steps = getDhikrSteps();
    final currentStep = steps[state.activeDhikrStepIndex];
    final nextCount = state.activeDhikrCount + 1;

    HapticFeedback.lightImpact();

    // Tambahkan juga ke total hitungan dzikir harian di Ibadah Log
    final ibadahController = _ref.read(ibadahControllerProvider.notifier);
    final dailyLog = _ref.read(ibadahControllerProvider).ibadahLog;
    if (dailyLog != null) {
      await ibadahController.updateDhikrCount(dailyLog.dhikrCount + 1);
    }

    if (nextCount >= currentStep.targetCount) {
      HapticFeedback.mediumImpact();
      if (state.activeDhikrStepIndex >= steps.length - 1) {
        state = state.copyWith(activeDhikrCount: nextCount);
        await _completeSession();
      } else {
        state = state.copyWith(
          activeDhikrStepIndex: state.activeDhikrStepIndex + 1,
          activeDhikrCount: 0,
        );
      }
    } else {
      state = state.copyWith(activeDhikrCount: nextCount);
    }
  }

  /// Menyelesaikan seluruh rangkaian sesi dzikir shalat.
  Future<void> _completeSession() async {
    HapticFeedback.heavyImpact();
    state = state.copyWith(isDhikrCompleted: true);
  }
}

/// Provider Riverpod global untuk Doa & Dzikir.
final doaControllerProvider = StateNotifierProvider<DoaController, DoaState>((ref) {
  return DoaController(ref);
});
