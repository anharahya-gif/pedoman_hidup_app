import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/providers.dart';
import '../../../quran/presentation/providers/quran_providers.dart';
import '../../../quran/presentation/pages/surah_detail_page.dart';
import '../../../ibadah/presentation/controllers/ibadah_controller.dart';
import '../../../ibadah/presentation/pages/prayers_after_shalat_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18.5) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastRead = ref.watch(lastReadProvider);
    final ibadahState = ref.watch(ibadahControllerProvider);
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

    // Hitung shalat selesai hari ini
    int shalatSelesai = 0;
    if (ibadahState.ibadahLog != null) {
      final log = ibadahState.ibadahLog!;
      if (log.subuh == 'berjamaah' || log.subuh == 'munfarid') shalatSelesai++;
      if (log.dzuhur == 'berjamaah' || log.dzuhur == 'munfarid') shalatSelesai++;
      if (log.ashar == 'berjamaah' || log.ashar == 'munfarid') shalatSelesai++;
      if (log.maghrib == 'berjamaah' || log.maghrib == 'munfarid') shalatSelesai++;
      if (log.isya == 'berjamaah' || log.isya == 'munfarid') shalatSelesai++;
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            _buildAmbientLights(isDark),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Salam Greeting Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getTimeBasedGreeting(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Assalamu\'alaikum',
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: accentGold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormatter.formatIndonesianDate(DateTime.now()),
                    style: TextStyle(
                      fontSize: 11,
                      color: textSecondary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Terakhir Dibaca Banner
                  _buildLastReadCard(context, ref, lastRead, isDark, primaryEmerald, accentGold),
                  const SizedBox(height: 24),

                  // 3. Ringkasan Ibadah Card
                  _buildIbadahSummaryCard(ref, shalatSelesai, glassColor, textPrimary, textSecondary, accentGold, primaryEmerald),
                  const SizedBox(height: 28),

                  // 4. Quick Actions
                  _buildSectionTitle('Akses Cepat', textPrimary),
                  const SizedBox(height: 12),
                  _buildQuickActionsGrid(context, ref, glassColor, textPrimary, textSecondary),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbientLights(bool isDark) {
    if (!isDark) return const SizedBox.shrink();
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x1a0b3b24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildLastReadCard(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic>? lastRead,
    bool isDark,
    Color primaryEmerald,
    Color accentGold,
  ) {
    final hasLastRead = lastRead != null;
    final surahName = lastRead?['surah_name'] as String? ?? '';
    final surahNumber = lastRead?['surah_number'] as int? ?? 1;
    final verseNumber = lastRead?['verse_number'] as int? ?? 1;
    final verseTextLatin = lastRead?['verse_text_latin'] as String? ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryEmerald, const Color(0xff143f2a)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: accentGold.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryEmerald.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.menu_book_rounded,
                size: 150,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bookmark_outline_rounded, color: accentGold, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Terakhir Dibaca',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (hasLastRead) ...[
                    Text(
                      surahName,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ayat Ke-$verseNumber',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (verseTextLatin.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        verseTextLatin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahDetailPage(
                              surahNumber: surahNumber,
                              surahName: surahName,
                              highlightVerseNumber: verseNumber,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryEmerald,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Lanjutkan Membaca',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Belum ada riwayat membaca',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Mulai rutinitas tilawah Al-Quran harian Anda sekarang.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Switch to Quran tab
                        ref.read(bottomNavIndexProvider.notifier).state = 1;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryEmerald,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Mulai Membaca',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIbadahSummaryCard(
    WidgetRef ref,
    int selesaiCount,
    Color glassColor,
    Color textPrimary,
    Color textSecondary,
    Color accentGold,
    Color primaryEmerald,
  ) {
    final progress = selesaiCount / 5;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryEmerald.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mosque_rounded, color: primaryEmerald, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Shalat Hari Ini',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$selesaiCount / 5 Selesai',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: selesaiCount == 5 ? Colors.green : textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark(ref) ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              valueColor: AlwaysStoppedAnimation<Color>(selesaiCount == 5 ? Colors.green : primaryEmerald),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Icon(Icons.arrow_forward_rounded, size: 16, color: accentGold),
              label: Text(
                'Catat Ibadah',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: accentGold,
                ),
              ),
              onPressed: () {
                // Switch to Ibadah Hub tab
                ref.read(bottomNavIndexProvider.notifier).state = 2;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(
    BuildContext context,
    WidgetRef ref,
    Color glassColor,
    Color textPrimary,
    Color textSecondary,
  ) {
    Widget buildItem({
      required String label,
      required String desc,
      required IconData icon,
      required Color color,
      required VoidCallback onTap,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: glassColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: textSecondary.withValues(alpha: 0.4),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        buildItem(
          label: 'Al-Quran Digital',
          desc: 'Baca surah, tafsir & tajwid warna lengkap',
          icon: Icons.menu_book_rounded,
          color: Colors.green,
          onTap: () {
            ref.read(bottomNavIndexProvider.notifier).state = 1;
          },
        ),
        const SizedBox(height: 12),
        buildItem(
          label: 'Jadwal & Catatan Shalat',
          desc: 'Sesuaikan jadwal adzan kota & catat shalat fardhu',
          icon: Icons.mosque_rounded,
          color: const Color(0xffd4af37),
          onTap: () {
            ref.read(bottomNavIndexProvider.notifier).state = 2;
          },
        ),
        const SizedBox(height: 12),
        buildItem(
          label: 'Dzikir Setelah Shalat',
          desc: 'Panduan interaktif & counter dzikir fardhu',
          icon: Icons.grain_rounded,
          color: Colors.teal,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrayersAfterShalatPage()),
            );
          },
        ),
        const SizedBox(height: 12),
        buildItem(
          label: 'Kumpulan Doa Harian',
          desc: 'Kumpulan doa perlindungan, kelapangan & ibadah',
          icon: Icons.auto_stories_rounded,
          color: Colors.indigoAccent,
          onTap: () {
            ref.read(bottomNavIndexProvider.notifier).state = 3;
          },
        ),
      ],
    );
  }

  bool isDark(WidgetRef ref) {
    return ref.context.mounted && Theme.of(ref.context).brightness == Brightness.dark;
  }
}
