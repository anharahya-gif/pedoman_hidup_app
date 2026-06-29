import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/quran_providers.dart';

class FontSettingsSheet extends ConsumerWidget {
  const FontSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(quranFontSettingsProvider);
    final notifier = ref.read(quranFontSettingsProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : AppColors.textLightPrimary;
    final labelColor = isDark ? Colors.white70 : AppColors.textLightSecondary;
    final sheetBg = isDark ? const Color(0xff0d1510) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ukuran Teks Quran',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),

            // Live Preview Box
            Text(
              'Pratinjau Teks',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black12,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    style: AppTheme.arabicStyle(
                      fontSize: settings.arabicFontSize,
                      color: isDark ? Colors.white : AppColors.textLightPrimary,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: settings.latinFontSize,
                      color: labelColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Arabic Font Size Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ukuran Huruf Arab',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                Text(
                  '${settings.arabicFontSize.toInt()} px',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: isDark ? Colors.white10 : Colors.black12,
                thumbColor: AppColors.accent,
                overlayColor: AppColors.accent.withOpacity(0.12),
                valueIndicatorColor: AppColors.primary,
              ),
              child: Slider(
                value: settings.arabicFontSize,
                min: 20.0,
                max: 40.0,
                divisions: 20,
                onChanged: (val) {
                  notifier.setArabicFontSize(val);
                },
              ),
            ),
            const SizedBox(height: 12),

            // Latin/Translation Font Size Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ukuran Teks Terjemahan',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                Text(
                  '${settings.latinFontSize.toInt()} px',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: isDark ? Colors.white10 : Colors.black12,
                thumbColor: AppColors.accent,
                overlayColor: AppColors.accent.withOpacity(0.12),
                valueIndicatorColor: AppColors.primary,
              ),
              child: Slider(
                value: settings.latinFontSize,
                min: 12.0,
                max: 24.0,
                divisions: 12,
                onChanged: (val) {
                  notifier.setLatinFontSize(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
