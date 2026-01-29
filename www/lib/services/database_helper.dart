import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/comment_model.dart';
import '../models/playlist_model.dart';
import '../track_model.dart';

/// Helper для работы с SQLite базой данных
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Инициализация базы данных
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'whitedisk.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Создание таблиц
  Future<void> _onCreate(Database db, int version) async {
    // Таблица пользователей
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        avatar_path TEXT,
        bio TEXT,
        created_at TEXT NOT NULL,
        is_online INTEGER DEFAULT 0,
        current_track_id TEXT
      )
    ''');

    // Таблица треков (для сохранения метаданных)
    await db.execute('''
      CREATE TABLE tracks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        album TEXT,
        file_path TEXT NOT NULL,
        duration INTEGER,
        cover_path TEXT,
        date_added TEXT
      )
    ''');

    // Таблица плейлистов
    await db.execute('''
      CREATE TABLE playlists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        cover_path TEXT,
        is_public INTEGER DEFAULT 1,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Связь плейлистов и треков
    await db.execute('''
      CREATE TABLE playlist_tracks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER NOT NULL,
        track_id TEXT NOT NULL,
        position INTEGER NOT NULL,
        added_at TEXT NOT NULL,
        FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON DELETE CASCADE,
        FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
      )
    ''');

    // Таблица лайков
    await db.execute('''
      CREATE TABLE likes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        track_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(user_id, track_id),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
      )
    ''');

    // Таблица комментариев
    await db.execute('''
      CREATE TABLE comments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        track_id TEXT NOT NULL,
        text TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
      )
    ''');

    // Таблица подписок
    await db.execute('''
      CREATE TABLE follows (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        follower_id INTEGER NOT NULL,
        following_id INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        UNIQUE(follower_id, following_id),
        FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // Таблица истории прослушиваний
    await db.execute('''
      CREATE TABLE listening_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        track_id TEXT NOT NULL,
        played_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (track_id) REFERENCES tracks(id) ON DELETE CASCADE
      )
    ''');

    debugPrint('✅ База данных создана успешно');
  }

  // ==================== ПОЛЬЗОВАТЕЛИ ====================

  /// Создание пользователя
  Future<int> createUser(User user, String passwordHash) async {
    final db = await database;
    final data = user.toMap();
    data['password_hash'] = passwordHash;
    return await db.insert('users', data);
  }

  /// Получение пользователя по ID
  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Получение пользователя по email
  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Получение пользователя по username
  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  /// Получение хеша пароля пользователя
  Future<String?> getPasswordHash(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      columns: ['password_hash'],
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) return null;
    return maps.first['password_hash'] as String;
  }

  /// Обновление статуса пользователя
  Future<int> updateUserStatus(int userId, bool isOnline, String? currentTrackId) async {
    final db = await database;
    return await db.update(
      'users',
      {
        'is_online': isOnline ? 1 : 0,
        'current_track_id': currentTrackId,
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  /// Обновление профиля пользователя
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  /// Получение всех пользователей (для тестирования)
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  // ==================== ТРЕКИ ====================

  /// Сохранение трека в БД
  Future<int> saveTrack(Track track) async {
    final db = await database;
    return await db.insert(
      'tracks',
      track.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Получение всех треков
  Future<List<Track>> getAllTracks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tracks');
    return List.generate(maps.length, (i) => Track.fromJson(maps[i]));
  }

  // ==================== ЛАЙКИ ====================

  /// Лайкнуть трек
  Future<int> likeTrack(int userId, String trackId) async {
    final db = await database;
    return await db.insert('likes', {
      'user_id': userId,
      'track_id': trackId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Убрать лайк
  Future<int> unlikeTrack(int userId, String trackId) async {
    final db = await database;
    return await db.delete(
      'likes',
      where: 'user_id = ? AND track_id = ?',
      whereArgs: [userId, trackId],
    );
  }

  /// Проверка, лайкнул ли пользователь трек
  Future<bool> isTrackLiked(int userId, String trackId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'likes',
      where: 'user_id = ? AND track_id = ?',
      whereArgs: [userId, trackId],
    );
    return result.isNotEmpty;
  }

  /// Получение количества лайков трека
  Future<int> getTrackLikesCount(String trackId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM likes WHERE track_id = ?',
      [trackId],
    );
    return result.first['count'] as int;
  }

  /// Получение лайкнутых треков пользователя
  Future<List<Track>> getLikedTracks(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT t.* FROM tracks t
      INNER JOIN likes l ON t.id = l.track_id
      WHERE l.user_id = ?
      ORDER BY l.created_at DESC
    ''', [userId]);
    
    return List.generate(result.length, (i) => Track.fromJson(result[i]));
  }

  // ==================== КОММЕНТАРИИ ====================

  /// Добавить комментарий
  Future<int> addComment(Comment comment) async {
    final db = await database;
    return await db.insert('comments', comment.toMap());
  }

  /// Удалить комментарий
  Future<int> deleteComment(int commentId) async {
    final db = await database;
    return await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }

  /// Получение комментариев к треку
  Future<List<Comment>> getTrackComments(String trackId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT c.*, u.username, u.avatar_path as user_avatar
      FROM comments c
      INNER JOIN users u ON c.user_id = u.id
      WHERE c.track_id = ?
      ORDER BY c.created_at DESC
    ''', [trackId]);
    
    return List.generate(result.length, (i) => Comment.fromMap(result[i]));
  }

  /// Получение количества комментариев к треку
  Future<int> getTrackCommentsCount(String trackId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM comments WHERE track_id = ?',
      [trackId],
    );
    return result.first['count'] as int;
  }

  // ==================== ПОДПИСКИ ====================

  /// Подписаться на пользователя
  Future<int> followUser(int followerId, int followingId) async {
    final db = await database;
    return await db.insert('follows', {
      'follower_id': followerId,
      'following_id': followingId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Отписаться от пользователя
  Future<int> unfollowUser(int followerId, int followingId) async {
    final db = await database;
    return await db.delete(
      'follows',
      where: 'follower_id = ? AND following_id = ?',
      whereArgs: [followerId, followingId],
    );
  }

  /// Проверка подписки
  Future<bool> isFollowing(int followerId, int followingId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'follows',
      where: 'follower_id = ? AND following_id = ?',
      whereArgs: [followerId, followingId],
    );
    return result.isNotEmpty;
  }

  /// Получение подписчиков пользователя
  Future<List<User>> getFollowers(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT u.* FROM users u
      INNER JOIN follows f ON u.id = f.follower_id
      WHERE f.following_id = ?
    ''', [userId]);
    
    return List.generate(result.length, (i) => User.fromMap(result[i]));
  }

  /// Получение подписок пользователя
  Future<List<User>> getFollowing(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT u.* FROM users u
      INNER JOIN follows f ON u.id = f.following_id
      WHERE f.follower_id = ?
    ''', [userId]);
    
    return List.generate(result.length, (i) => User.fromMap(result[i]));
  }

  /// Получение количества подписчиков
  Future<int> getFollowersCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM follows WHERE following_id = ?',
      [userId],
    );
    return result.first['count'] as int;
  }

  /// Получение количества подписок
  Future<int> getFollowingCount(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM follows WHERE follower_id = ?',
      [userId],
    );
    return result.first['count'] as int;
  }

  /// Получение друзей онлайн (пользователи, которые слушают музыку)
  Future<List<User>> getOnlineFriends(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT u.* FROM users u
      INNER JOIN follows f ON u.id = f.following_id
      WHERE f.follower_id = ? AND u.is_online = 1
      ORDER BY u.username
    ''', [userId]);
    
    return List.generate(result.length, (i) => User.fromMap(result[i]));
  }

  // ==================== ПЛЕЙЛИСТЫ ====================

  /// Создание плейлиста
  Future<int> createPlaylist(Playlist playlist) async {
    final db = await database;
    return await db.insert('playlists', playlist.toMap());
  }

  /// Удаление плейлиста
  Future<int> deletePlaylist(int playlistId) async {
    final db = await database;
    return await db.delete(
      'playlists',
      where: 'id = ?',
      whereArgs: [playlistId],
    );
  }

  /// Получение плейлистов пользователя
  Future<List<Playlist>> getUserPlaylists(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT p.*, COUNT(pt.id) as track_count
      FROM playlists p
      LEFT JOIN playlist_tracks pt ON p.id = pt.playlist_id
      WHERE p.user_id = ?
      GROUP BY p.id
      ORDER BY p.created_at DESC
    ''', [userId]);
    
    return List.generate(result.length, (i) => Playlist.fromMap(result[i]));
  }

  /// Добавление трека в плейлист
  Future<int> addTrackToPlaylist(int playlistId, String trackId) async {
    final db = await database;
    
    // Получаем текущую максимальную позицию
    final result = await db.rawQuery(
      'SELECT MAX(position) as max_pos FROM playlist_tracks WHERE playlist_id = ?',
      [playlistId],
    );
    final maxPos = result.first['max_pos'] as int? ?? -1;
    
    return await db.insert('playlist_tracks', {
      'playlist_id': playlistId,
      'track_id': trackId,
      'position': maxPos + 1,
      'added_at': DateTime.now().toIso8601String(),
    });
  }

  /// Удаление трека из плейлиста
  Future<int> removeTrackFromPlaylist(int playlistId, String trackId) async {
    final db = await database;
    return await db.delete(
      'playlist_tracks',
      where: 'playlist_id = ? AND track_id = ?',
      whereArgs: [playlistId, trackId],
    );
  }

  /// Получение треков плейлиста
  Future<List<Track>> getPlaylistTracks(int playlistId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT t.* FROM tracks t
      INNER JOIN playlist_tracks pt ON t.id = pt.track_id
      WHERE pt.playlist_id = ?
      ORDER BY pt.position
    ''', [playlistId]);
    
    return List.generate(result.length, (i) => Track.fromJson(result[i]));
  }

  // ==================== ИСТОРИЯ ====================

  /// Добавление записи в историю
  Future<int> addToHistory(int userId, String trackId) async {
    final db = await database;
    return await db.insert('listening_history', {
      'user_id': userId,
      'track_id': trackId,
      'played_at': DateTime.now().toIso8601String(),
    });
  }

  /// Получение истории прослушиваний
  Future<List<Track>> getListeningHistory(int userId, {int limit = 50}) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT t.* FROM tracks t
      INNER JOIN listening_history lh ON t.id = lh.track_id
      WHERE lh.user_id = ?
      ORDER BY lh.played_at DESC
      LIMIT ?
    ''', [userId, limit]);
    
    return List.generate(result.length, (i) => Track.fromJson(result[i]));
  }

  // ==================== ОЧИСТКА ====================

  /// Очистка всей базы данных (для тестирования)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('users');
    await db.delete('tracks');
    await db.delete('playlists');
    await db.delete('playlist_tracks');
    await db.delete('likes');
    await db.delete('comments');
    await db.delete('follows');
    await db.delete('listening_history');
    debugPrint('🗑️ База данных очищена');
  }

  /// Закрытие базы данных
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
