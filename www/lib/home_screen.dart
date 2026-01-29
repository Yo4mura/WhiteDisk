import 'package:flutter/material.dart';

import 'home_widgets.dart';
import 'theme_manager.dart';
import 'library_screen.dart';
import 'music_service.dart';
import 'player_screen.dart';
import 'playlist_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'track_model.dart';

// ==================== HOME SCREEN ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final MusicService _musicService = MusicService();
  
  // Состояние мини-плеера (имитация)
  bool _isPlaying = false;
  String _currentTrack = 'Tokyo Drift';
  String _currentArtist = 'Yoshimura';
  String _currentCover = 'assets/vinyl5.png';
  
  /// Поиск трека по названию и артисту
  Track? _findTrack(String title, String artist) {
    try {
      return _musicService.tracks.firstWhere(
        (t) => t.title == title && t.artist == artist,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.instance.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _selectedIndex == 3
                  ? const ProfileScreen()
                  : _selectedIndex == 2
                  ? const LibraryScreen()
                  : _selectedIndex == 1
                  ? const SearchScreen()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          // Title
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Рекомендации',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Мини-плеер виджет (имитация)
                          _buildMiniPlayerWidget(),
                          const SizedBox(height: 24),

                          // 1. Featured playlists (Best Of Year)
                          SizedBox(
                            height: 255,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const FeaturedPlaylistCard(
                                  title: 'Best Of Year',
                                  description:
                                      'Топ-музыка года — от проверенных хитов до неожиданных открытий. Всегда свежие треки на вашей главной странице',
                                  imagePath: 'assets/31fed70fb44cf684397169b327cab9d5.jpg',
                                ),
                                const SizedBox(width: 12),
                                const FeaturedPlaylistCard(
                                  title: 'Лучшие исполнители за се...',
                                  description:
                                      'Топ-исполнители текущего сезона — самые популярные треки последних месяцев.',
                                  imagePath: 'assets/41dc8e4e6ceab592fbb46b5e3f545dac.jpg',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 2. Music status section (Друзья онлайн)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2A2A28),
                                    Color(0xFF1F1F1E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFFEFEDE3,
                                  ).withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Currently playing
                                  Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: ThemeManager.instance.textColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.asset(
                                            'assets/4db574e2cee0e13f00f9351a356fc21d.jpg',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: const Color(
                                                      0xFF3D3C38,
                                                    ),
                                                    child: Icon(
                                                      Icons.music_note,
                                                      color: Colors.white54,
                                                      size: 24,
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.music_note,
                                                  size: 14,
                                                  color: Color(0xFFB8B6B0),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Сейчас слушаю',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFFB8B6B0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Mad Boy (feat. ALKUN)',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFEFEDE3),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF4CAF50,
                                          ).withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF4CAF50),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              color: Color(0xFF4CAF50),
                                              size: 8,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Live',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF4CAF50),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  // Friends online
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFEFEDE3,
                                      ).withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        // Friends avatars
                                        Stack(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF171716,
                                                  ),
                                                  width: 2,
                                                ),
                                              ),
                                              child: ClipOval(
                                                child: Image.asset(
                                                  'assets/746327ec1c669b09f965de5d195198e8.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 20,
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF171716,
                                                    ),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/8c5e2c48628416f0b7464f79596ec0df.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: 40,
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF171716,
                                                    ),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.asset(
                                                    'assets/9a7871b01076799c9d4d95fec3d14e06.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 60),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Color(
                                                            0xFF4CAF50,
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    '5 друзей сейчас онлайн',
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFEFEDE3),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'shibob, Yoshimura и другие',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: const Color(
                                                    0xFFEFEDE3,
                                                  ).withValues(alpha: 0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 3. Daily Mix section
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.queue_music,
                                  size: 24,
                                  color: Color(0xFFEFEDE3),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Daily Mix для тебя',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEFEDE3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            height: 220,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const DailyMixCard(
                                  mixNumber: 1,
                                  title: 'Daily Mix 1',
                                  subtitle: 'ALKUN, Yoshimura и другие',
                                  imagePath: 'assets/b64ab0d02093bf822f74375c79e24e23.jpg',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const DailyMixCard(
                                  mixNumber: 2,
                                  title: 'Daily Mix 2',
                                  subtitle: 'shibob, CUPSIZE и другие',
                                  imagePath: 'assets/b8be167d06c4a74174af808843cb9db4.jpg',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFFA06B),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const DailyMixCard(
                                  mixNumber: 3,
                                  title: 'Daily Mix 3',
                                  subtitle: 'Твой чилл',
                                  imagePath: 'assets/cdf42b8bf42351fdf0aed76a1efa1a4d.jpg',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF56CCF2),
                                      Color(0xFF2F80ED),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const DailyMixCard(
                                  mixNumber: 4,
                                  title: 'Daily Mix 4',
                                  subtitle: 'Энергия и драйв',
                                  imagePath: 'assets/dada9e612a304c6228f597fb30f58d31.jpg',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF4E50),
                                      Color(0xFFF9D423),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 4. Section: "Тебе понравится"
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Тебе понравится, Yoshimura',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Horizontal album list
                          SizedBox(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const AlbumCard(
                                  title: 'Микс #1',
                                  artist:
                                      'shit, денди, Amorbius, aishi и другие',
                                  imagePath: 'assets/e27ce83b1f94fe83ef3cc161d1d066ae.jpg',
                                ),
                                const SizedBox(width: 12),
                                const AlbumCard(
                                  title: 'Микс #1',
                                  artist:
                                      'shit, денди, Amorbius, aishi и другие',
                                  imagePath: 'assets/vinyl1.png',
                                ),
                                const SizedBox(width: 12),
                                const AlbumCard(
                                  title: 'Микс #1',
                                  artist:
                                      'shit, денди, Amorbius, aishi и другие',
                                  imagePath: 'assets/vinyl2.png',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 5. Mood cards section
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Настроение',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Mood cards horizontal scroll
                          SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                MoodCard(
                                  icon: Icons.sentiment_satisfied_alt,
                                  label: 'Радость',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                                const SizedBox(width: 12),
                                MoodCard(
                                  icon: Icons.sentiment_dissatisfied,
                                  label: 'Грусть',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                                const SizedBox(width: 12),
                                MoodCard(
                                  icon: Icons.fitness_center,
                                  label: 'Мотивация',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                                const SizedBox(width: 12),
                                MoodCard(
                                  icon: Icons.celebration,
                                  label: 'Вечеринка',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                                const SizedBox(width: 12),
                                MoodCard(
                                  icon: Icons.menu_book,
                                  label: 'Учёба',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                                const SizedBox(width: 12),
                                MoodCard(
                                  icon: Icons.bedtime,
                                  label: 'Сон',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                                const SizedBox(width: 12),
                                MoodCard(
                                  icon: Icons.heart_broken,
                                  label: 'Расставание',
                                  color: ThemeManager.instance.secondaryBackgroundColor,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 6. Weekly stats section
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Твоя статистика',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: ThemeManager.instance.secondaryBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ThemeManager.instance.textColor,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.bar_chart,
                                        size: 24,
                                        color: Color(0xFFEFEDE3),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Эта неделя',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFEFEDE3),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Stats grid
                                  Row(
                                    children: [
                                      Expanded(
                                        child: const StatItem(
                                          icon: Icons.headphones,
                                          value: '12ч 34м',
                                          label: 'Прослушано',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: const StatItem(
                                          icon: Icons.local_fire_department,
                                          value: '7 дней',
                                          label: 'Streak',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: const StatItem(
                                          icon: Icons.star,
                                          value: 'ALKUN',
                                          label: 'Топ артист',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: const StatItem(
                                          icon: Icons.music_note,
                                          value: '142',
                                          label: 'Треков',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 7. Time of day music section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: ThemeManager.instance.secondaryBackgroundColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ThemeManager.instance.textColor,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _getTimeOfDayEmoji(),
                                    style: TextStyle(fontSize: 48),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getTimeOfDayTitle(),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEFEDE3),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _getTimeOfDaySubtitle(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFFEFEDE3),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistScreen(
                                            title: _getTimeOfDayTitle(),
                                            description:
                                                _getTimeOfDaySubtitle(),
                                            imagePath: 'assets/vinyl3.png',
                                            songCount: 30,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 42,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // 8. Section: "Недавние"
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Недавние',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Playlist row
                          SizedBox(
                            height: 180,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const PlaylistCard(
                                  title: 'Плейлист - Kireko',
                                  imagePath: 'assets/vinyl4.png',
                                ),
                                const SizedBox(width: 12),
                                const PlaylistCard(
                                  title: 'Плейлист - лллллл',
                                  imagePath: 'assets/vinyl5.png',
                                ),
                                const SizedBox(width: 12),
                                const PlaylistCard(
                                  title: 'Плейлист',
                                  imagePath: 'assets/31fed70fb44cf684397169b327cab9d5.jpg',
                                ),
                                const SizedBox(width: 12),
                                const PlaylistCard(
                                  title: 'Плейлист',
                                  imagePath: 'assets/41dc8e4e6ceab592fbb46b5e3f545dac.jpg',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 9. Section: "Популярные артисты"
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Популярные артисты',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Artists row
                          SizedBox(
                            height: 210,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                const ArtistCard(
                                  artistName: 'ALKUN',
                                  imagePath: 'assets/4db574e2cee0e13f00f9351a356fc21d.jpg',
                                  monthlyListeners: 5420000,
                                ),
                                const SizedBox(width: 12),
                                const ArtistCard(
                                  artistName: 'Yoshimura',
                                  imagePath: 'assets/746327ec1c669b09f965de5d195198e8.jpg',
                                  monthlyListeners: 3200000,
                                ),
                                const SizedBox(width: 12),
                                const ArtistCard(
                                  artistName: 'CUPSIZE',
                                  imagePath: 'assets/8c5e2c48628416f0b7464f79596ec0df.jpg',
                                  monthlyListeners: 2850000,
                                ),
                                const SizedBox(width: 12),
                                const ArtistCard(
                                  artistName: 'shibob',
                                  imagePath: 'assets/9a7871b01076799c9d4d95fec3d14e06.jpg',
                                  monthlyListeners: 1920000,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
            ),

            // Now Playing Bar
            _buildNowPlayingBar(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // profile content moved to profile_screen.dart

  // Time of day methods
  String _getTimeOfDayEmoji() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 11) return '☀️';
    if (hour >= 11 && hour < 17) return '🌤️';
    if (hour >= 17 && hour < 21) return '🌅';
    return '🌙';
  }

  String _getTimeOfDayTitle() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 11) return 'Бодрое утро';
    if (hour >= 11 && hour < 17) return 'Фокус на работе';
    if (hour >= 17 && hour < 21) return 'Расслабься';
    return 'Ночная атмосфера';
  }

  String _getTimeOfDaySubtitle() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 11)
      return 'Энергичные треки для хорошего старта дня';
    if (hour >= 11 && hour < 17)
      return 'Музыка для концентрации и продуктивности';
    if (hour >= 17 && hour < 21) return 'Чилл-треки для вечернего отдыха';
    return 'Медленные треки для спокойной ночи';
  }

  Widget _buildMiniPlayerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          // Имитация запуска воспроизведения
          setState(() {
            _isPlaying = true;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                final track = _findTrack(_currentTrack, _currentArtist);
                if (track != null) {
                  return PlayerScreen(track: track);
                } else if (_musicService.tracks.isNotEmpty) {
                  return PlayerScreen(track: _musicService.tracks.first);
                } else {
                  return const Scaffold(
                    body: Center(child: Text('Нет доступных треков')),
                  );
                }
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThemeManager.instance.secondaryBackgroundColor,
                const Color(0xFF1F1F1E),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            children: [
              // Обложка
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 70,
                  color: ThemeManager.instance.secondaryBackgroundColor,
                  child: Image.asset(
                    _currentCover,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.music_note,
                        color: Color(0xFFEFEDE3),
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Информация о треке
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentTrack,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEFEDE3),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentArtist,
                      style: TextStyle(
                        fontSize: 13,
                        color: ThemeManager.instance.textColor.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Иконка воспроизведения
              Icon(
                Icons.play_arrow,
                color: ThemeManager.instance.textColor,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlayingBar() {
    return InkWell(
      onTap: () {
        final track = _findTrack(_currentTrack, _currentArtist);
        if (track != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(track: track),
            ),
          );
        } else if (_musicService.tracks.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(track: _musicService.tracks.first),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeManager.instance.secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThemeManager.instance.textColor, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: ThemeManager.instance.secondaryBackgroundColor,
                    child: Image.asset(
                      _currentCover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.music_note,
                          color: Color(0xFFEFEDE3),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Track info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentTrack,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEFEDE3),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _currentArtist,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Play button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: ThemeManager.instance.textColor,
                  ),
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                // Next button
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentTrack = 'Night Drive';
                      _currentArtist = 'CUPSIZE';
                      _currentCover = 'assets/b64ab0d02093bf822f74375c79e24e23.jpg';
                    });
                  },
                  icon: Icon(Icons.skip_next, color: Color(0xFFEFEDE3)),
                  iconSize: 32,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeManager.instance.backgroundColor,
        border: Border(
          top: BorderSide(
            color: ThemeManager.instance.textColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Главная', 0),
              _buildNavItem(Icons.search, 'Поиск', 1),
              _buildNavItem(Icons.video_library, 'Медиатека', 2),
              _buildNavItem(Icons.person, 'Профиль', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? ThemeManager.instance.textColor
                : ThemeManager.instance.secondaryTextColor,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? ThemeManager.instance.textColor
                  : ThemeManager.instance.secondaryTextColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
