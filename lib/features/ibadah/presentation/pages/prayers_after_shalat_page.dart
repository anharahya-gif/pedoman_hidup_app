import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../data/constants/prayers_after_shalat.dart';
import '../controllers/doa_controller.dart';

class PrayersAfterShalatPage extends ConsumerStatefulWidget {
  const PrayersAfterShalatPage({super.key});

  @override
  ConsumerState<PrayersAfterShalatPage> createState() => _PrayersAfterShalatPageState();
}

class _PrayersAfterShalatPageState extends ConsumerState<PrayersAfterShalatPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(doaControllerProvider.notifier).resetDhikrSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doaControllerProvider);
    final controller = ref.read(doaControllerProvider.notifier);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const primaryEmerald = Color(0xff0b3b24);
    const accentGold = Color(0xffd4af37);
    final bgColor = isDark ? const Color(0xff070c09) : const Color(0xfff3f6f4);

    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white60 : Colors.black54;

    final steps = prayersAfterShalatSteps;
    final currentStepIndex = state.activeDhikrStepIndex;
    final currentStep = steps[currentStepIndex < steps.length ? currentStepIndex : steps.length - 1];

    final double progress = state.isDhikrCompleted
        ? 1.0
        : state.activeDhikrCount / currentStep.targetCount;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Dzikir Setelah Shalat',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientLights(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: state.isDhikrCompleted
                  ? _buildCelebrationScreen(context, textPrimary, textSecondary, accentGold, primaryEmerald)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Langkah ${currentStep.stepNumber} dari ${steps.length}',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.5,
                                    color: accentGold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  currentStep.title,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (currentStepIndex) / steps.length,
                                backgroundColor: isDark ? Colors.white12 : Colors.black12,
                                valueColor: const AlwaysStoppedAnimation<Color>(primaryEmerald),
                                minHeight: 5,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentStep.arabic,
                                    style: GoogleFonts.amiri(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: textPrimary,
                                      height: 1.6,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    currentStep.latin,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: accentGold,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Text(
                                      '"${currentStep.translation}"',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: textSecondary,
                                        height: 1.4,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Column(
                          children: [
                            GestureDetector(
                              onTap: controller.incrementDhikr,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    height: 140,
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 8,
                                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
                                      valueColor: const AlwaysStoppedAnimation<Color>(accentGold),
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryEmerald.withValues(alpha: 0.9),
                                      border: Border.all(
                                        color: accentGold.withValues(alpha: 0.3),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryEmerald.withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          spreadRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${state.activeDhikrCount}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 36,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '/ ${currentStep.targetCount}',
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'KETUK LINGKARAN UNTUK BERDZIKIR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: textSecondary.withValues(alpha: 0.6),
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton.icon(
                              onPressed: controller.resetDhikrSession,
                              icon: const Icon(Icons.refresh_rounded, size: 16),
                              label: const Text('Reset Sesi'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey,
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: controller.skipToNextStep,
                              icon: const Icon(Icons.skip_next_rounded, size: 16),
                              label: const Text('Lewati Langkah'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryEmerald,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    );
  }

  Widget _buildCelebrationScreen(
    BuildContext context,
    Color textPrimary,
    Color textSecondary,
    Color accentGold,
    Color primaryEmerald,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primaryEmerald.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: accentGold.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: accentGold,
              size: 72,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Alhamdulillah!',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Anda telah menyelesaikan seluruh urutan dzikir dan doa setelah shalat fardhu.',
              style: TextStyle(
                fontSize: 13.5,
                color: textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryEmerald,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              'Kembali ke Ibadah Hub',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
