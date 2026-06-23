import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TajweedRule {
  final String name;
  final String description;
  final String category;
  final Color Function(bool isDark) colorResolver;

  const TajweedRule({
    required this.name,
    required this.description,
    required this.category,
    required this.colorResolver,
  });
}

class TajweedParser {
  // Define Tajweed rules with names, descriptions, and premium color palettes
  static final ruleWaqaf = TajweedRule(
    name: 'Tanda Waqaf',
    description: 'Tanda petunjuk berhenti membaca (Waqaf) untuk mengatur nafas dan menyempurnakan makna ayat.',
    category: 'Waqaf',
    colorResolver: (isDark) => isDark ? const Color(0xFFFFD54F) : const Color(0xFFFFB300), // Gold
  );

  static final ruleMadWajib = TajweedRule(
    name: 'Mad Wajib Muttasil',
    description: 'Mad Thabi\'i bertemu dengan Hamza dalam satu kata yang sama. Harus dibaca panjang 5 atau 6 harakat.',
    category: 'Mad',
    colorResolver: (isDark) => isDark ? const Color(0xFFFFE082) : const Color(0xFFFBC02D), // Amber Gold
  );

  static final ruleMadJaiz = TajweedRule(
    name: 'Mad Jaiz Munfasil',
    description: 'Mad Thabi\'i bertemu dengan Hamza di lain kata. Boleh dibaca panjang 2, 4, atau 5 harakat.',
    category: 'Mad',
    colorResolver: (isDark) => isDark ? const Color(0xFFFFF59D) : const Color(0xFFF9A825), // Yellow Gold
  );

  static final ruleMadLazim = TajweedRule(
    name: 'Mad Lazim',
    description: 'Mad Thabi\'i bertemu dengan huruf sukun asli atau bertasydid dalam satu kata. Harus dibaca panjang 6 harakat.',
    category: 'Mad',
    colorResolver: (isDark) => isDark ? const Color(0xFFD1C4E9) : const Color(0xFF512DA8), // Deep Purple
  );

  static final ruleMadThabii = TajweedRule(
    name: 'Mad Thabi\'i (Alif Khanjariyah)',
    description: 'Mad asli (diwakili dagger Alef superskrip) yang dibaca panjang 2 harakat.',
    category: 'Mad',
    colorResolver: (isDark) => isDark ? const Color(0xFFFFCC80) : const Color(0xFFE65100), // Orange
  );

  static final ruleIzharHalqi = TajweedRule(
    name: 'Izhar Halqi',
    description: 'Membaca huruf Nun Sukun atau Tanwin secara jelas dan tegas tanpa dengung ketika bertemu salah satu huruf halqi (ء, ه, ع, ح, غ, kh).',
    category: 'Nun Sukun & Tanwin',
    colorResolver: (isDark) => isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32), // Green
  );

  static final ruleIdghamBighunnah = TajweedRule(
    name: 'Idgham Bighunnah',
    description: 'Memasukkan bunyi Nun Sukun atau Tanwin ke huruf berikutnya disertai dengung yang ditahan selama 2 harakat (huruf: ي, ن, م, و).',
    category: 'Nun Sukun & Tanwin',
    colorResolver: (isDark) => isDark ? const Color(0xFFFFB74D) : const Color(0xFFF57C00), // Amber
  );

  static final ruleIdghamBilaghunnah = TajweedRule(
    name: 'Idgham Bilaghunnah',
    description: 'Memasukkan bunyi Nun Sukun atau Tanwin ke huruf berikutnya secara melebur penuh tanpa dengung sedikit pun (huruf: ل, ر).',
    category: 'Nun Sukun & Tanwin',
    colorResolver: (isDark) => isDark ? const Color(0xFF90CAF9) : const Color(0xFF1976D2), // Blue
  );

  static final ruleIqlab = TajweedRule(
    name: 'Iqlab',
    description: 'Mengubah bunyi Nun Sukun atau Tanwin menjadi bunyi Mim Sakinah disertai dengung ketika bertemu huruf Ba (ب).',
    category: 'Nun Sukun & Tanwin',
    colorResolver: (isDark) => isDark ? const Color(0xFFEA80FC) : const Color(0xFF8E24AA), // Purple
  );

  static final ruleIkhfaHaqiqi = TajweedRule(
    name: 'Ikhfa Haqiqi',
    description: 'Menyamarkan bunyi Nun Sukun atau Tanwin menjadi samar-samar dengan dengung yang ditahan selama 2 harakat ketika bertemu salah satu dari 15 huruf ikhfa.',
    category: 'Nun Sukun & Tanwin',
    colorResolver: (isDark) => isDark ? const Color(0xFFFF8A80) : const Color(0xFFD84315), // Coral Red
  );

  static final ruleIkhfaSyafawi = TajweedRule(
    name: 'Ikhfa Syafawi',
    description: 'Menyamarkan bunyi Mim Sukun disertai dengung ketika bertemu dengan huruf Ba (ب).',
    category: 'Mim Sukun',
    colorResolver: (isDark) => isDark ? const Color(0xFFF48FB1) : const Color(0xFFC2185B), // Pink
  );

  static final ruleIdghamMimi = TajweedRule(
    name: 'Idgham Mimi (Mutamatsilain)',
    description: 'Memasukkan bunyi Mim Sukun ke dalam Mim berikutnya disertai dengung selama 2 harakat.',
    category: 'Mim Sukun',
    colorResolver: (isDark) => isDark ? const Color(0xFF80DEEA) : const Color(0xFF0097A7), // Cyan
  );

  static final ruleIzharSyafawi = TajweedRule(
    name: 'Izhar Syafawi',
    description: 'Membaca bunyi Mim Sukun secara jelas dan terang tanpa dengung ketika bertemu seluruh huruf selain Mim dan Ba.',
    category: 'Mim Sukun',
    colorResolver: (isDark) => isDark ? const Color(0xFFA5D6A7) : const Color(0xFF388E3C), // Light Green
  );

  static final ruleLamSyamsiyah = TajweedRule(
    name: 'Lam Ta\'rif Syamsiyah',
    description: 'Alif Lam (ال) melebur ke dalam huruf syamsiyah setelahnya (bertasydid), sehingga huruf Lam tidak dibaca.',
    category: 'Hukum Lam',
    colorResolver: (isDark) => isDark ? const Color(0xFFB2DFDB) : const Color(0xFF00796B), // Teal
  );

  static final ruleLamQamariyah = TajweedRule(
    name: 'Lam Ta\'rif Qamariyah',
    description: 'Alif Lam (ال) dibaca dengan jelas (Izhar) karena bertemu dengan salah satu huruf qamariyah.',
    category: 'Hukum Lam',
    colorResolver: (isDark) => isDark ? const Color(0xFFC8E6C9) : const Color(0xFF1B5E20), // Mint Green
  );

  static final ruleRaTafkhim = TajweedRule(
    name: 'Ra\' Tafkhim',
    description: 'Membaca huruf Ra (ر) secara tebal (misal saat berharakat Fatha atau Damma).',
    category: 'Hukum Ra\'',
    colorResolver: (isDark) => isDark ? const Color(0xFFB0BEC5) : const Color(0xFF455A64), // Blue Grey
  );

  static final ruleRaTarqiq = TajweedRule(
    name: 'Ra\' Tarqiq',
    description: 'Membaca huruf Ra (ر) secara tipis (misal saat berharakat Kasra).',
    category: 'Hukum Ra\'',
    colorResolver: (isDark) => isDark ? const Color(0xFFCFD8DC) : const Color(0xFF78909C), // Slate
  );

  static final ruleQalqalahSugra = TajweedRule(
    name: 'Qalqalah Sugra',
    description: 'Memantulkan bunyi huruf qalqalah (ق, ط, ب, j, د) yang berharakat sukun asli di tengah kata.',
    category: 'Qalqalah',
    colorResolver: (isDark) => isDark ? const Color(0xFFB2FF59) : const Color(0xFF64DD17), // Lime Green
  );

  static final ruleQalqalahKubra = TajweedRule(
    name: 'Qalqalah Kubra',
    description: 'Memantulkan bunyi huruf qalqalah secara kuat saat dihentikan (waqaf) di akhir ayat.',
    category: 'Qalqalah',
    colorResolver: (isDark) => isDark ? const Color(0xFF69F0AE) : const Color(0xFF00C853), // Vibrant Green
  );

  static final ruleGhunnah = TajweedRule(
    name: 'Ghunnah Musyaddadah',
    description: 'Membaca huruf Nun (ن) atau Mim (م) yang bertasydid dengan berdengung tebal dan ditahan selama 2-3 harakat.',
    category: 'Ghunnah',
    colorResolver: (isDark) => isDark ? const Color(0xFFFF5252) : const Color(0xFFD32F2F), // Red
  );

  static const Set<String> _leftNonConnectors = {
    '\u0621', // ء (Hamza)
    '\u0622', // آ
    '\u0623', // أ
    '\u0624', // ؤ
    '\u0625', // إ
    '\u0627', // ا (Alef)
    '\u062f', // د (Dal)
    '\u0630', // ذ (Thal)
    '\u0631', // ر (Reh)
    '\u0632', // ز (Zain)
    '\u0629', // ة (Teh Marbuta)
    '\u0648', // و (Waw)
    '\u0649', // ى (Alef Maksura)
  };

  static bool _isDiacritic(String char) {
    final code = char.codeUnitAt(0);
    if (code >= 0x064b && code <= 0x0655) return true;
    if (code == 0x0670) return true;
    if (code >= 0x06d6 && code <= 0x06ed) return true;
    return false;
  }

  static bool _isArabic(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0x0600 && code <= 0x06FF;
  }

  static bool _shouldConnect(String text, int boundaryIndex) {
    if (boundaryIndex <= 0 || boundaryIndex >= text.length) return false;

    // Find the base character before the boundary
    String? charA;
    for (int i = boundaryIndex - 1; i >= 0; i--) {
      final c = text[i];
      if (!_isDiacritic(c)) {
        charA = c;
        break;
      }
    }

    // Find the base character after the boundary
    String? charB;
    for (int i = boundaryIndex; i < text.length; i++) {
      final c = text[i];
      if (!_isDiacritic(c)) {
        charB = c;
        break;
      }
    }

    if (charA == null || charB == null) return false;
    if (!_isArabic(charA) || !_isArabic(charB)) return false;

    final aConnectsLeft = !_leftNonConnectors.contains(charA);
    final bConnectsRight = charB != '\u0621';

    return aConnectsLeft && bConnectsRight;
  }

  static int _expandToIncludeBase(String text, int start) {
    int adjustedStart = start;
    while (adjustedStart > 0 && _isDiacritic(text[adjustedStart])) {
      adjustedStart--;
    }
    return adjustedStart;
  }

  static List<TextSpan> parse(
    String text,
    TextStyle baseStyle,
    bool isDark, {
    void Function(String ruleName, String description)? onTapRule,
    void Function(TapGestureRecognizer recognizer)? registerRecognizer,
  }) {
    if (text.isEmpty) return [TextSpan(text: text, style: baseStyle)];

    final List<TajweedRule?> characterRules = List.filled(text.length, null);

    void colorRange(int start, int end, TajweedRule rule) {
      final adjStart = _expandToIncludeBase(text, start);
      for (int i = adjStart; i < end; i++) {
        if (characterRules[i] == null) {
          characterRules[i] = rule;
        }
      }
    }

    // 1. Waqaf Signs: [\u06d6-\u06df\u06dc]
    final waqafRegex = RegExp(r'[\u06d6-\u06df\u06dc]');
    for (final match in waqafRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleWaqaf);
    }

    // 2. Mad Wajib Muttasil: Maddah + Hamza in same word
    final madWajibRegex = RegExp(r'([^\s\u0621\u0623\u0625\u0626\u062ؤ]*\u0653[\u06d6-\u06df]*[\u0621\u0623\u0625\u0626\u062ؤ])');
    for (final match in madWajibRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleMadWajib);
    }

    // 3. Mad Jaiz Munfasil: Maddah at end of word, next word starts with Alef/Hamza
    final madJaizRegex = RegExp(r'([^\s]+\u0653[\u06d6-\u06df]*)\s+([\u0627\u0623\u0625\u0622])');
    for (final match in madJaizRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleMadJaiz);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleMadJaiz);
    }

    // 4. Mad Lazim: Maddah + Shaddah in same word
    final madLazimRegex = RegExp(r'([^\s]*\u0653[^\s]*\u0651[^\s]*)');
    for (final match in madLazimRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleMadLazim);
    }

    // 5. Iqlab: Tanwin/Nun Sakinah + Ba
    final iqlabRegex = RegExp(r'((?:[\u064b\u064d\u064c]|\u0646\u0652)[\u06d6-\u06df]*)\s+(\u0628)');
    for (final match in iqlabRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIqlab);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIqlab);
    }

    // 6. Idgham Bighunnah: Tanwin/Nun Sakinah + ي, ن, م, و
    final idghamBighunnahRegex = RegExp(r'((?:[\u064b\u064d\u064c]|\u0646\u0652)[\u06d6-\u06df]*)\s+([\u064a\u0646\u0645\u0648])');
    for (final match in idghamBighunnahRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIdghamBighunnah);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIdghamBighunnah);
    }

    // 7. Idgham Bilaghunnah: Tanwin/Nun Sakinah + ل, ر
    final idghamBilaghunnahRegex = RegExp(r'((?:[\u064b\u064d\u064c]|\u0646\u0652)[\u06d6-\u06df]*)\s+([\u0644\u0631])');
    for (final match in idghamBilaghunnahRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIdghamBilaghunnah);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIdghamBilaghunnah);
    }

    // 8. Ikhfa Haqiqi: Tanwin/Nun Sakinah + 15 letters
    final ikhfaHaqiqiRegex = RegExp(r'((?:[\u064b\u064d\u064c]|\u0646\u0652)[\u06d6-\u06df]*)\s+([\u062a\u062b\u062c\u062f\u0630\u0632\u0633\u0634\u0635\u0636\u0637\u0638\u0641\u0642\u0643])');
    for (final match in ikhfaHaqiqiRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIkhfaHaqiqi);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIkhfaHaqiqi);
    }

    // 9. Izhar Halqi: Tanwin/Nun Sakinah + 6 Halqi letters
    final izharHalqiRegex = RegExp(r'((?:[\u064b\u064d\u064c]|\u0646\u0652)[\u06d6-\u06df]*)\s+([\u0621\u0623\u0625\u0647\u0639\u062d\u063a\u062e])');
    for (final match in izharHalqiRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIzharHalqi);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIzharHalqi);
    }

    // 10. Ikhfa Syafawi: Mim Sakinah + Ba
    final ikhfaSyafawiRegex = RegExp(r'(\u0645\u0652?[\u06d6-\u06df]*)\s+(\u0628)');
    for (final match in ikhfaSyafawiRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIkhfaSyafawi);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIkhfaSyafawi);
    }

    // 11. Idgham Mimi: Mim Sakinah + Mim
    final idghamMimiRegex = RegExp(r'(\u0645\u0652?[\u06d6-\u06df]*)\s+(\u0645)');
    for (final match in idghamMimiRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIdghamMimi);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIdghamMimi);
    }

    // 12. Izhar Syafawi: Mim Sakinah + other letters
    final izharSyafawiRegex = RegExp(r'(\u0645\u0652[\u06d6-\u06df]*)\s+([^\s\u0628\u0645])');
    for (final match in izharSyafawiRegex.allMatches(text)) {
      final g1Start = match.start;
      final g1End = match.start + match.group(1)!.length;
      colorRange(g1Start, g1End, ruleIzharSyafawi);

      final g2Start = match.end - match.group(2)!.length;
      final g2End = match.end;
      colorRange(g2Start, g2End, ruleIzharSyafawi);
    }

    // 13. Lam Ta\'rif Syamsiyah: Alif Lam + Shaddah on next letter
    final lamSyamsiyahRegex = RegExp(r'\u0627\u0644([^\s]\u0651)');
    for (final match in lamSyamsiyahRegex.allMatches(text)) {
      final endOfAl = match.end - match.group(1)!.length;
      colorRange(match.start, endOfAl, ruleLamSyamsiyah);
    }

    // 14. Lam Ta\'rif Qamariyah: Alif Lam with Sukun on Lam
    final lamQamariyahRegex = RegExp(r'\u0627\u0644\u0652');
    for (final match in lamQamariyahRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleLamQamariyah);
    }

    // 15. Qalqalah Kubra: Qalqalah letter at the end of the verse
    final qalqalahKubraRegex = RegExp(r'[\u0642\u0637\u0628\u062c\u062f][\u064e\u0650\u064f\u064b\u064d\u064c\u0651\u0652]*(?=\s*[\u06d6-\u06df]*\s*$)');
    for (final match in qalqalahKubraRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleQalqalahKubra);
    }

    // 16. Qalqalah Sugra: Qalqalah letter with Sukun (not end of word/verse)
    final qalqalahSugraRegex = RegExp(r'[\u0642\u0637\u0628\u062c\u062f]\u0652(?!\s|$|[\u06d6-\u06df])');
    for (final match in qalqalahSugraRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleQalqalahSugra);
    }

    // 17. Ghunnah: Nun/Mim + Shaddah
    final ghunnahRegex = RegExp(r'[\u0646\u0645]\u0651');
    for (final match in ghunnahRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleGhunnah);
    }

    // 18. Ra\' Tafkhim: Ra with Fatha/Damma/Tanwin
    final raTafkhimRegex = RegExp(r'\u0631[\u064e\u064f\u064b\u064c]');
    for (final match in raTafkhimRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleRaTafkhim);
    }

    // 19. Ra\' Tarqiq: Ra with Kasra/Tanwin
    final raTarqiqRegex = RegExp(r'\u0631[\u0650\u064d]');
    for (final match in raTarqiqRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleRaTarqiq);
    }

    // 20. Mad Thabi\'i (dagger Alef)
    final madThabiiRegex = RegExp(r'[\u0670]');
    for (final match in madThabiiRegex.allMatches(text)) {
      colorRange(match.start, match.end, ruleMadThabii);
    }

    final List<TextSpan> spans = [];
    int start = 0;
    while (start < text.length) {
      final rule = characterRules[start];
      int end = start + 1;
      while (end < text.length && characterRules[end] == rule) {
        end++;
      }

      final chunk = text.substring(start, end);
      final connPrev = _shouldConnect(text, start);
      final connNext = _shouldConnect(text, end);

      var processedChunk = chunk;
      if (connPrev) {
        processedChunk = '\u200d$processedChunk';
      }
      if (connNext) {
        processedChunk = '$processedChunk\u200d';
      }

      final color = rule?.colorResolver(isDark);
      final style = color != null
          ? baseStyle.copyWith(color: color, fontWeight: FontWeight.bold)
          : baseStyle;

      TapGestureRecognizer? recognizer;
      if (rule != null && onTapRule != null) {
        recognizer = TapGestureRecognizer()
          ..onTap = () => onTapRule(rule.name, rule.description);
        if (registerRecognizer != null) {
          registerRecognizer(recognizer);
        }
      }

      spans.add(TextSpan(
        text: processedChunk,
        style: style,
        recognizer: recognizer,
      ));
      start = end;
    }

    return spans;
  }

  // Legend helper for Tajweed colors
  static Widget buildLegend(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget legendItem(String label, Color color) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        legendItem('Ghunnah', ruleGhunnah.colorResolver(isDark)),
        legendItem('Qalqalah', ruleQalqalahKubra.colorResolver(isDark)),
        legendItem('Ikhfa', ruleIkhfaHaqiqi.colorResolver(isDark)),
        legendItem('Idgham', ruleIdghamBighunnah.colorResolver(isDark)),
        legendItem('Iqlab', ruleIqlab.colorResolver(isDark)),
        legendItem('Mad', ruleMadWajib.colorResolver(isDark)),
        legendItem('Lam Ta\'rif', ruleLamSyamsiyah.colorResolver(isDark)),
        legendItem('Ra\'', ruleRaTafkhim.colorResolver(isDark)),
        legendItem('Waqaf', ruleWaqaf.colorResolver(isDark)),
      ],
    );
  }
}
