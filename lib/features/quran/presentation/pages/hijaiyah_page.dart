import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/audio_player_helper.dart';
import '../../data/datasources/learning_local_datasource.dart';

class HijaiyahPage extends StatefulWidget {
  const HijaiyahPage({super.key});

  @override
  State<HijaiyahPage> createState() => _HijaiyahPageState();
}

class _HijaiyahPageState extends State<HijaiyahPage> {
  HijaiyahModel? _selectedLetter;
  bool _isPlaying = false;
  String? _currentUrl;
  bool _isLoadingAudio = false;
  StreamSubscription? _playerSubscription;

  @override
  void initState() {
    super.initState();
    // Select Alif by default so the bottom panel is populated initially
    _selectedLetter = LearningLocalDataSource.hijaiyahList.first;
    
    // Sync with global player state
    final helper = AudioPlayerHelper();
    _isPlaying = helper.isPlaying;
    _currentUrl = helper.currentPlayingUrl;
    
    _playerSubscription = helper.player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _currentUrl = helper.currentPlayingUrl;
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _playerSubscription?.cancel();
    super.dispose();
  }

  Future<void> _playMakhraj(HijaiyahModel letter) async {
    setState(() {
      _isLoadingAudio = true;
    });
    try {
      await AudioPlayerHelper().play(letter.audioUrl);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Koneksi internet bermasalah. Gagal memutar audio makhraj.',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hijaiyahList = LearningLocalDataSource.hijaiyahList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Huruf Hijaiyah',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const AmbientLights(),
          Column(
            children: [
              // Informative Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.accent.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ketuk huruf untuk memutar makhraj suaranya, and lihat detail penyambungan di bawah.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 28 Hijaiyah Grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: hijaiyahList.length,
                  itemBuilder: (context, index) {
                    final letter = hijaiyahList[index];
                    final isSelected = _selectedLetter?.name == letter.name;
                    final isThisPlaying = _isPlaying && _currentUrl == letter.audioUrl;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedLetter = letter;
                        });
                        _playMakhraj(letter);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.highlightDark : AppColors.highlightLight)
                              : (isDark ? AppColors.cardDark : Colors.white),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.accent.withOpacity(0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Sound Indicator Icon
                            Positioned(
                              top: 6,
                              right: 6,
                              child: Icon(
                                isThisPlaying
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_mute_rounded,
                                size: 14,
                                color: isThisPlaying
                                    ? AppColors.accent
                                    : (isDark ? Colors.white30 : Colors.black26),
                              ),
                            ),
                            // Letter content
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  letter.arabic,
                                  style: AppTheme.arabicStyle(fontSize: 30, color: AppColors.accent).copyWith(
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  letter.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppColors.textLightPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Detail Panel at Bottom
              if (_selectedLetter != null) _buildDetailPanel(isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPanel(bool isDark) {
    final letter = _selectedLetter!;
    final isThisPlaying = _isPlaying && _currentUrl == letter.audioUrl;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF073822)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  letter.arabic,
                  style: AppTheme.arabicStyle(fontSize: 34, color: Colors.white).copyWith(
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Huruf ${letter.name}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textLightPrimary,
                      ),
                    ),
                    Text(
                      'Makhraj & Penulisan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _playMakhraj(letter),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: _isLoadingAudio
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.accent,
                            ),
                          )
                        : Icon(
                            isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: AppColors.accent,
                            size: 24,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Tempat Keluar Huruf (Makhraj):',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : AppColors.textLightPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            letter.makhraj,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Bentuk Penulisan Huruf:',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : AppColors.textLightPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShapeCard('Tunggal', letter.isolated, isDark),
              _buildShapeCard('Awal', letter.initial, isDark),
              _buildShapeCard('Tengah', letter.medial, isDark),
              _buildShapeCard('Akhir', letter.finalForm, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShapeCard(String label, String glyph, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF131C2E) : const Color(0xFFF8F8F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            Text(
              glyph,
              style: AppTheme.arabicStyle(fontSize: 22, color: AppColors.accent).copyWith(
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
