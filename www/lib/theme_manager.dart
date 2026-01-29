import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static ThemeManager? _instance;
  static ThemeManager get instance {
    _instance ??= ThemeManager._();
    return _instance!;
  }

  ThemeManager._();

  // Default colors
  Color _primaryColor = const Color(0xFFEFEDE3);
  Color _backgroundColor = const Color(0xFF171716);
  Color _secondaryBackgroundColor = const Color(0xFF1C1C1C);
  Color _textColor = const Color(0xFFEFEDE3);
  Color _secondaryTextColor = const Color(0xFFB8B6B0);

  // Getters
  Color get primaryColor => _primaryColor;
  Color get backgroundColor => _backgroundColor;
  Color get secondaryBackgroundColor => _secondaryBackgroundColor;
  Color get textColor => _textColor;
  Color get secondaryTextColor => _secondaryTextColor;

  Map<String, int> toMap() {
    return {
      'primaryColor': _primaryColor.value,
      'backgroundColor': _backgroundColor.value,
      'secondaryBackgroundColor': _secondaryBackgroundColor.value,
      'textColor': _textColor.value,
      'secondaryTextColor': _secondaryTextColor.value,
    };
  }

  void applyMap(Map<String, dynamic> data) {
    _primaryColor = Color(
      data['primaryColor'] is int ? data['primaryColor'] as int : _primaryColor.value,
    );
    _backgroundColor = Color(
      data['backgroundColor'] is int ? data['backgroundColor'] as int : _backgroundColor.value,
    );
    _secondaryBackgroundColor = Color(
      data['secondaryBackgroundColor'] is int
          ? data['secondaryBackgroundColor'] as int
          : _secondaryBackgroundColor.value,
    );
    _textColor = Color(
      data['textColor'] is int ? data['textColor'] as int : _textColor.value,
    );
    _secondaryTextColor = Color(
      data['secondaryTextColor'] is int
          ? data['secondaryTextColor'] as int
          : _secondaryTextColor.value,
    );
    _save();
    notifyListeners();
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _primaryColor = Color(
      prefs.getInt('theme_primaryColor') ?? _primaryColor.value,
    );
    _backgroundColor = Color(
      prefs.getInt('theme_backgroundColor') ?? _backgroundColor.value,
    );
    _secondaryBackgroundColor = Color(
      prefs.getInt('theme_secondaryBackgroundColor') ??
          _secondaryBackgroundColor.value,
    );
    _textColor = Color(
      prefs.getInt('theme_textColor') ?? _textColor.value,
    );
    _secondaryTextColor = Color(
      prefs.getInt('theme_secondaryTextColor') ?? _secondaryTextColor.value,
    );
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_primaryColor', _primaryColor.value);
    await prefs.setInt('theme_backgroundColor', _backgroundColor.value);
    await prefs.setInt(
      'theme_secondaryBackgroundColor',
      _secondaryBackgroundColor.value,
    );
    await prefs.setInt('theme_textColor', _textColor.value);
    await prefs.setInt('theme_secondaryTextColor', _secondaryTextColor.value);
  }

  // Setters with notify
  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _save();
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    _save();
    notifyListeners();
  }

  void setSecondaryBackgroundColor(Color color) {
    _secondaryBackgroundColor = color;
    _save();
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    _save();
    notifyListeners();
  }

  void setSecondaryTextColor(Color color) {
    _secondaryTextColor = color;
    _save();
    notifyListeners();
  }

  // Reset to default
  void resetToDefault() {
    _primaryColor = const Color(0xFFEFEDE3);
    _backgroundColor = const Color(0xFF171716);
    _secondaryBackgroundColor = const Color(0xFF1C1C1C);
    _textColor = const Color(0xFFEFEDE3);
    _secondaryTextColor = const Color(0xFFB8B6B0);
    _save();
    notifyListeners();
  }

  // Get theme data
  ThemeData getThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _backgroundColor,
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        surface: _secondaryBackgroundColor,
        onSurface: _textColor,
      ),
    );
  }
}

