import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'database_helper.dart';

/// Сервис авторизации пользователей
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseHelper _db = DatabaseHelper();
  
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  int? get currentUserId => _currentUser?.id;

  /// Инициализация сервиса
  Future<void> init() async {
    await _loadCurrentUser();
  }

  /// Хеширование пароля
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Регистрация нового пользователя
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Проверка на существующего пользователя
      final existingUserByEmail = await _db.getUserByEmail(email);
      if (existingUserByEmail != null) {
        return {
          'success': false,
          'message': 'Пользователь с таким email уже существует',
        };
      }

      final existingUserByUsername = await _db.getUserByUsername(username);
      if (existingUserByUsername != null) {
        return {
          'success': false,
          'message': 'Пользователь с таким именем уже существует',
        };
      }

      // Создание нового пользователя
      final newUser = User(
        username: username,
        email: email,
        createdAt: DateTime.now(),
      );

      final passwordHash = _hashPassword(password);
      final userId = await _db.createUser(newUser, passwordHash);

      // Получаем созданного пользователя
      _currentUser = await _db.getUserById(userId);
      _isLoggedIn = true;

      // Сохраняем в SharedPreferences
      await _saveCurrentUser(userId);

      notifyListeners();

      return {
        'success': true,
        'message': 'Регистрация успешна!',
        'user': _currentUser,
      };
    } catch (e) {
      debugPrint('Ошибка регистрации: $e');
      return {
        'success': false,
        'message': 'Ошибка регистрации: $e',
      };
    }
  }

  /// Вход в систему
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Проверка существования пользователя
      final user = await _db.getUserByEmail(email);
      if (user == null) {
        return {
          'success': false,
          'message': 'Неверный email или пароль',
        };
      }

      // Проверка пароля
      final passwordHash = _hashPassword(password);
      final storedHash = await _db.getPasswordHash(email);

      if (storedHash != passwordHash) {
        return {
          'success': false,
          'message': 'Неверный email или пароль',
        };
      }

      // Успешный вход
      _currentUser = user;
      _isLoggedIn = true;

      // Обновляем статус онлайн
      await _db.updateUserStatus(user.id!, true, null);

      // Сохраняем в SharedPreferences
      await _saveCurrentUser(user.id!);

      notifyListeners();

      return {
        'success': true,
        'message': 'Вход выполнен успешно!',
        'user': _currentUser,
      };
    } catch (e) {
      debugPrint('Ошибка входа: $e');
      return {
        'success': false,
        'message': 'Ошибка входа: $e',
      };
    }
  }

  /// Выход из системы
  Future<void> logout() async {
    if (_currentUser != null && _currentUser!.id != null) {
      // Обновляем статус оффлайн
      await _db.updateUserStatus(_currentUser!.id!, false, null);
    }

    _currentUser = null;
    _isLoggedIn = false;

    // Удаляем из SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');

    notifyListeners();
  }

  /// Обновление текущего трека пользователя
  Future<void> updateCurrentTrack(String? trackId) async {
    if (_currentUser == null || _currentUser!.id == null) return;

    await _db.updateUserStatus(_currentUser!.id!, true, trackId);
    _currentUser = _currentUser!.copyWith(
      isOnline: true,
      currentTrackId: trackId,
    );
    notifyListeners();
  }

  /// Обновление профиля
  Future<void> updateProfile(User updatedUser) async {
    await _db.updateUser(updatedUser);
    _currentUser = updatedUser;
    notifyListeners();
  }

  /// Сохранение текущего пользователя в SharedPreferences
  Future<void> _saveCurrentUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', userId);
  }

  /// Загрузка текущего пользователя из SharedPreferences
  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('current_user_id');

    if (userId != null) {
      _currentUser = await _db.getUserById(userId);
      _isLoggedIn = _currentUser != null;

      if (_isLoggedIn) {
        // Обновляем статус онлайн при запуске
        await _db.updateUserStatus(userId, true, null);
      }

      notifyListeners();
    }
  }

  /// Получение пользователя по ID
  Future<User?> getUserById(int userId) async {
    return await _db.getUserById(userId);
  }

  /// Проверка подписки на пользователя
  Future<bool> isFollowing(int targetUserId) async {
    if (_currentUser == null || _currentUser!.id == null) return false;
    return await _db.isFollowing(_currentUser!.id!, targetUserId);
  }

  /// Подписка на пользователя
  Future<void> followUser(int targetUserId) async {
    if (_currentUser == null || _currentUser!.id == null) return;
    await _db.followUser(_currentUser!.id!, targetUserId);
    notifyListeners();
  }

  /// Отписка от пользователя
  Future<void> unfollowUser(int targetUserId) async {
    if (_currentUser == null || _currentUser!.id == null) return;
    await _db.unfollowUser(_currentUser!.id!, targetUserId);
    notifyListeners();
  }

  /// Получение друзей онлайн
  Future<List<User>> getOnlineFriends() async {
    if (_currentUser == null || _currentUser!.id == null) return [];
    return await _db.getOnlineFriends(_currentUser!.id!);
  }

  /// Получение подписчиков
  Future<List<User>> getFollowers() async {
    if (_currentUser == null || _currentUser!.id == null) return [];
    return await _db.getFollowers(_currentUser!.id!);
  }

  /// Получение подписок
  Future<List<User>> getFollowing() async {
    if (_currentUser == null || _currentUser!.id == null) return [];
    return await _db.getFollowing(_currentUser!.id!);
  }

  /// Получение количества подписчиков
  Future<int> getFollowersCount(int userId) async {
    return await _db.getFollowersCount(userId);
  }

  /// Получение количества подписок
  Future<int> getFollowingCount(int userId) async {
    return await _db.getFollowingCount(userId);
  }
}
