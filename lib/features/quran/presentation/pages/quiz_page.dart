import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/ambient_lights.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/learning_local_datasource.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  bool _quizFinished = false;

  final List<QuizQuestionModel> _questions = List.from(LearningLocalDataSource.quizQuestions);

  void _handleOptionSelect(int optionIndex) {
    if (_isAnswered) return; // Locked

    setState(() {
      _selectedAnswerIndex = optionIndex;
      _isAnswered = true;
      if (optionIndex == _questions[_currentIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswerIndex = null;
        _isAnswered = false;
      });
    } else {
      setState(() {
        _quizFinished = true;
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedAnswerIndex = null;
      _isAnswered = false;
      _quizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuis Tajwid',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const AmbientLights(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _quizFinished
                  ? _buildScorecard(isDark)
                  : _buildQuestionScreen(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionScreen(bool isDark) {
    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pertanyaan ${_currentIndex + 1} dari ${_questions.length}',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppColors.accent,
                ),
              ),
              Text(
                'Skor: $_score',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isDark ? Colors.white70 : AppColors.textLightSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF073822)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Text(
              question.questionText,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: ListView.separated(
              itemCount: question.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final optionText = question.options[index];
                return _buildOptionButton(index, optionText, question, isDark);
              },
            ),
          ),

          if (_isAnswered) _buildExplanationAndActions(question, isDark),
        ],
      ),
    );
  }

  Widget _buildOptionButton(int index, String text, QuizQuestionModel question, bool isDark) {
    final isSelected = _selectedAnswerIndex == index;
    final isCorrect = question.correctAnswerIndex == index;

    Color cardColor = isDark ? AppColors.cardDark : Colors.white;
    Color borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    Widget? trailingIcon;
    Color textColor = isDark ? Colors.white : AppColors.textLightPrimary;

    if (_isAnswered) {
      if (isCorrect) {
        cardColor = isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7);
        borderColor = const Color(0xFF22C55E);
        textColor = isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D);
        trailingIcon = const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 20);
      } else if (isSelected) {
        cardColor = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
        borderColor = const Color(0xFFEF4444);
        textColor = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C);
        trailingIcon = const Icon(Icons.cancel_rounded, color: Color(0xFFEF4444), size: 20);
      } else {
        textColor = isDark ? Colors.white38 : Colors.black38;
      }
    }

    return GestureDetector(
      onTap: () => _handleOptionSelect(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected || (isCorrect && _isAnswered) ? 2.0 : 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ),
            if (trailingIcon != null) trailingIcon,
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationAndActions(QuizQuestionModel question, bool isDark) {
    final isCorrect = _selectedAnswerIndex == question.correctAnswerIndex;

    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131C2E) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded,
                      color: isCorrect ? const Color(0xFF22C55E) : AppColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCorrect ? 'Jawaban Anda Benar!' : 'Penjelasan:',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: isCorrect ? const Color(0xFF22C55E) : AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  question.explanation,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentIndex == _questions.length - 1 ? 'Lihat Hasil' : 'Pertanyaan Berikutnya',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorecard(bool isDark) {
    final percentage = ((_score / _questions.length) * 100).round();
    
    String messageTitle = '';
    String messageDesc = '';
    IconData scoreIcon = Icons.emoji_events_rounded;
    Color iconColor = AppColors.accent;

    if (percentage == 100) {
      messageTitle = 'Maa Sha Allah, Sempurna!';
      messageDesc = 'Anda memahami seluruh materi hukum tajwid dengan sangat luar biasa.';
      scoreIcon = Icons.workspace_premium_rounded;
    } else if (percentage >= 70) {
      messageTitle = 'Maa Sha Allah, Bagus Sekali!';
      messageDesc = 'Pemahaman tajwid Anda sudah sangat baik. Teruskan membaca dan berlatih!';
      scoreIcon = Icons.thumb_up_alt_rounded;
      iconColor = const Color(0xFF22C55E);
    } else {
      messageTitle = 'Alhamdulillah, Terus Berlatih!';
      messageDesc = 'Jangan berkecil hati. Buka kembali materi pelajaran tajwid dan coba lagi kuis ini.';
      scoreIcon = Icons.auto_stories_rounded;
      iconColor = Colors.blueAccent;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: iconColor.withOpacity(0.3), width: 2),
              ),
              child: Icon(
                scoreIcon,
                color: iconColor,
                size: 52,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              messageTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: isDark ? Colors.white : AppColors.textLightPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              messageDesc,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 36),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildScoreMetric('BENAR', '$_score', Colors.green),
                  Container(width: 1.5, height: 40, color: isDark ? Colors.white12 : Colors.black12),
                  _buildScoreMetric('SALAH', '${_questions.length - _score}', Colors.redAccent),
                  Container(width: 1.5, height: 40, color: isDark ? Colors.white12 : Colors.black12),
                  _buildScoreMetric('AKURASI', '$percentage%', AppColors.accent),
                ],
              ),
            ),
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _restartQuiz,
                icon: const Icon(Icons.replay_rounded, size: 20),
                label: Text(
                  'Coba Lagi',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Selesai & Kembali',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white70 : AppColors.textLightPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color.withOpacity(0.8),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
