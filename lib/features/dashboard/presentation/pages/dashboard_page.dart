import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/providers.dart';
import '../../../quran/presentation/providers/quran_providers.dart';
import '../../../quran/presentation/pages/surah_detail_page.dart';
import '../../../ibadah/presentation/controllers/ibadah_controller.dart';
import '../../../ibadah/presentation/pages/prayers_after_shalat_page.dart';
import '../../../../core/services/auth_service.dart';
import '../../../ayah/presentation/widgets/ayah_of_the_day_card.dart';
import '../../../ibadah/domain/entities/ibadah_log.dart';

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

  int _calculateWorshipStreak(List<IbadahLog> logs) {
    if (logs.isEmpty) return 0;

    final sortedLogs = List<IbadahLog>.from(logs);
    sortedLogs.sort((a, b) => b.date.compareTo(a.date));

    bool hasWorship(IbadahLog log) {
      bool hasShalat = log.subuh != 'belum' ||
          log.dzuhur != 'belum' ||
          log.ashar != 'belum' ||
          log.maghrib != 'belum' ||
          log.isya != 'belum';
      bool hasOther = log.quranPages > 0 ||
          log.dhikrCount > 0 ||
          log.duha == 1 ||
          log.tahajjud == 1 ||
          log.sedekah == 1;
      return hasShalat || hasOther;
    }

    int streak = 0;
    DateTime checkDate = DateTime.now();

    String formatDate(DateTime dt) {
      return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    }

    final todayStr = formatDate(checkDate);
    final yesterdayStr = formatDate(checkDate.subtract(const Duration(days: 1)));

    final hasToday = sortedLogs.any((l) => l.date == todayStr && hasWorship(l));
    final hasYesterday = sortedLogs.any((l) => l.date == yesterdayStr && hasWorship(l));

    if (!hasToday && !hasYesterday) {
      return 0;
    }

    DateTime current = hasToday ? checkDate : checkDate.subtract(const Duration(days: 1));
    while (true) {
      final curStr = formatDate(current);
      final index = sortedLogs.indexWhere((l) => l.date == curStr);
      if (index != -1 && hasWorship(sortedLogs[index])) {
        streak++;
        current = current.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Widget _buildPrayerDot(String label, String status, Color primaryEmerald, Color accentGold, Color textSecondary) {
    final isDone = status == 'berjamaah' || status == 'munfarid';
    final isMissed = status == 'terlewat';
    final isQadha = status == 'qadha';

    Color dotColor;
    IconData icon;
    if (isDone) {
      dotColor = accentGold;
      icon = Icons.check_circle_rounded;
    } else if (isMissed) {
      dotColor = Colors.redAccent;
      icon = Icons.cancel_rounded;
    } else if (isQadha) {
      dotColor = Colors.orangeAccent;
      icon = Icons.history_rounded;
    } else {
      dotColor = Colors.grey.withValues(alpha: 0.3);
      icon = Icons.circle_outlined;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Icon(
          icon,
          color: dotColor,
          size: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lastRead = ref.watch(lastReadProvider);

    final ibadahState = ref.watch(ibadahControllerProvider);
    int shalatSelesai = 0;
    if (ibadahState.ibadahLog != null) {
      final log = ibadahState.ibadahLog!;
      if (log.subuh == 'berjamaah' || log.subuh == 'munfarid') shalatSelesai++;
      if (log.dzuhur == 'berjamaah' || log.dzuhur == 'munfarid') shalatSelesai++;
      if (log.ashar == 'berjamaah' || log.ashar == 'munfarid') shalatSelesai++;
      if (log.maghrib == 'berjamaah' || log.maghrib == 'munfarid') shalatSelesai++;
      if (log.isya == 'berjamaah' || log.isya == 'munfarid') shalatSelesai++;
    }

    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.valueOrNull;
    final displayName = user?.displayName ?? 'Hamba Allah';
    final photoUrl = user?.photoURL;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4);
    final glassColor = isDark
        ? const Color(0xff121814).withValues(alpha: 0.8)
        : Colors.white.withValues(alpha: 0.9);

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientLights(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Salam Greeting Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
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
                              'Assalamu\'alaikum,',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: textSecondary,
                              ),
                            ),
                            Text(
                              displayName,
                              style: GoogleFonts.outfit(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormatter.formatIndonesianDate(DateTime.now()),
                              style: TextStyle(
                                fontSize: 11,
                                color: textSecondary.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          // Switch to Settings tab
                          ref.read(bottomNavIndexProvider.notifier).state = 4;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: accentGold.withValues(alpha: 0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentGold.withValues(alpha: 0.15),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05),
                            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                            child: photoUrl == null
                                ? const Icon(
                                    Icons.person_outline_rounded,
                                    color: accentGold,
                                    size: 26,
                                  )
                                : null,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Ayat Hari Ini (Ayah of the Day) Card
                  const AyahOfTheDayCard(),
                  const SizedBox(height: 24),

                  // 3. Terakhir Dibaca Banner
                  _buildLastReadCard(context, ref, lastRead, isDark, primaryEmerald, accentGold),
                  const SizedBox(height: 24),

                  // 4. Ringkasan Ibadah Card
                  _buildIbadahSummaryCard(
                    context,
                    ref,
                    ibadahState.ibadahLog,
                    ibadahState.allLogs,
                    shalatSelesai,
                    glassColor,
                    textPrimary,
                    textSecondary,
                    accentGold,
                    primaryEmerald,
                  ),
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
                        ref.read(bottomNavIndexProvider.notifier).state = 0;
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
    BuildContext context,
    WidgetRef ref,
    IbadahLog? log,
    List<IbadahLog> allLogs,
    int selesaiCount,
    Color glassColor,
    Color textPrimary,
    Color textSecondary,
    Color accentGold,
    Color primaryEmerald,
  ) {
    final progress = selesaiCount / 5;
    final streak = _calculateWorshipStreak(allLogs);

    String getMotivationalText() {
      if (selesaiCount == 0) {
        return 'Mari awali hari dengan Shalat Subuh tepat waktu. Semangat menjaga ibadah!';
      } else if (selesaiCount >= 1 && selesaiCount <= 2) {
        return 'Bagus! Jaga shalat fardhu berikutnya. Setiap sujud mendekatkanmu kepada-Nya.';
      } else if (selesaiCount >= 3 && selesaiCount <= 4) {
        return 'Hebat! Tinggal sedikit lagi lengkap. Semangat menuntaskan shalat fardhu hari ini!';
      } else {
        return 'Alhamdulillah! Seluruh shalat fardhu hari ini lengkap. Semoga istiqomah dan berkah!';
      }
    }

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shalat Hari Ini',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  if (streak > 0) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Text(
                          '🔥 ',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          '$streak Hari Istiqomah',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: accentGold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPrayerDot('Subuh', log?.subuh ?? 'belum', primaryEmerald, accentGold, textSecondary),
              _buildPrayerDot('Dzuhur', log?.dzuhur ?? 'belum', primaryEmerald, accentGold, textSecondary),
              _buildPrayerDot('Ashar', log?.ashar ?? 'belum', primaryEmerald, accentGold, textSecondary),
              _buildPrayerDot('Maghrib', log?.maghrib ?? 'belum', primaryEmerald, accentGold, textSecondary),
              _buildPrayerDot('Isya', log?.isya ?? 'belum', primaryEmerald, accentGold, textSecondary),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark(ref) ? Colors.white.withValues(alpha: 0.03) : primaryEmerald.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark(ref) ? Colors.white.withValues(alpha: 0.05) : primaryEmerald.withValues(alpha: 0.05),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: accentGold,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    getMotivationalText(),
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
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
                ref.read(bottomNavIndexProvider.notifier).state = 1;
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
            ref.read(bottomNavIndexProvider.notifier).state = 0;
          },
        ),
        const SizedBox(height: 12),
        buildItem(
          label: 'Jadwal & Catatan Shalat',
          desc: 'Sesuaikan jadwal adzan kota & catat shalat fardhu',
          icon: Icons.mosque_rounded,
          color: const Color(0xffd4af37),
          onTap: () {
            ref.read(bottomNavIndexProvider.notifier).state = 1;
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
