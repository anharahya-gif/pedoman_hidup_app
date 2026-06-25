class PrayerPlaylist {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<String> doaIds;

  const PrayerPlaylist({
    required this.id,
    required this.title,
    required this.createdAt,
    this.doaIds = const [],
  });

  PrayerPlaylist copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    List<String>? doaIds,
  }) {
    return PrayerPlaylist(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      doaIds: doaIds ?? this.doaIds,
    );
  }
}
