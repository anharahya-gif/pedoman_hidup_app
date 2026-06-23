class AyatModel {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String> audio;

  AyatModel({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    required this.audio,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) {
    final Map<String, String> audioMap = {};
    if (json['audio'] is Map) {
      (json['audio'] as Map).forEach((key, value) {
        audioMap[key.toString()] = value.toString();
      });
    }
    return AyatModel(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
      audio: audioMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomorAyat': nomorAyat,
      'teksArab': teksArab,
      'teksLatin': teksLatin,
      'teksIndonesia': teksIndonesia,
      'audio': audio,
    };
  }

  // Get preferred Qari audio for individual verse (default: Al-Afasy - '05')
  String get preferredAudio => audio['05'] ?? audio.values.first;
}
