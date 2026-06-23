import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../../../core/theme/theme_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4);
    final cardColor = isDark
        ? const Color(0xff121814).withValues(alpha: 0.8)
        : Colors.white;

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientLights(),
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // 1. TAMPILAN TEMA SECTION
                _buildSectionHeader('Tampilan & Tema', textPrimary),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildThemeOption(
                        title: 'Mode Terang ☀️',
                        selected: themeMode == ThemeMode.light,
                        onTap: () => themeNotifier.setThemeMode(ThemeMode.light),
                        isDark: isDark,
                        primaryEmerald: primaryEmerald,
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.white10),
                      _buildThemeOption(
                        title: 'Mode Gelap 🌙',
                        selected: themeMode == ThemeMode.dark,
                        onTap: () => themeNotifier.setThemeMode(ThemeMode.dark),
                        isDark: isDark,
                        primaryEmerald: primaryEmerald,
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.white10),
                      _buildThemeOption(
                        title: 'Ikuti Sistem 🖥️',
                        selected: themeMode == ThemeMode.system,
                        onTap: () => themeNotifier.setThemeMode(ThemeMode.system),
                        isDark: isDark,
                        primaryEmerald: primaryEmerald,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 2. TENTANG APLIKASI
                _buildSectionHeader('Tentang Aplikasi', textPrimary),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: primaryEmerald.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: accentGold.withValues(alpha: 0.3), width: 1.5),
                              ),
                              child: const Icon(
                                Icons.mosque_rounded,
                                color: accentGold,
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Pedoman Hidup',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            Text(
                              'Versi 1.0.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white10),
                      const SizedBox(height: 16),
                      Text(
                        'Deskripsi',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? accentGold : primaryEmerald,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pedoman Hidup adalah aplikasi Islami terpadu yang memadukan Al-Quran Digital (dengan audio murattal lengkap per-ayat dan tajwid warna bacaan), pelacak Ibadah Hub harian, dan kumpulan Doa & Dzikir Harian. Aplikasi ini berjalan sepenuhnya luring (offline-first) tanpa iklan atau pelacakan cloud demi kekhusyukan ibadah Anda.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Privasi & Keamanan',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isDark ? accentGold : primaryEmerald,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Seluruh data ibadah, catatan bacaan, dan penanda bookmark disimpan secara lokal di perangkat Anda menggunakan SQLite terenkripsi bawaan sistem. Tidak ada data yang dikirimkan ke server eksternal.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildThemeOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    required bool isDark,
    required Color primaryEmerald,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
        ),
        trailing: selected
            ? const Icon(Icons.check_circle_rounded, color: Color(0xffd4af37))
            : const Icon(Icons.circle_outlined, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: onTap,
      ),
    );
  }
}
