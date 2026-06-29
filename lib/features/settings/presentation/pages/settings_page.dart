import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/sync_service.dart';
import '../../../../shared/providers.dart';
import '../../../quran/presentation/providers/quran_providers.dart';
import '../../../quran/presentation/widgets/font_settings_sheet.dart';

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

                // 2. PENGATURAN BACAAN SECTION
                _buildSectionHeader('Pengaturan Bacaan', textPrimary),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildFontSettingsOption(
                        context: context,
                        ref: ref,
                        isDark: isDark,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 3. AKUN & SINKRONISASI CLOUD
                _buildSectionHeader('Akun & Sinkronisasi Cloud', textPrimary),
                const SizedBox(height: 12),
                _buildCloudSyncCard(
                  context: context,
                  ref: ref,
                  cardColor: cardColor,
                  isDark: isDark,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  primaryEmerald: primaryEmerald,
                  accentGold: accentGold,
                ),
                const SizedBox(height: 28),

                // 4. TENTANG APLIKASI
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
                              'Versi 2.0.0',
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
                        'Pedoman Hidup adalah aplikasi Islami terpadu yang memadukan Al-Quran Digital (dengan audio murattal lengkap per-ayat dan tajwid warna bacaan), pelacak Ibadah Hub harian, dan kumpulan Doa & Dzikir Harian. Aplikasi ini berjalan secara offline-first dengan enkripsi data aman dan mendukung sinkronisasi cadangan data cloud opsional via Google Sign-In.',
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

  Widget _buildCloudSyncCard({
    required BuildContext context,
    required WidgetRef ref,
    required Color cardColor,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryEmerald,
    required Color accentGold,
  }) {
    final userAsync = ref.watch(authStateProvider);
    final syncStatus = ref.watch(syncStatusProvider);
    final lastSyncStr = ref.watch(sharedPreferencesProvider).getString('last_sync_time');
    
    String lastSyncText = 'Belum pernah disinkronkan';
    if (lastSyncStr != null) {
      try {
        final dt = DateTime.parse(lastSyncStr);
        lastSyncText = '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {}
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: userAsync.when(
        data: (user) {
          if (user == null) {
            // State: Belum Login
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud_off_rounded, color: textSecondary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Penyimpanan Lokal Aktif',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Data Anda saat ini hanya tersimpan secara lokal di device ini. Masuk dengan akun Google untuk mengaktifkan sinkronisasi otomatis agar data aman saat Anda berganti device.',
                  style: TextStyle(fontSize: 12.5, color: textSecondary, height: 1.4),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xff182b20) : const Color(0xffe8f3ee),
                      foregroundColor: isDark ? accentGold : primaryEmerald,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: isDark ? accentGold.withValues(alpha: 0.4) : primaryEmerald.withValues(alpha: 0.2),
                          width: 1.2,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await ref.read(authServiceProvider).signInWithGoogle();
                        // Sinkronisasi otomatis pertama kali setelah login
                        await ref.read(syncServiceProvider).syncAllData(ref);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil masuk dan menyinkronkan data dengan Cloud!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal masuk: $e')),
                        );
                      }
                    },
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                      height: 18,
                      width: 18,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.login_rounded, size: 18),
                    ),
                    label: Text(
                      'Masuk dengan Google',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                  ),
                ),
              ],
            );
          }

          // State: Sudah Login
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: primaryEmerald.withValues(alpha: 0.2),
                    backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? Icon(Icons.person_rounded, color: accentGold) : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName ?? 'Pengguna',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textPrimary,
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: TextStyle(fontSize: 12, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryEmerald.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentGold.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_done_rounded, color: accentGold, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Aktif',
                          style: GoogleFonts.outfit(fontSize: 10, color: accentGold, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white10),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sinkronisasi Terakhir:',
                    style: TextStyle(fontSize: 12, color: textSecondary),
                  ),
                  Text(
                    lastSyncText,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryEmerald,
                        foregroundColor: accentGold,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: accentGold, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: syncStatus == SyncStatus.syncing
                          ? null
                          : () async {
                              try {
                                await ref.read(syncServiceProvider).syncAllData(ref);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Sinkronisasi data sukses!')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Sinkronisasi gagal: $e')),
                                );
                              }
                            },
                      icon: syncStatus == SyncStatus.syncing
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(color: accentGold, strokeWidth: 2),
                            )
                          : const Icon(Icons.sync_rounded, size: 16),
                      label: Text(
                        syncStatus == SyncStatus.syncing ? 'Menyinkronkan...' : 'Sinkronkan',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () async {
                      try {
                        await ref.read(authServiceProvider).signOut();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil keluar akun.')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal keluar: $e')),
                        );
                      }
                    },
                    icon: const Icon(Icons.logout_rounded, size: 16),
                    label: Text(
                      'Keluar',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xffd4af37)),
        ),
        error: (err, stack) => Text('Terjadi kesalahan memuat status akun: $err'),
      ),
    );
  }

  Widget _buildFontSettingsOption({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final fontSettings = ref.watch(quranFontSettingsProvider);
    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xff0b3b24).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.format_size_rounded,
            color: Color(0xffd4af37),
            size: 22,
          ),
        ),
        title: Text(
          'Ukuran Font Quran & Tafsir',
          style: GoogleFonts.outfit(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        subtitle: Text(
          'Arab: ${fontSettings.arabicFontSize.toInt()} px • Terjemahan: ${fontSettings.latinFontSize.toInt()} px',
          style: TextStyle(
            fontSize: 12,
            color: textSecondary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const FontSettingsSheet(),
          );
        },
      ),
    );
  }
}
