/// Utilitas pembantu untuk format dan manipulasi tanggal standar habit tracker.
class DateFormatter {
  /// Memformat [DateTime] menjadi string 'YYYY-MM-DD'
  static String formatDate(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Membaca string 'YYYY-MM-DD' menjadi [DateTime]
  static DateTime parseDate(String dateStr) {
    return DateTime.parse(dateStr);
  }

  /// Mendapatkan tanggal hari ini terformat 'YYYY-MM-DD'
  static String get todayString => formatDate(DateTime.now());

  /// Menghitung selisih hari antara dua tanggal terformat
  static int daysBetween(String startStr, String endStr) {
    final start = parseDate(startStr);
    final end = parseDate(endStr);
    return end.difference(start).inDays;
  }

  /// Memformat [DateTime] menjadi tanggal bahasa Indonesia lengkap (e.g. "Selasa, 23 Juni 2026")
  static String formatIndonesianDate(DateTime date) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    final dayName = days[date.weekday % 7];
    final dayNum = date.day;
    final monthName = months[date.month - 1];
    final year = date.year;
    return '$dayName, $dayNum $monthName $year';
  }
}
