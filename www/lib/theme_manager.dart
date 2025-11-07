import 'package:flutter/material.dart';

class ThemeManager {
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

  // Setters with notify
  void setPrimaryColor(Color color) {
    _primaryColor = color;
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
  }

  void setSecondaryBackgroundColor(Color color) {
    _secondaryBackgroundColor = color;
  }

  void setTextColor(Color color) {
    _textColor = color;
  }

  void setSecondaryTextColor(Color color) {
    _secondaryTextColor = color;
  }

  // Reset to default
  void resetToDefault() {
    _primaryColor = const Color(0xFFEFEDE3);
    _backgroundColor = const Color(0xFF171716);
    _secondaryBackgroundColor = const Color(0xFF1C1C1C);
    _textColor = const Color(0xFFEFEDE3);
    _secondaryTextColor = const Color(0xFFB8B6B0);
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

