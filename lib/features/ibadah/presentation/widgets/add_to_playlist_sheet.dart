import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/prayer_item.dart';
import '../controllers/playlist_controller.dart';

class AddToPlaylistSheet extends ConsumerStatefulWidget {
  final PrayerItem prayer;

  const AddToPlaylistSheet({
    super.key,
    required this.prayer,
  });

  @override
  ConsumerState<AddToPlaylistSheet> createState() => _AddToPlaylistSheetState();
}

class _AddToPlaylistSheetState extends ConsumerState<AddToPlaylistSheet> {
  final TextEditingController _textController = TextEditingController();
  bool _isCreatingNew = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _createNewPlaylist() {
    final title = _textController.text.trim();
    if (title.isNotEmpty) {
      ref.read(playlistControllerProvider.notifier).createPlaylist(title);
      _textController.clear();
      setState(() {
        _isCreatingNew = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistControllerProvider);
    final playlistController = ref.read(playlistControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff090f0c) : const Color(0xfff7f9f8);
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tambah ke Playlist',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : primaryEmerald,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),
          Text(
            widget.prayer.title,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          if (_isCreatingNew) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    autofocus: true,
                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Nama playlist baru...',
                      hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: accentGold),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _createNewPlaylist,
                  icon: const Icon(Icons.check_circle_rounded, color: accentGold),
                ),
                IconButton(
                  onPressed: () => setState(() => _isCreatingNew = false),
                  icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                ),
              ],
            ),
          ] else ...[
            TextButton.icon(
              onPressed: () => setState(() => _isCreatingNew = true),
              icon: const Icon(Icons.add_circle_outline_rounded, color: accentGold),
              label: Text(
                'Buat Playlist Baru',
                style: GoogleFonts.outfit(
                  color: accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 12),
          
          if (playlistState.playlists.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text(
                  'Belum ada playlist. Silakan buat playlist baru.',
                  style: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: playlistState.playlists.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final playlist = playlistState.playlists[index];
                  final contains = playlist.doaIds.contains(widget.prayer.id);

                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: contains ? accentGold.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: CheckboxListTile(
                        title: Text(
                          playlist.title,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '${playlist.doaIds.length} Doa',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        value: contains,
                        activeColor: primaryEmerald,
                        checkColor: accentGold,
                        onChanged: (val) {
                          if (val == true) {
                            playlistController.addPrayerToPlaylist(playlist.id, widget.prayer.id);
                          } else {
                            playlistController.removePrayerFromPlaylist(playlist.id, widget.prayer.id);
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
