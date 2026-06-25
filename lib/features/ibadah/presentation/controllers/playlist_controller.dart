import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/prayer_playlist_model.dart';
import '../../domain/entities/prayer_playlist.dart';
import '../../../../core/services/sync_service.dart';
import 'ibadah_controller.dart';

class PlaylistState {
  final List<PrayerPlaylist> playlists;
  final bool isLoading;

  PlaylistState({
    this.playlists = const [],
    this.isLoading = false,
  });

  PlaylistState copyWith({
    List<PrayerPlaylist>? playlists,
    bool? isLoading,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PlaylistController extends StateNotifier<PlaylistState> {
  final Ref _ref;

  PlaylistController(this._ref) : super(PlaylistState()) {
    loadPlaylists();
  }

  Future<void> loadPlaylists() async {
    state = state.copyWith(isLoading: true);
    try {
      final localDS = _ref.read(ibadahLocalDataSourceProvider);
      final playlists = await localDS.getPlaylists();
      state = state.copyWith(playlists: playlists, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> createPlaylist(String title) async {
    if (title.trim().isEmpty) return;

    final id = const Uuid().v4();
    final createdAt = DateTime.now();
    final newPlaylist = PrayerPlaylistModel(
      id: id,
      title: title.trim(),
      createdAt: createdAt,
    );

    final localDS = _ref.read(ibadahLocalDataSourceProvider);
    await localDS.insertPlaylist(newPlaylist);

    final syncService = _ref.read(syncServiceProvider);
    try {
      await syncService.uploadPlaylist(id, title.trim(), createdAt.toIso8601String());
    } catch (_) {}

    await loadPlaylists();
  }

  Future<void> deletePlaylist(String id) async {
    final localDS = _ref.read(ibadahLocalDataSourceProvider);
    await localDS.deletePlaylist(id);

    final syncService = _ref.read(syncServiceProvider);
    try {
      await syncService.deletePlaylistCloud(id);
    } catch (_) {}

    await loadPlaylists();
  }

  Future<void> updatePlaylistTitle(String id, String title) async {
    if (title.trim().isEmpty) return;

    final localDS = _ref.read(ibadahLocalDataSourceProvider);
    await localDS.updatePlaylist(id, title.trim());

    // find playlist to upload updated title
    final playlist = state.playlists.firstWhere((p) => p.id == id);
    final syncService = _ref.read(syncServiceProvider);
    try {
      await syncService.uploadPlaylist(id, title.trim(), playlist.createdAt.toIso8601String());
    } catch (_) {}

    await loadPlaylists();
  }

  Future<void> addPrayerToPlaylist(String playlistId, String doaId) async {
    final localDS = _ref.read(ibadahLocalDataSourceProvider);
    await localDS.addItemToPlaylist(playlistId, doaId);

    final syncService = _ref.read(syncServiceProvider);
    try {
      await syncService.addPlaylistItemCloud(playlistId, doaId);
    } catch (_) {}

    await loadPlaylists();
  }

  Future<void> removePrayerFromPlaylist(String playlistId, String doaId) async {
    final localDS = _ref.read(ibadahLocalDataSourceProvider);
    await localDS.removeItemFromPlaylist(playlistId, doaId);

    final syncService = _ref.read(syncServiceProvider);
    try {
      await syncService.removePlaylistItemCloud(playlistId, doaId);
    } catch (_) {}

    await loadPlaylists();
  }
}

final playlistControllerProvider = StateNotifierProvider<PlaylistController, PlaylistState>((ref) {
  return PlaylistController(ref);
});
