import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'theme_manager.dart';
import 'profile_manager.dart';
import 'music_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация сервисов
  await ThemeManager.instance.init();
  await ProfileManager().init();
  await MusicService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.instance;

    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, _) => MaterialApp(
        title: 'White Disk',
        theme: themeManager.getThemeData(),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}