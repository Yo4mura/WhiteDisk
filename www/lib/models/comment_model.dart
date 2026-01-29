/// Модель комментария
class Comment {
  final int? id;
  final int userId;
  final String trackId;
  final String text;
  final DateTime createdAt;
  
  // Дополнительные поля для отображения
  String? username;
  String? userAvatar;

  Comment({
    this.id,
    required this.userId,
    required this.trackId,
    required this.text,
    DateTime? createdAt,
    this.username,
    this.userAvatar,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Конвертация в JSON для БД
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'track_id': trackId,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Создание из JSON (из БД)
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      trackId: map['track_id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      username: map['username'] as String?,
      userAvatar: map['user_avatar'] as String?,
    );
  }
}
