import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../data/constants/curated_prayers.dart';
import '../../domain/entities/prayer_item.dart';
import '../controllers/playlist_controller.dart';
import '../widgets/prayer_detail_sheet.dart';

class PlaylistDetailPage extends ConsumerWidget {
  final String playlistId;

  const PlaylistDetailPage({
    super.key,
    required this.playlistId,
  });

  void _showRenameDialog(BuildContext context, WidgetRef ref, String currentTitle) {
    final textController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Ubah Nama Playlist',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Nama playlist baru',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = textController.text.trim();
              if (newTitle.isNotEmpty) {
                ref.read(playlistControllerProvider.notifier).updatePlaylistTitle(playlistId, newTitle);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0b3b24),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Playlist',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text('Apakah Anda yakin ingin menghapus playlist "$title"? Doa-doa di dalamnya tidak akan terhapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(playlistControllerProvider.notifier).deletePlaylist(playlistId);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Pop page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistState = ref.watch(playlistControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final playlists = playlistState.playlists;
    final playlistIndex = playlists.indexWhere((p) => p.id == playlistId);
    
    if (playlistIndex == -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final playlist = playlists[playlistIndex];

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4);
    final glassColor = isDark
        ? const Color(0xff121814).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.9);

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    // Filter prayer items in the playlist
    final List<PrayerItem> playlistPrayers = [];
    for (final id in playlist.doaIds) {
      final idx = curatedPrayers.indexWhere((p) => p.id == id);
      if (idx != -1) {
        playlistPrayers.add(curatedPrayers[idx]);
      }
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          playlist.title,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Ubah Nama',
            onPressed: () => _showRenameDialog(context, ref, playlist.title),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Hapus Playlist',
            color: Colors.redAccent,
            onPressed: () => _confirmDelete(context, ref, playlist.title),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientLights(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '${playlistPrayers.length} Doa terkumpul',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: playlistPrayers.isEmpty
                        ? _buildEmptyState(textPrimary, textSecondary)
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 24),
                            itemCount: playlistPrayers.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final prayer = playlistPrayers[index];
                              return _buildPlaylistPrayerCard(
                                context,
                                ref,
                                prayer,
                                glassColor,
                                textPrimary,
                                textSecondary,
                                accentGold,
                                primaryEmerald,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistPrayerCard(
    BuildContext context,
    WidgetRef ref,
    PrayerItem prayer,
    Color glassColor,
    Color textPrimary,
    Color textSecondary,
    Color accentGold,
    Color primaryEmerald,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              builder: (context) => PrayerDetailSheet(prayer: prayer),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryEmerald.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        prayer.category.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: primaryEmerald,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(playlistControllerProvider.notifier)
                            .removePrayerFromPlaylist(playlistId, prayer.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Dihapus dari playlist'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  prayer.title,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    prayer.arabic,
                    style: GoogleFonts.amiri(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryEmerald,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  prayer.translation,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color textPrimary, Color textSecondary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.playlist_remove_rounded,
                color: Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Playlist Kosong',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Tandai doa dengan mengetuk tombol "+ Playlist" di detail doa untuk ditambahkan di sini.',
              style: TextStyle(
                fontSize: 12,
                color: textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
