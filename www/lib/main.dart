import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.instance;
    return MaterialApp(
      title: 'Music App',
      theme: themeManager.getThemeData(),
      debugShowCheckedModeBanner: false,
      home: const AuthScreen(),
    );
  }
}