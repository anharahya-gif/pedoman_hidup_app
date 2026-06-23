import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart'; // sharing helper
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/audio_player_helper.dart';
import '../../../../core/utils/tajweed_parser.dart';
import '../../data/models/ayat_model.dart';
import '../providers/quran_providers.dart';
import '../widgets/rub_el_hizb.dart';
import 'tafsir_page.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;
  final int? highlightVerseNumber;

  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
    this.highlightVerseNumber,
  });

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _verseKeys = {};
  String? _currentPlayingUrl;
  bool _isAudioPlaying = false;
  late AudioPlayerHelper _audioHelper;

  @override
  void initState() {
    super.initState();
    _audioHelper = AudioPlayerHelper();
    
    _audioHelper.onStateChanged = (url, playing) {
      if (mounted) {
        setState(() {
          _currentPlayingUrl = url;
          _isAudioPlaying = playing;
        });
      }
    };
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _audioHelper.stop();
    super.dispose();
  }

  void _scrollToVerse(int verseNumber) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _verseKeys[verseNumber];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailAsyncValue = ref.watch(surahDetailProvider(widget.surahNumber));

    // Listen to loaded state to scroll to highlight
    ref.listen<AsyncValue<List<AyatModel>>>(surahDetailProvider(widget.surahNumber), (prev, next) {
      next.whenData((verses) {
        if (widget.highlightVerseNumber != null) {
          Future.delayed(const Duration(milliseconds: 400), () {
            _scrollToVerse(widget.highlightVerseNumber!);
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surahName,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chrome_reader_mode_outlined, color: AppColors.accent),
            tooltip: 'Tafsir Surah',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TafsirPage(
                    surahNumber: widget.surahNumber,
                    surahName: widget.surahName,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: detailAsyncValue.when(
        data: (verses) {
          for (var verse in verses) {
            _verseKeys[verse.nomorAyat] = _verseKeys[verse.nomorAyat] ?? GlobalKey();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: verses.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildSurahHeaderBanner(context, verses.length);
                    }
                    
                    final verse = verses[index - 1];
                    final isPlaying = _currentPlayingUrl == verse.preferredAudio && _isAudioPlaying;
                    final isHighlighted = isPlaying || (widget.highlightVerseNumber == verse.nomorAyat);
                    
                    final bookmarks = ref.watch(bookmarkProvider);
                    final isBookmarked = bookmarks.any((b) =>
                        b['surah_number'] == widget.surahNumber && b['verse_number'] == verse.nomorAyat);
                    
                    return VerseCard(
                      key: _verseKeys[verse.nomorAyat],
                      verse: verse,
                      surahNumber: widget.surahNumber,
                      surahName: widget.surahName,
                      isHighlighted: isHighlighted,
                      isPlaying: isPlaying,
                      isBookmarked: isBookmarked,
                      onPlayPressed: () {
                        _audioHelper.play(verse.preferredAudio);
                      },
                      onBookmarkPressed: () {
                        ref.read(bookmarkProvider.notifier).toggleBookmark(
                              surahNumber: widget.surahNumber,
                              surahName: widget.surahName,
                              verseNumber: verse.nomorAyat,
                            );
                      },
                      onSharePressed: () {
                        Share.share(
                          '${verse.teksArab}\n\n${verse.teksLatin}\n\nArtinya: "${verse.teksIndonesia}"\n\n(QS. ${widget.surahName}: ${verse.nomorAyat})',
                        );
                      },
                      onLastReadPressed: () {
                        ref.read(lastReadProvider.notifier).saveLastRead(
                              surahNumber: widget.surahNumber,
                              surahName: widget.surahName,
                              verseNumber: verse.nomorAyat,
                              verseTextLatin: verse.teksLatin,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ditandai sebagai terakhir dibaca'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => _buildShimmerLoading(),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
                const SizedBox(height: 16),
                Text(
                  err.toString(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(surahDetailProvider(widget.surahNumber));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurahHeaderBanner(BuildContext context, int totalAyat) {
    final isAlFatihah = widget.surahNumber == 1;
    final isAtTawbah = widget.surahNumber == 9;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                Color(0xFF073822),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: SimpleIslamicPatternPainter(
                      color: AppColors.accent.withOpacity(0.06),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        widget.surahName,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.accent.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'QS. ${widget.surahNumber}',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.accentLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$totalAyat AYAT',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.accentLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
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
        ),
        if (!isAlFatihah && !isAtTawbah) ...[
          const SizedBox(height: 28),
          Center(
            child: Text(
              'بِسْمِ اللّٰهِ الرَّحْمٰnِ الرَّحِيْمِ',
              style: AppTheme.arabicStyle(fontSize: 28, color: AppColors.accent),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.cardDark
                : Colors.white,
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
            ),
          ),
          child: Column(
            children: [
              Text(
                'PANDUAN WARNA TAJWID BACAAN',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              TajweedParser.buildLegend(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class SimpleIslamicPatternPainter extends CustomPainter {
  final Color color;

  SimpleIslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final centerL = Offset(0.0, size.height * 0.5);
    final centerR = Offset(size.width, size.height * 0.5);

    canvas.drawCircle(centerL, 60, paint);
    canvas.drawCircle(centerL, 90, paint);
    canvas.drawCircle(centerR, 60, paint);
    canvas.drawCircle(centerR, 90, paint);
  }

  @override
  bool shouldRepaint(covariant SimpleIslamicPatternPainter oldDelegate) => false;
}

class VerseCard extends StatefulWidget {
  final AyatModel verse;
  final int surahNumber;
  final String surahName;
  final bool isHighlighted;
  final bool isPlaying;
  final bool isBookmarked;
  final VoidCallback onPlayPressed;
  final VoidCallback onBookmarkPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onLastReadPressed;

  const VerseCard({
    super.key,
    required this.verse,
    required this.surahNumber,
    required this.surahName,
    required this.isHighlighted,
    required this.isPlaying,
    required this.isBookmarked,
    required this.onPlayPressed,
    required this.onBookmarkPressed,
    required this.onSharePressed,
    required this.onLastReadPressed,
  });

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  void _showRuleInfoDialog(BuildContext context, String ruleName, String description) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121824) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 25,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'INFO TAJWID',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accent,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                ruleName,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textLightPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 0.5,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Mengerti',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<TextSpan> _buildParsedArabicText(bool isDark) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    return TajweedParser.parse(
      widget.verse.teksArab,
      AppTheme.arabicStyle(
        fontSize: 28,
        color: isDark ? Colors.white : AppColors.textLightPrimary,
      ),
      isDark,
      onTapRule: (ruleName, description) {
        _showRuleInfoDialog(context, ruleName, description);
      },
      registerRecognizer: (recognizer) {
        _recognizers.add(recognizer);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.isHighlighted
            ? (isDark ? AppColors.highlightDark : AppColors.highlightLight)
            : (isDark ? AppColors.cardDark : Colors.white),
        border: Border.all(
          color: widget.isHighlighted
              ? AppColors.primary
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: widget.isHighlighted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                RubElHizb(number: widget.verse.nomorAyat, size: 34),
                const SizedBox(width: 12),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    widget.isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                    color: AppColors.accent,
                    size: 26,
                  ),
                  onPressed: widget.onPlayPressed,
                ),
                IconButton(
                  icon: Icon(
                    widget.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                    color: widget.isBookmarked ? AppColors.accent : (isDark ? Colors.white70 : Colors.black87),
                    size: 24,
                  ),
                  onPressed: widget.onBookmarkPressed,
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined, size: 22),
                  onPressed: widget.onSharePressed,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Text.rich(
                TextSpan(
                  children: _buildParsedArabicText(isDark),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              widget.verse.teksLatin,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: AppColors.accent,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.verse.teksIndonesia,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.bookmark_added_outlined, size: 16, color: AppColors.primaryLight),
                label: Text(
                  'TANDAI TERAKHIR DIBACA',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.primaryLight,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                onPressed: widget.onLastReadPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
