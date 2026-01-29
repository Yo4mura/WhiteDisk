import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../track_model.dart';
import 'database_helper.dart';
import 'auth_service.dart';

/// Сервис для социальных функций (лайки, комментарии)
class SocialService extends ChangeNotifier {
  static final SocialService _instance = SocialService._internal();
  factory SocialService() => _instance;
  SocialService._internal();

  final DatabaseHelper _db = DatabaseHelper();
  final AuthService _auth = AuthService();

  // Кеш для лайков текущего пользователя
  final Set<String> _likedTrackIds = {};

  /// Инициализация сервиса
  Future<void> init() async {
    if (_auth.currentUserId != null) {
      await _loadLikedTracks();
    }
  }

  /// Загрузка лайкнутых треков пользователя
  Future<void> _loadLikedTracks() async {
    if (_auth.currentUserId == null) return;

    final likedTracks = await _db.getLikedTracks(_auth.currentUserId!);
    _likedTrackIds.clear();
    for (var track in likedTracks) {
      _likedTrackIds.add(track.id);
    }
    notifyListeners();
  }

  // ==================== ЛАЙКИ ====================

  /// Проверка, лайкнул ли текущий пользователь трек
  bool isTrackLiked(String trackId) {
    return _likedTrackIds.contains(trackId);
  }

  /// Лайкнуть/убрать лайк с трека
  Future<void> toggleLike(String trackId) async {
    if (_auth.currentUserId == null) return;

    final isLiked = _likedTrackIds.contains(trackId);

    if (isLiked) {
      // Убираем лайк
      await _db.unlikeTrack(_auth.currentUserId!, trackId);
      _likedTrackIds.remove(trackId);
    } else {
      // Ставим лайк
      await _db.likeTrack(_auth.currentUserId!, trackId);
      _likedTrackIds.add(trackId);
      
      // Добавляем трек в историю
      await _db.addToHistory(_auth.currentUserId!, trackId);
    }

    notifyListeners();
  }

  /// Получение количества лайков трека
  Future<int> getTrackLikesCount(String trackId) async {
    return await _db.getTrackLikesCount(trackId);
  }

  /// Получение лайкнутых треков текущего пользователя
  Future<List<Track>> getLikedTracks() async {
    if (_auth.currentUserId == null) return [];
    return await _db.getLikedTracks(_auth.currentUserId!);
  }

  // ==================== КОММЕНТАРИИ ====================

  /// Добавить комментарий к треку
  Future<Comment?> addComment(String trackId, String text) async {
    if (_auth.currentUserId == null) return null;
    if (text.trim().isEmpty) return null;

    final comment = Comment(
      userId: _auth.currentUserId!,
      trackId: trackId,
      text: text.trim(),
      username: _auth.currentUser?.username,
      userAvatar: _auth.currentUser?.avatarPath,
    );

    final commentId = await _db.addComment(comment);
    
    // Возвращаем комментарий с ID
    return Comment(
      id: commentId,
      userId: comment.userId,
      trackId: comment.trackId,
      text: comment.text,
      createdAt: comment.createdAt,
      username: comment.username,
      userAvatar: comment.userAvatar,
    );
  }

  /// Удалить комментарий
  Future<void> deleteComment(int commentId) async {
    await _db.deleteComment(commentId);
    notifyListeners();
  }

  /// Получение комментариев к треку
  Future<List<Comment>> getTrackComments(String trackId) async {
    return await _db.getTrackComments(trackId);
  }

  /// Получение количества комментариев к треку
  Future<int> getTrackCommentsCount(String trackId) async {
    return await _db.getTrackCommentsCount(trackId);
  }

  // ==================== ИСТОРИЯ ====================

  /// Добавление трека в историю прослушиваний
  Future<void> addToHistory(String trackId) async {
    if (_auth.currentUserId == null) return;
    await _db.addToHistory(_auth.currentUserId!, trackId);
  }

  /// Получение истории прослушиваний
  Future<List<Track>> getListeningHistory({int limit = 50}) async {
    if (_auth.currentUserId == null) return [];
    return await _db.getListeningHistory(_auth.currentUserId!, limit: limit);
  }
}
