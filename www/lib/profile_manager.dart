import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// Упрощённый менеджер профиля пользователя
/// Без паролей, авторизации и социальных функций
class ProfileManager {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  // Основные данные профиля
  String userName = 'Пользователь';
  String? avatarPath;
  
  // Настройки отображения профиля
  Color? profileBackgroundColor;
  List<Color>? profileGradientColors;
  double? profileGradientAngle;
  bool showCardBorders = true;
  bool minimalMode = false;

  /// Инициализация - загрузка сохранённых данных
  Future<void> init() async {
    await load();
  }

  /// Сохранение профиля
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('userName', userName);
    
    if (avatarPath != null) {
      await prefs.setString('avatarPath', avatarPath!);
    }
    
    if (profileBackgroundColor != null) {
      await prefs.setInt('profileBgColor', profileBackgroundColor!.value);
    }
    
    if (profileGradientColors != null && profileGradientColors!.isNotEmpty) {
      final colorValues = profileGradientColors!.map((c) => c.value).toList();
      await prefs.setString('profileGradient', colorValues.join(','));
    }
    
    if (profileGradientAngle != null) {
      await prefs.setDouble('profileGradientAngle', profileGradientAngle!);
    }
    
    await prefs.setBool('showCardBorders', showCardBorders);
    await prefs.setBool('minimalMode', minimalMode);
  }

  /// Загрузка сохранённого профиля
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    
    userName = prefs.getString('userName') ?? 'Пользователь';
    avatarPath = prefs.getString('avatarPath');
    
    final bgColorValue = prefs.getInt('profileBgColor');
    if (bgColorValue != null) {
      profileBackgroundColor = Color(bgColorValue);
    }
    
    final gradientStr = prefs.getString('profileGradient');
    if (gradientStr != null) {
      final colorValues = gradientStr.split(',').map(int.parse).toList();
      profileGradientColors = colorValues.map((v) => Color(v)).toList();
    }
    
    profileGradientAngle = prefs.getDouble('profileGradientAngle');
    showCardBorders = prefs.getBool('showCardBorders') ?? true;
    minimalMode = prefs.getBool('minimalMode') ?? false;
  }

  /// Обновить имя пользователя
  Future<void> updateUserName(String name) async {
    userName = name.trim();
    if (userName.isEmpty) {
      userName = 'Пользователь';
    }
    await save();
  }

  /// Обновить аватар
  Future<void> updateAvatar(String? path) async {
    avatarPath = path;
    await save();
  }

  /// Установить фон профиля (сплошной цвет)
  Future<void> setProfileBackground(Color color) async {
    profileBackgroundColor = color;
    profileGradientColors = null;
    await save();
  }

  /// Установить градиентный фон профиля
  Future<void> setProfileGradient(List<Color> colors, double angle) async {
    profileGradientColors = colors;
    profileGradientAngle = angle;
    profileBackgroundColor = null;
    await save();
  }

  /// Переключить обводки карточек
  Future<void> toggleCardBorders() async {
    showCardBorders = !showCardBorders;
    await save();
  }

  /// Переключить минимальный режим
  Future<void> toggleMinimalMode() async {
    minimalMode = !minimalMode;
    await save();
  }

  /// Сброс профиля к стандартным настройкам
  Future<void> reset() async {
    userName = 'Пользователь';
    avatarPath = null;
    profileBackgroundColor = null;
    profileGradientColors = null;
    profileGradientAngle = null;
    showCardBorders = true;
    minimalMode = false;
    await save();
  }
}
