import 'package:www/track_model.dart';

/// Модель плейлиста
class Playlist {
  final int? id;
  final int userId;
  final String name;
  final String? description;
  final String? coverPath;
  final bool isPublic;
  final DateTime createdAt;
  
  // Дополнительные поля
  List<Track>? tracks;
  int trackCount;
  String? username; // Имя создателя

  Playlist({
    this.id,
    required this.userId,
    required this.name,
    this.description,
    this.coverPath,
    this.isPublic = true,
    DateTime? createdAt,
    this.tracks,
    this.trackCount = 0,
    this.username,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Конвертация в JSON для БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'cover_path': coverPath,
      'is_public': isPublic ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Создание из JSON (из БД)
  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String?,
      coverPath: map['cover_path'] as String?,
      isPublic: (map['is_public'] as int?) == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      trackCount: map['track_count'] as int? ?? 0,
      username: map['username'] as String?,
    );
  }

  /// Копирование с изменениями
  Playlist copyWith({
    int? id,
    int? userId,
    String? name,
    String? description,
    String? coverPath,
    bool? isPublic,
    DateTime? createdAt,
    List<Track>? tracks,
    int? trackCount,
    String? username,
  }) {
    return Playlist(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      coverPath: coverPath ?? this.coverPath,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      tracks: tracks ?? this.tracks,
      trackCount: trackCount ?? this.trackCount,
      username: username ?? this.username,
    );
  }
}
