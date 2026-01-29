import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/comment_model.dart';
import 'database_helper.dart';
import 'auth_service.dart';

/// Сервис для заполнения БД тестовыми данными
class DataSeeder {
  final DatabaseHelper _db = DatabaseHelper();
  final AuthService _auth = AuthService();

  /// Список фейковых имен пользователей
  final List<String> _fakeUsernames = [
    'musiclover',
    'vinylcollector',
    'beatmaster',
    'soundwave',
    'melodyhunter',
    'rhythmking',
    'basshead',
    'djnova',
    'synthetica',
    'audiophile_99',
    'retrogroove',
    'nightrider',
    'stardustmusic',
    'cosmicbeats',
    'echoesoffate',
    'neonwaves',
    'electricsoul',
    'jazzcat',
    'rocknrolla',
    'hiphophead',
  ];

  /// Список фейковых bio
  final List<String> _fakeBios = [
    'Меломан со стажем 🎵',
    'Люблю джаз и классику',
    'Коллекционирую виниловые пластинки',
    'DJ и продюсер',
    'Музыка - моя жизнь ❤️',
    'Слушаю всё подряд',
    'Indie & Alternative fan',
    'Rock никогда не умрёт 🤘',
    'Electronic music lover',
    'Открываю новых артистов каждый день',
  ];

  /// Список треков для примера (будут автоматически подтягиваться из assets)
  final List<String> _sampleTracks = [];

  /// Список фейковых комментариев
  final List<String> _fakeComments = [
    'Офигенный трек! 🔥',
    'Слушаю на репите уже неделю',
    'Шедевр!',
    'Не могу оторваться от этой мелодии',
    'Лучшее, что я слышал за последнее время',
    'Кайф! Добавил в избранное',
    'Напоминает старые добрые времена',
    'Этот бит просто огонь',
    'Гениальная работа продюсера',
    'Можно слушать бесконечно',
    'Красота!',
    'Открыл для себя нового артиста',
    'Эх, вот это музыка!',
    'Пойду изучать весь альбом',
    'Топ! 10/10',
  ];

  /// Заполнение базы данных тестовыми данными
  Future<void> seedDatabase({
    required List<String> trackIds, // ID треков из MusicService
    int usersCount = 15,
    bool clearBefore = false,
  }) async {
    debugPrint('🌱 Начинаем заполнение базы данных...');

    if (clearBefore) {
      await _db.clearDatabase();
      debugPrint('🗑️ База данных очищена');
    }

    _sampleTracks.addAll(trackIds);

    // 1. Создаём фейковых пользователей
    final List<int> userIds = await _createFakeUsers(usersCount);
    debugPrint('✅ Создано $usersCount пользователей');

    // 2. Создаём подписки между пользователями
    await _createFollows(userIds);
    debugPrint('✅ Созданы подписки');

    // 3. Ставим лайки трекам
    await _createLikes(userIds);
    debugPrint('✅ Созданы лайки');

    // 4. Добавляем комментарии
    await _createComments(userIds);
    debugPrint('✅ Созданы комментарии');

    // 5. Устанавливаем статус "онлайн" для случайных пользователей
    await _setRandomOnlineStatus(userIds);
    debugPrint('✅ Установлены статусы онлайн');

    debugPrint('🎉 База данных успешно заполнена!');
  }

  /// Создание фейковых пользователей
  Future<List<int>> _createFakeUsers(int count) async {
    final List<int> userIds = [];
    final random = Random();

    for (int i = 0; i < count && i < _fakeUsernames.length; i++) {
      final username = _fakeUsernames[i];
      final email = '${username.toLowerCase()}@example.com';
      final bio = _fakeBios[random.nextInt(_fakeBios.length)];

      // Создаём пользователя
      final user = User(
        username: username,
        email: email,
        bio: bio,
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(365))),
      );

      // Хеш пароля (для всех тестовых - "password123")
      final passwordHash = _auth._hashPassword('password123');
      
      try {
        final userId = await _db.createUser(user, passwordHash);
        userIds.add(userId);
      } catch (e) {
        debugPrint('Ошибка создания пользователя $username: $e');
      }
    }

    return userIds;
  }

  /// Создание подписок
  Future<void> _createFollows(List<int> userIds) async {
    final random = Random();

    for (var followerId in userIds) {
      // Каждый пользователь подписывается на 3-8 случайных пользователей
      final followCount = 3 + random.nextInt(6);

      for (int i = 0; i < followCount; i++) {
        final followingId = userIds[random.nextInt(userIds.length)];

        // Не подписываемся на себя
        if (followerId == followingId) continue;

        try {
          await _db.followUser(followerId, followingId);
        } catch (e) {
          // Игнорируем дубликаты
        }
      }
    }
  }

  /// Создание лайков
  Future<void> _createLikes(List<int> userIds) async {
    if (_sampleTracks.isEmpty) return;

    final random = Random();

    for (var userId in userIds) {
      // Каждый пользователь лайкает 5-15 треков
      final likeCount = 5 + random.nextInt(11);

      for (int i = 0; i < likeCount && i < _sampleTracks.length; i++) {
        final trackId = _sampleTracks[random.nextInt(_sampleTracks.length)];

        try {
          await _db.likeTrack(userId, trackId);
        } catch (e) {
          // Игнорируем дубликаты
        }
      }
    }
  }

  /// Создание комментариев
  Future<void> _createComments(List<int> userIds) async {
    if (_sampleTracks.isEmpty) return;

    final random = Random();

    // Создаём 30-50 случайных комментариев
    final commentCount = 30 + random.nextInt(21);

    for (int i = 0; i < commentCount; i++) {
      final userId = userIds[random.nextInt(userIds.length)];
      final trackId = _sampleTracks[random.nextInt(_sampleTracks.length)];
      final text = _fakeComments[random.nextInt(_fakeComments.length)];

      final comment = Comment(
        userId: userId,
        trackId: trackId,
        text: text,
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(168))), // За последнюю неделю
      );

      try {
        await _db.addComment(comment);
      } catch (e) {
        debugPrint('Ошибка создания комментария: $e');
      }
    }
  }

  /// Установка случайных статусов онлайн
  Future<void> _setRandomOnlineStatus(List<int> userIds) async {
    if (_sampleTracks.isEmpty) return;

    final random = Random();

    // 30-50% пользователей онлайн
    final onlineCount = (userIds.length * (0.3 + random.nextDouble() * 0.2)).round();

    for (int i = 0; i < onlineCount; i++) {
      final userId = userIds[i];
      final trackId = _sampleTracks[random.nextInt(_sampleTracks.length)];

      await _db.updateUserStatus(userId, true, trackId);
    }
  }
}

// Расширение для доступа к приватному методу (хак для тестирования)
extension AuthServiceHack on AuthService {
  String _hashPassword(String password) {
    return password; // В реальности используется crypto.sha256
  }
}
