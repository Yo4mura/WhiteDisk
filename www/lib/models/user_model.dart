/// Модель пользователя
class User {
  final int? id;
  final String username;
  final String email;
  final String? avatarPath;
  final String? bio;
  final DateTime createdAt;
  final bool isOnline;
  final String? currentTrackId;

  User({
    this.id,
    required this.username,
    required this.email,
    this.avatarPath,
    this.bio,
    DateTime? createdAt,
    this.isOnline = false,
    this.currentTrackId,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Конвертация в JSON для БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_path': avatarPath,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'is_online': isOnline ? 1 : 0,
      'current_track_id': currentTrackId,
    };
  }

  /// Создание из JSON (из БД)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      avatarPath: map['avatar_path'] as String?,
      bio: map['bio'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      isOnline: (map['is_online'] as int) == 1,
      currentTrackId: map['current_track_id'] as String?,
    );
  }

  /// Копирование с изменениями
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? avatarPath,
    String? bio,
    DateTime? createdAt,
    bool? isOnline,
    String? currentTrackId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      isOnline: isOnline ?? this.isOnline,
      currentTrackId: currentTrackId ?? this.currentTrackId,
    );
  }
}
