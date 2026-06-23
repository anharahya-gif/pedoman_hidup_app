import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'hijaiyah_page.dart';
import 'tajweed_lessons_page.dart';
import 'quiz_page.dart';

class LearningTab extends StatelessWidget {
  const LearningTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDark ? AppColors.cardDark : Colors.white,
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tingkatkan Bacaan Anda',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : AppColors.textLightPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pelajari cara membaca Al-Quran dengan baik dan benar melalui makhraj huruf dan hukum tajwid terstruktur.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.accent,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            'MENU BELAJAR',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: AppColors.accent,
            ),
          ),
        ),

        _buildLearningMenuCard(
          context: context,
          title: 'Huruf Hijaiyah & Makhraj',
          subtitle: 'Belajar 28 Huruf Al-Quran',
          description: 'Lafalkan huruf hijaiyah dengan audio interaktif, letak makhraj yang benar, serta cara menyambung huruf.',
          icon: Icons.grid_view_rounded,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F766E), // Teal
              AppColors.primary, // Emerald
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HijaiyahPage()),
            );
          },
        ),
        const SizedBox(height: 16),

        _buildLearningMenuCard(
          context: context,
          title: 'Pusat Hukum Tajwid',
          subtitle: 'Kuasai Aturan Membaca',
          description: 'Pahami hukum Nun & Mim Sukun, Mad (panjang), Qalqalah, Ra, dll., lengkap dengan contoh lafal yang interaktif.',
          icon: Icons.menu_book_rounded,
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB45309), // Warm Amber
              AppColors.accent,  // Luxurious Gold
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TajweedLessonsPage()),
            );
          },
        ),
        const SizedBox(height: 16),

        _buildLearningMenuCard(
          context: context,
          title: 'Kuis Evaluasi Tajwid',
          subtitle: 'Uji Kemampuan Anda',
          description: 'Asah pemahaman Anda melalui 10 pertanyaan kuis pilihan ganda yang dirancang secara menyenangkan.',
          icon: Icons.quiz_rounded,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1E3A8A), // Indigo
              Color(0xFF3B82F6), // Ocean Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizPage()),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLearningMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              children: [
                Positioned(
                  right: -10,
                  bottom: -10,
                  child: Icon(
                    icon,
                    size: 110,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
