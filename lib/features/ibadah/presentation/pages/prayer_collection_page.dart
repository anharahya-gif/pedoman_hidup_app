import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../data/constants/curated_prayers.dart';
import '../../domain/entities/prayer_item.dart';
import '../../domain/entities/prayer_playlist.dart';
import '../controllers/doa_controller.dart';
import '../controllers/playlist_controller.dart';
import '../widgets/prayer_detail_sheet.dart';
import 'playlist_detail_page.dart';

class PrayerCollectionPage extends ConsumerWidget {
  const PrayerCollectionPage({super.key});

  void _showCreatePlaylistDialog(BuildContext context, WidgetRef ref) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Buat Playlist Baru',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Nama playlist (misal: Doa Harian)',
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
              final title = textController.text.trim();
              if (title.isNotEmpty) {
                ref.read(playlistControllerProvider.notifier).createPlaylist(title);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0b3b24),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }

  void _showRenamePlaylistDialog(BuildContext context, WidgetRef ref, String id, String currentTitle) {
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
                ref.read(playlistControllerProvider.notifier).updatePlaylistTitle(id, newTitle);
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

  void _confirmDeletePlaylist(BuildContext context, WidgetRef ref, String id, String title) {
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
              ref.read(playlistControllerProvider.notifier).deletePlaylist(id);
              Navigator.pop(context);
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
    final state = ref.watch(doaControllerProvider);
    final controller = ref.read(doaControllerProvider.notifier);
    final playlistState = ref.watch(playlistControllerProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4);
    final glassColor = isDark
        ? const Color(0xff121814).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.9);

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    final List<PrayerItem> filteredPrayers = curatedPrayers.where((prayer) {
      if (state.selectedCategory == 'Favorit') {
        if (!state.favoriteDoaIds.contains(prayer.id)) return false;
      } else if (state.selectedCategory != 'Semua') {
        if (prayer.category != state.selectedCategory) return false;
      }

      if (state.searchQuery.isNotEmpty) {
        final query = state.searchQuery.toLowerCase();
        final matchTitle = prayer.title.toLowerCase().contains(query);
        final matchTranslation = prayer.translation.toLowerCase().contains(query);
        final matchLatin = prayer.latin.toLowerCase().contains(query);
        if (!matchTitle && !matchTranslation && !matchLatin) return false;
      }

      return true;
    }).toList();

    final categories = [
      'Semua',
      'Favorit',
      'Harian',
      'Kemudahan',
      'Perlindungan',
      'Shalat & Ibadah',
      'Qur\'an & Hadits'
    ];

    final canPop = Navigator.canPop(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Kumpulan Doa Harian',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.pop(context),
                )
              : null,
          bottom: TabBar(
            indicatorColor: accentGold,
            labelColor: isDark ? accentGold : primaryEmerald,
            unselectedLabelColor: textSecondary,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: const [
              Tab(text: 'Semua Doa'),
              Tab(text: 'Playlist Saya'),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              const AmbientLights(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // TAB 1: Semua Doa
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildSearchBar(controller, isDark, glassColor, textPrimary),
                        const SizedBox(height: 16),
                        _buildCategoryChips(state, controller, categories, isDark, accentGold, primaryEmerald),
                        const SizedBox(height: 16),
                        Expanded(
                          child: state.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(accentGold),
                                  ),
                                )
                              : filteredPrayers.isEmpty
                                  ? _buildEmptyState(state.selectedCategory, textPrimary, textSecondary)
                                  : ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.only(bottom: 24),
                                      itemCount: filteredPrayers.length,
                                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final prayer = filteredPrayers[index];
                                        final isFav = state.favoriteDoaIds.contains(prayer.id);

                                        return _buildPrayerCard(
                                          context,
                                          prayer,
                                          isFav,
                                          controller,
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

                    // TAB 2: Playlist Saya
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildCreatePlaylistButton(context, ref, glassColor, textPrimary, textSecondary, accentGold, primaryEmerald),
                        const SizedBox(height: 16),
                        Expanded(
                          child: playlistState.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(accentGold),
                                  ),
                                )
                              : playlistState.playlists.isEmpty
                                  ? _buildPlaylistEmptyState(textPrimary, textSecondary)
                                  : ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.only(bottom: 24),
                                      itemCount: playlistState.playlists.length,
                                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final playlist = playlistState.playlists[index];
                                        return _buildPlaylistCard(
                                          context,
                                          ref,
                                          playlist,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    DoaController controller,
    bool isDark,
    Color glassColor,
    Color textPrimary,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: TextField(
        onChanged: controller.setSearchQuery,
        style: TextStyle(color: textPrimary, fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Cari doa berdasarkan judul atau arti...',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(
    DoaState state,
    DoaController controller,
    List<String> categories,
    bool isDark,
    Color accentGold,
    Color primaryEmerald,
  ) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = state.selectedCategory == cat;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                cat == 'Favorit' ? '⭐ Favorit' : cat,
                style: GoogleFonts.outfit(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
              selected: isSelected,
              onSelected: (_) => controller.setSelectedCategory(cat),
              selectedColor: primaryEmerald,
              backgroundColor: isDark ? Colors.white12 : Colors.white,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? accentGold.withValues(alpha: 0.5)
                      : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05)),
                  width: 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrayerCard(
    BuildContext context,
    PrayerItem prayer,
    bool isFav,
    DoaController controller,
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
          color: isFav ? accentGold.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.05),
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
                      onTap: () => controller.toggleFavoriteDoa(prayer.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isFav ? Colors.red.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.03),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFav ? Colors.redAccent : Colors.grey,
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

  Widget _buildEmptyState(String category, Color textPrimary, Color textSecondary) {
    final isFav = category == 'Favorit';
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: (isFav ? Colors.red : Colors.grey).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFav ? Icons.favorite_border_rounded : Icons.search_off_rounded,
                color: isFav ? Colors.redAccent : Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFav ? 'Belum Ada Doa Favorit' : 'Doa Tidak Ditemukan',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isFav
                  ? 'Tandai doa dengan mengetuk ikon hati pada kartu doa agar terkumpul di sini.'
                  : 'Coba periksa kembali kata kunci pencarian Anda atau ganti filter kategori.',
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

  // ─── PLAYLIST SUB-WIDGETS ──────────────────────────────────────────────────

  Widget _buildCreatePlaylistButton(
    BuildContext context,
    WidgetRef ref,
    Color glassColor,
    Color textPrimary,
    Color textSecondary,
    Color accentGold,
    Color primaryEmerald,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isGoldBorder(context) ? accentGold.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.05),
          width: 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryEmerald.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.playlist_add_rounded, color: primaryEmerald),
          ),
          title: Text(
            'Buat Playlist Baru',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          subtitle: Text(
            'Kelompokkan doa-doa pilihan Anda',
            style: GoogleFonts.outfit(fontSize: 12, color: textSecondary),
          ),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          onTap: () => _showCreatePlaylistDialog(context, ref),
        ),
      ),
    );
  }

  bool isGoldBorder(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  Widget _buildPlaylistCard(
    BuildContext context,
    WidgetRef ref,
    PrayerPlaylist playlist,
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
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryEmerald.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.folder_special_rounded, color: primaryEmerald),
          ),
          title: Text(
            playlist.title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: textPrimary,
            ),
          ),
          subtitle: Text(
            '${playlist.doaIds.length} Doa',
            style: GoogleFonts.outfit(fontSize: 12, color: textSecondary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (value) {
                  if (value == 'rename') {
                    _showRenamePlaylistDialog(context, ref, playlist.id, playlist.title);
                  } else if (value == 'delete') {
                    _confirmDeletePlaylist(context, ref, playlist.id, playlist.title);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 8),
                        Text('Ubah Nama'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaylistDetailPage(playlistId: playlist.id),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaylistEmptyState(Color textPrimary, Color textSecondary) {
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
                Icons.folder_open_rounded,
                color: Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Playlist',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Buat playlist baru untuk mulai mengelompokkan doa-doa harian Anda.',
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
