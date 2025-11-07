import 'package:flutter/material.dart';
import 'dart:io';
import 'profile_screen.dart';
import 'library_screen.dart';
import 'search_screen.dart';
import 'player_screen.dart';
import 'playlist_screen.dart';
import 'artist_screen.dart';
import 'widget_creator_screen.dart';

// ==================== HOME SCREEN ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _createdWidgets = [];
  
  // Состояние мини-плеера (имитация)
  bool _isPlaying = false;
  String _currentTrack = 'Tokyo Drift';
  String _currentArtist = 'Yoshimura';
  String _currentCover = 'assets/vinyl2.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
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
                                _buildFeaturedCard(
                                  title: 'Best Of Year',
                                  description:
                                      'Топ-музыка года — от проверенных хитов до неожиданных открытий. Всегда свежие треки на вашей главной странице',
                                  imagePath: 'assets/vinyl1.png',
                                ),
                                const SizedBox(width: 12),
                                _buildFeaturedCard(
                                  title: 'Лучшие исполнители за се...',
                                  description:
                                      'Топ-исполнители текущего сезона — самые популярные треки последних месяцев.',
                                  imagePath: 'assets/vinyl2.png',
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
                                            color: const Color(0xFFEFEDE3),
                                            width: 2,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Image.asset(
                                            'assets/vinyl1.png',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return Container(
                                                    color: const Color(
                                                      0xFF3D3C38,
                                                    ),
                                                    child: const Icon(
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
                                                const Icon(
                                                  Icons.music_note,
                                                  size: 14,
                                                  color: Color(0xFFB8B6B0),
                                                ),
                                                const SizedBox(width: 4),
                                                const Text(
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
                                              style: const TextStyle(
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
                                                  'assets/vinyl2.png',
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
                                                    'assets/vinyl3.png',
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
                                                    'assets/vinyl4.png',
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
                                                  const Text(
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
                                const Icon(
                                  Icons.queue_music,
                                  size: 24,
                                  color: Color(0xFFEFEDE3),
                                ),
                                const SizedBox(width: 8),
                                const Text(
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
                                _buildDailyMixCard(
                                  context,
                                  mixNumber: 1,
                                  title: 'Daily Mix 1',
                                  subtitle: 'ALKUN, Yoshimura и другие',
                                  imagePath: 'assets/vinyl1.png',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF667EEA),
                                      Color(0xFF764BA2),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildDailyMixCard(
                                  context,
                                  mixNumber: 2,
                                  title: 'Daily Mix 2',
                                  subtitle: 'shibob, CUPSIZE и другие',
                                  imagePath: 'assets/vinyl2.png',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B9D),
                                      Color(0xFFFFA06B),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildDailyMixCard(
                                  context,
                                  mixNumber: 3,
                                  title: 'Daily Mix 3',
                                  subtitle: 'Твой чилл',
                                  imagePath: 'assets/vinyl3.png',
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF56CCF2),
                                      Color(0xFF2F80ED),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _buildDailyMixCard(
                                  context,
                                  mixNumber: 4,
                                  title: 'Daily Mix 4',
                                  subtitle: 'Энергия и драйв',
                                  imagePath: 'assets/vinyl4.png',
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
                                _buildAlbumCard(
                                  title: 'Микс #1',
                                  artist:
                                      'shit, денди, Amorbius, aishi и другие',
                                  imagePath: 'assets/vinyl3.png',
                                ),
                                const SizedBox(width: 12),
                                _buildAlbumCard(
                                  title: 'Микс #1',
                                  artist:
                                      'shit, денди, Amorbius, aishi и другие',
                                  imagePath: 'assets/vinyl4.png',
                                ),
                                const SizedBox(width: 12),
                                _buildAlbumCard(
                                  title: 'Микс #1',
                                  artist:
                                      'shit, денди, Amorbius, aishi и другие',
                                  imagePath: 'assets/vinyl5.png',
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
                                _buildMoodCard(
                                  context,
                                  icon: Icons.sentiment_satisfied_alt,
                                  label: 'Радость',
                                  color: const Color(0xFF2A2A28),
                                ),
                                const SizedBox(width: 12),
                                _buildMoodCard(
                                  context,
                                  icon: Icons.sentiment_dissatisfied,
                                  label: 'Грусть',
                                  color: const Color(0xFF2A2A28),
                                ),
                                const SizedBox(width: 12),
                                _buildMoodCard(
                                  context,
                                  icon: Icons.fitness_center,
                                  label: 'Мотивация',
                                  color: const Color(0xFF2A2A28),
                                ),
                                const SizedBox(width: 12),
                                _buildMoodCard(
                                  context,
                                  icon: Icons.celebration,
                                  label: 'Вечеринка',
                                  color: const Color(0xFF2A2A28),
                                ),
                                const SizedBox(width: 12),
                                _buildMoodCard(
                                  context,
                                  icon: Icons.menu_book,
                                  label: 'Учёба',
                                  color: const Color(0xFF2A2A28),
                                ),
                                const SizedBox(width: 12),
                                _buildMoodCard(
                                  context,
                                  icon: Icons.bedtime,
                                  label: 'Сон',
                                  color: const Color(0xFF2A2A28),
                                ),
                                const SizedBox(width: 12),
                                _buildMoodCard(
                                  context,
                                  icon: Icons.heart_broken,
                                  label: 'Расставание',
                                  color: const Color(0xFF2A2A28),
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
                                color: const Color(0xFF2A2A28),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFEFEDE3),
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
                                        child: _buildStatItem(
                                          icon: Icons.headphones,
                                          value: '12ч 34м',
                                          label: 'Прослушано',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatItem(
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
                                        child: _buildStatItem(
                                          icon: Icons.star,
                                          value: 'ALKUN',
                                          label: 'Топ артист',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatItem(
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
                                color: const Color(0xFF2A2A28),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFEFEDE3),
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _getTimeOfDayEmoji(),
                                    style: const TextStyle(fontSize: 48),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getTimeOfDayTitle(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEFEDE3),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _getTimeOfDaySubtitle(),
                                          style: const TextStyle(
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
                                            imagePath: 'assets/vinyl1.png',
                                            songCount: 30,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
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
                                _buildPlaylistCard(
                                  title: 'Плейлист - Kireko',
                                  imagePath: 'assets/vinyl1.png',
                                ),
                                const SizedBox(width: 12),
                                _buildPlaylistCard(
                                  title: 'Плейлист - лллллл',
                                  imagePath: 'assets/vinyl2.png',
                                ),
                                const SizedBox(width: 12),
                                _buildPlaylistCard(
                                  title: 'Плейлист',
                                  imagePath: 'assets/vinyl3.png',
                                ),
                                const SizedBox(width: 12),
                                _buildPlaylistCard(
                                  title: 'Плейлист',
                                  imagePath: 'assets/vinyl4.png',
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
                                _buildArtistCard(
                                  artistName: 'ALKUN',
                                  imagePath: 'assets/vinyl1.png',
                                  monthlyListeners: 5420000,
                                ),
                                const SizedBox(width: 12),
                                _buildArtistCard(
                                  artistName: 'Yoshimura',
                                  imagePath: 'assets/vinyl2.png',
                                  monthlyListeners: 3200000,
                                ),
                                const SizedBox(width: 12),
                                _buildArtistCard(
                                  artistName: 'CUPSIZE',
                                  imagePath: 'assets/vinyl3.png',
                                  monthlyListeners: 2850000,
                                ),
                                const SizedBox(width: 12),
                                _buildArtistCard(
                                  artistName: 'shibob',
                                  imagePath: 'assets/vinyl4.png',
                                  monthlyListeners: 1920000,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // 9. Widgets Section
                          _buildWidgetsSection(context),
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

  Widget _buildFeaturedCard({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: title,
              description: description,
              imagePath: imagePath,
              songCount: 12,
            ),
          ),
        );
      },
      child: Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
      ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: const Color(0xFFEFEDE3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
                Container(
                  height: 180,
              width: double.infinity,
              color: const Color(0xFF1C1C1C),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF1C1C1C),
                    child: const Icon(
                      Icons.album,
                      size: 60,
                      color: Colors.white54,
                    ),
                  );
                },
            ),
          ),
          // Text content with white background
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                          fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                      const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                          fontSize: 11,
                    color: Color(0xFF000000),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumCard({
    required String title,
    required String artist,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: title,
              description: 'Альбом исполнителя $artist',
              imagePath: imagePath,
              songCount: 10,
            ),
          ),
        );
      },
      child: SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Album cover with white title background
          Container(
            height: 150,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
            ),
            child: Column(
              children: [
                // Image part
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFF1C1C1C),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF1C1C1C),
                            child: const Icon(
                              Icons.album,
                              size: 60,
                              color: Colors.white54,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // White title background
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFEDE3),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
            const SizedBox(height: 8),
            // Artist name
          Text(
            artist,
              style: const TextStyle(fontSize: 12, color: Color(0xFFEFEDE3)),
              maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard({
    required String title,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: title,
              description: 'Подборка лучших треков',
              imagePath: imagePath,
              songCount: 15,
            ),
          ),
        );
      },
      child: SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist cover
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF1C1C1C),
              border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF3D3C38),
                    child: const Icon(
                      Icons.playlist_play,
                      size: 60,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
            // Playlist title
          Text(
            title,
              style: const TextStyle(
              fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEFEDE3),
            ),
              maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildArtistCard({
    required String artistName,
    required String imagePath,
    required int monthlyListeners,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistScreen(
              artistName: artistName,
              bio:
                  'Один из самых популярных артистов современной музыкальной сцены',
              bannerPath: imagePath,
              avatarPath: imagePath,
              monthlyListeners: monthlyListeners,
              followers: (monthlyListeners * 0.3).toInt(),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Artist avatar (circle) - slightly larger
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEFEDE3), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF3D3C38),
                      child: const Icon(
                        Icons.person,
                        size: 65,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Artist name
            Text(
              artistName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEFEDE3),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            // Monthly listeners
            Text(
              '${_formatNumber(monthlyListeners)} слушателей',
              style: TextStyle(
                fontSize: 11,
                color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

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

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMixCard(
    BuildContext context, {
    required int mixNumber,
    required String title,
    required String subtitle,
    required String imagePath,
    required LinearGradient gradient,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: title,
              description:
                  'Плейлист создан специально для тебя • Обновляется каждый день',
              imagePath: imagePath,
              songCount: 50,
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover with gradient overlay
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2A28),
                          child: const Icon(
                            Icons.music_note,
                            size: 60,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          gradient.colors[0].withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Mix number
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Mix $mixNumber',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEFEDE3),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: 'Музыка для настроения: $label',
              description: 'Подборка треков под твоё настроение',
              imagePath: 'assets/vinyl1.png',
              songCount: 25,
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: const Color(0xFFEFEDE3)),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEFEDE3),
              ),
            ),
          ],
        ),
      ),
    );
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
              builder: (context) => PlayerScreen(
                songTitle: _currentTrack,
                artist: _currentArtist,
                coverPath: _currentCover,
              ),
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
                const Color(0xFF2A2A28),
                const Color(0xFF1F1F1E),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
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
                  color: const Color(0xFF3D3C38),
                  child: Image.asset(
                    _currentCover,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
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
                      style: const TextStyle(
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
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
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
                color: const Color(0xFFEFEDE3),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songTitle: _currentTrack,
              artist: _currentArtist,
              coverPath: _currentCover,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
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
                    color: const Color(0xFF3D3C38),
                    child: Image.asset(
                      _currentCover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
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
                        style: const TextStyle(
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
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
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
                    color: const Color(0xFFEFEDE3),
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
                      _currentCover = 'assets/vinyl3.png';
                    });
                  },
                  icon: const Icon(Icons.skip_next, color: Color(0xFFEFEDE3)),
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

  Widget _buildWidgetsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Мои виджеты',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEFEDE3),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const WidgetCreatorScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      _createdWidgets.add(result);
                    });
                  }
                },
                icon: const Icon(Icons.add, color: Color(0xFFEFEDE3), size: 20),
                label: const Text(
                  'Создать',
                  style: TextStyle(
                    color: Color(0xFFEFEDE3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_createdWidgets.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.widgets,
                    size: 48,
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Создайте виджет для рабочего стола',
                    style: TextStyle(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ..._createdWidgets.map(
                    (widget) => _buildWidgetPreviewCard(widget),
                  ),
                  const SizedBox(width: 12),
                  // Add new widget card
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WidgetCreatorScreen(),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _createdWidgets.add(result);
                        });
                      }
                    },
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 48,
                            color: const Color(
                              0xFFEFEDE3,
                            ).withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Создать виджет',
                            style: TextStyle(
                              color: const Color(
                                0xFFEFEDE3,
                              ).withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWidgetPreviewCard(Map<String, dynamic> widget) {
    final backgroundImage = widget['backgroundImage'] as String?;
    final isBackgroundFromGallery = widget['isBackgroundFromGallery'] as bool? ?? false;
    final contentName = widget['contentName'] as String? ?? 'Виджет';
    final contentType = widget['contentType'] as String? ?? 'playlist';
    
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Widget preview image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
                child: backgroundImage != null
                    ? (isBackgroundFromGallery
                        ? Image.file(
                            File(backgroundImage),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF2A2A28),
                                child: const Icon(
                                  Icons.image,
                                  color: Color(0xFFEFEDE3),
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Image.asset(
                            backgroundImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFF2A2A28),
                                child: const Icon(
                                  Icons.image,
                                  color: Color(0xFFEFEDE3),
                                  size: 40,
                                ),
                              );
                            },
                          ))
                    : Container(
                        color: const Color(0xFF2A2A28),
                        child: const Icon(
                          Icons.image,
                          color: Color(0xFFEFEDE3),
                          size: 40,
                        ),
                      ),
              ),
            ),
          ),
          // Widget info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contentName,
                  style: const TextStyle(
                    color: Color(0xFFEFEDE3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _getContentTypeLabel(contentType),
                  style: TextStyle(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getContentTypeLabel(String type) {
    switch (type) {
      case 'song':
        return 'Песня';
      case 'playlist':
        return 'Плейлист';
      case 'album':
        return 'Альбом';
      case 'artist':
        return 'Исполнитель';
      default:
        return '';
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171716),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
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
                ? const Color(0xFFEFEDE3)
                : const Color(0xFF7A7975),
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? const Color(0xFFEFEDE3)
                  : const Color(0xFF7A7975),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
