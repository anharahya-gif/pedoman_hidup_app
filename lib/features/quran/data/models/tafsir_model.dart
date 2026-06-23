class TafsirModel {
  final int ayat;
  final String teks;

  TafsirModel({
    required this.ayat,
    required this.teks,
  });

  factory TafsirModel.fromJson(Map<String, dynamic> json) {
    return TafsirModel(
      ayat: json['ayat'] ?? 0,
      teks: json['teks'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ayat': ayat,
      'teks': teks,
    };
  }
}
