import '../../domain/entities/prayer_playlist.dart';

class PrayerPlaylistModel extends PrayerPlaylist {
  const PrayerPlaylistModel({
    required super.id,
    required super.title,
    required super.createdAt,
    super.doaIds = const [],
  });

  factory PrayerPlaylistModel.fromSqlMap(Map<String, dynamic> map, {List<String> doaIds = const []}) {
    return PrayerPlaylistModel(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      doaIds: doaIds,
    );
  }

  Map<String, dynamic> toSqlMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
