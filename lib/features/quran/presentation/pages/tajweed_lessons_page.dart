import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/learning_local_datasource.dart';

class TajweedLessonsPage extends StatelessWidget {
  const TajweedLessonsPage({super.key});

  Color _getTajweedColor(String category, bool isDark) {
    switch (category) {
      case 'Nun Sakinah & Tanwin':
        return isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32); // Green
      case 'Mim Sakinah':
        return isDark ? const Color(0xFFF48FB1) : const Color(0xFFC2185B); // Pink
      case 'Hukum Mad':
        return isDark ? const Color(0xFFFFE082) : const Color(0xFFFBC02D); // Amber Gold
      case 'Hukum Lam':
        return isDark ? const Color(0xFFB2DFDB) : const Color(0xFF00796B); // Teal
      case 'Qalqalah':
        return isDark ? const Color(0xFFB2FF59) : const Color(0xFF64DD17); // Lime Green
      case 'Hukum Ra\'':
        return isDark ? const Color(0xFFB0BEC5) : const Color(0xFF455A64); // Blue Grey
      default:
        return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lessons = LearningLocalDataSource.lessons;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hukum Tajwid',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final ruleColor = _getTajweedColor(lesson.category, isDark);

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TajweedLessonDetailPage(
                      lesson: lesson,
                      themeColor: ruleColor,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 48,
                      decoration: BoxDecoration(
                        color: ruleColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: ruleColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              lesson.category,
                              style: GoogleFonts.plusJakartaSans(
                                color: ruleColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            lesson.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : AppColors.textLightPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TajweedLessonDetailPage extends StatelessWidget {
  final TajweedLessonModel lesson;
  final Color themeColor;

  const TajweedLessonDetailPage({
    super.key,
    required this.lesson,
    required this.themeColor,
  });

  List<Map<String, String>> _parseExamples(String examplesStr) {
    final List<Map<String, String>> result = [];
    final items = examplesStr.split(',');
    for (var item in items) {
      final trimmed = item.trim();
      if (trimmed.isEmpty) continue;
      
      final openParen = trimmed.indexOf('(');
      final closeParen = trimmed.indexOf(')');
      
      if (openParen != -1 && closeParen != -1 && closeParen > openParen) {
        final arabic = trimmed.substring(0, openParen).trim();
        final label = trimmed.substring(openParen + 1, closeParen).trim();
        result.add({'arabic': arabic, 'label': label});
      } else {
        result.add({'arabic': trimmed, 'label': ''});
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final parsedExamples = _parseExamples(lesson.examples);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                lesson.title,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeColor.withOpacity(0.9),
                      themeColor.withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.import_contacts_rounded,
                        size: 150,
                        color: Colors.white.withOpacity(0.12),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text(
                          lesson.category,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PENJELASAN HUKUM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Text(
                      lesson.content,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'CONTOH LAFAL & BACAAN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (parsedExamples.isNotEmpty)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: parsedExamples.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final example = parsedExamples[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: themeColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: themeColor.withOpacity(0.2)),
                                ),
                                child: Text(
                                  example['label'] ?? '',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: themeColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    example['arabic'] ?? '',
                                    textDirection: TextDirection.rtl,
                                    style: AppTheme.arabicStyle(fontSize: 26, color: AppColors.accent).copyWith(
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        lesson.examples,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
