import 'package:flutter/material.dart';
import 'theme_manager.dart';
import 'artist_screen.dart';
import 'playlist_screen.dart';
import 'player_screen.dart';
import 'music_service.dart';
import 'track_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchHistory = [];
  String _selectedFilter = 'Все'; // Все, Песни, Артисты, Плейлисты
  final MusicService _musicService = MusicService();
  
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
  
  // Популярные запросы
  final List<String> _popularQueries = [
    'ALKUN',
    'Yoshimura',
    'Tokyo Drift',
    'Chill Vibes',
    'Night Drive',
    'CUPSIZE',
  ];

  // Коллекции
  final List<String> _collections = [
    'Хиты',
    'Популярные авторы',
    'Начинающие авторы',
    'Мировые новинки',
    'Осенний вайб',
    'Рок музыка',
    'Электроника',
    'Джаз',
    'Хип-хоп',
    'Классика',
    'Инди',
    'Поп музыка',
    'R&B',
    'Рэп',
    'Метал',
    'Регги',
  ];

  // Изображения для коллекций (используем vinyl*.png)
  final List<String> _collectionImages = [
    'assets/8c5e2c48628416f0b7464f79596ec0df.jpg',
    'assets/9a7871b01076799c9d4d95fec3d14e06.jpg',
    'assets/b64ab0d02093bf822f74375c79e24e23.jpg',
    'assets/b8be167d06c4a74174af808843cb9db4.jpg',
    'assets/cdf42b8bf42351fdf0aed76a1efa1a4d.jpg',
    'assets/dada9e612a304c6228f597fb30f58d31.jpg',
    'assets/e27ce83b1f94fe83ef3cc161d1d066ae.jpg',
    'assets/vinyl1.png',
    'assets/vinyl2.png',
    'assets/vinyl3.png',
    'assets/vinyl4.png',
    'assets/vinyl5.png',
    'assets/31fed70fb44cf684397169b327cab9d5.jpg',
    'assets/41dc8e4e6ceab592fbb46b5e3f545dac.jpg',
    'assets/4db574e2cee0e13f00f9351a356fc21d.jpg',
    'assets/746327ec1c669b09f965de5d195198e8.jpg',
  ];

  // Мок-данные для результатов поиска
  List<Map<String, dynamic>> _getSearchResults(String query) {
    final queryLower = query.toLowerCase();
    final results = <Map<String, dynamic>>[];

    // Песни
    if (_selectedFilter == 'Все' || _selectedFilter == 'Песни') {
      final songs = [
        {'title': 'Mad Boy (feat. ALKUN)', 'artist': 'ALKUN & AI', 'type': 'song'},
        {'title': 'Tokyo Drift', 'artist': 'Yoshimura', 'type': 'song'},
        {'title': 'Night Drive', 'artist': 'CUPSIZE', 'type': 'song'},
        {'title': 'Sunset Boulevard', 'artist': 'ALKUN', 'type': 'song'},
        {'title': 'City Lights', 'artist': 'shibob', 'type': 'song'},
      ];
      for (var song in songs) {
        if (song['title'].toString().toLowerCase().contains(queryLower) ||
            song['artist'].toString().toLowerCase().contains(queryLower)) {
          results.add(song);
        }
      }
    }

    // Артисты
    if (_selectedFilter == 'Все' || _selectedFilter == 'Артисты') {
      final artists = [
        {'name': 'ALKUN', 'listeners': '5.4M', 'type': 'artist', 'image': 'assets/8c5e2c48628416f0b7464f79596ec0df.jpg'},
        {'name': 'Yoshimura', 'listeners': '3.2M', 'type': 'artist', 'image': 'assets/9a7871b01076799c9d4d95fec3d14e06.jpg'},
        {'name': 'CUPSIZE', 'listeners': '2.8M', 'type': 'artist', 'image': 'assets/b64ab0d02093bf822f74375c79e24e23.jpg'},
        {'name': 'shibob', 'listeners': '1.9M', 'type': 'artist', 'image': 'assets/b8be167d06c4a74174af808843cb9db4.jpg'},
      ];
      for (var artist in artists) {
        if (artist['name'].toString().toLowerCase().contains(queryLower)) {
          results.add(artist);
        }
      }
    }

    // Плейлисты
    if (_selectedFilter == 'Все' || _selectedFilter == 'Плейлисты') {
      final playlists = [
        {'title': 'Daily Mix 1', 'description': 'ALKUN, Yoshimura и другие', 'type': 'playlist', 'image': 'assets/cdf42b8bf42351fdf0aed76a1efa1a4d.jpg'},
        {'title': 'Chill Vibes', 'description': 'Расслабляющая музыка', 'type': 'playlist', 'image': 'assets/dada9e612a304c6228f597fb30f58d31.jpg'},
        {'title': 'Workout Mix', 'description': 'Энергичные треки', 'type': 'playlist', 'image': 'assets/e27ce83b1f94fe83ef3cc161d1d066ae.jpg'},
        {'title': 'Evening Relax', 'description': 'Вечерний отдых', 'type': 'playlist', 'image': 'assets/vinyl1.png'},
      ];
      for (var playlist in playlists) {
        if (playlist['title'].toString().toLowerCase().contains(queryLower) ||
            playlist['description'].toString().toLowerCase().contains(queryLower)) {
          results.add(playlist);
        }
      }
    }

    return results;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.instance.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Поиск',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEFEDE3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D3B37),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Color(0xFFEFEDE3)),
                      decoration: InputDecoration(
                        hintText: 'Артисты, песни или плейлисты',
                        hintStyle: TextStyle(
                          color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFEFEDE3),
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Color(0xFFEFEDE3),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _addToHistory(value);
                        }
                      },
                    ),
                  ),
                  // Фильтры
                  if (_searchController.text.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildFilterChip('Все'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Песни'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Артисты'),
                          const SizedBox(width: 10),
                          _buildFilterChip('Плейлисты'),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Content
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildDefaultView()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  void _addToHistory(String query) {
    if (!_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      });
    }
  }

  Widget _buildDefaultView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // История поиска
          if (_searchHistory.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Недавние поиски',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEDE3),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _searchHistory.clear();
                          });
                        },
                        child: Text(
                          'Очистить',
                          style: TextStyle(
                            color: Color(0xFFEFEDE3),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _searchHistory.map((query) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.text = query;
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeManager.instance.secondaryBackgroundColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.history,
                                size: 16,
                                color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                query,
                                style: TextStyle(
                                  color: Color(0xFFEFEDE3),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Color(0xFF3D3C37),
              thickness: 1,
              height: 32,
            ),
          ],
          // Популярные запросы
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Популярные запросы',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _popularQueries.map((query) {
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = query;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeManager.instance.secondaryBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 16,
                              color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              query,
                              style: TextStyle(
                                color: Color(0xFFEFEDE3),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF3D3C37),
            thickness: 1,
            height: 32,
          ),
          // Коллекции
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Обзор по жанрам',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _collections.length,
                  itemBuilder: (context, index) {
                    return _buildCollectionCard(_collections[index], index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeManager.instance.textColor
              : ThemeManager.instance.secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? ThemeManager.instance.textColor
                : ThemeManager.instance.textColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? ThemeManager.instance.backgroundColor
                : ThemeManager.instance.textColor,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionCard(String title, int index) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4A4743),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: ThemeManager.instance.textColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Image placeholder (smaller size)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF5A5753),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  _collectionImages[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.music_note,
                        size: 48,
                        color: ThemeManager.instance.textColor.withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF302F2C).withValues(alpha: 0.5),
                    const Color(0xFF302F2C).withValues(alpha: 0.95),
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Title
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEDE3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _getSearchResults(_searchController.text);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: ThemeManager.instance.textColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено',
              style: TextStyle(
                color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте другой запрос',
              style: TextStyle(
                color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Text(
          'Результаты поиска "${_searchController.text}"',
          style: TextStyle(
            color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...results.map((result) {
          if (result['type'] == 'song') {
            return _buildSongResult(result);
          } else if (result['type'] == 'artist') {
            return _buildArtistResult(result);
          } else if (result['type'] == 'playlist') {
            return _buildPlaylistResult(result);
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildSongResult(Map<String, dynamic> song) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Container(
            color: ThemeManager.instance.secondaryBackgroundColor,
            child: Icon(
              Icons.music_note,
              color: Color(0xFFEFEDE3),
              size: 28,
            ),
          ),
        ),
      ),
      title: Text(
        song['title'] as String,
        style: TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        song['artist'] as String,
        style: TextStyle(
          color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.play_arrow, color: Color(0xFFEFEDE3)),
        onPressed: () {
          final track = _findTrack(
            song['title'] as String,
            song['artist'] as String,
          );
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
      ),
      onTap: () {
        final track = _findTrack(
          song['title'] as String,
          song['artist'] as String,
        );
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
    );
  }

  Widget _buildArtistResult(Map<String, dynamic> artist) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            artist['image'] as String,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: ThemeManager.instance.secondaryBackgroundColor,
                child: Icon(
                  Icons.person,
                  color: Color(0xFFEFEDE3),
                  size: 28,
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        artist['name'] as String,
        style: TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${artist['listeners']} слушателей в месяц',
        style: TextStyle(
          color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Color(0xFFEFEDE3)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistScreen(
              artistName: artist['name'] as String,
              bannerPath: artist['image'] as String,
              avatarPath: artist['image'] as String,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaylistResult(Map<String, dynamic> playlist) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ThemeManager.instance.textColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.asset(
            playlist['image'] as String,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: ThemeManager.instance.secondaryBackgroundColor,
                child: Icon(
                  Icons.playlist_play,
                  color: Color(0xFFEFEDE3),
                  size: 28,
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        playlist['title'] as String,
        style: TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        playlist['description'] as String,
        style: TextStyle(
          color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Color(0xFFEFEDE3)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: playlist['title'] as String,
              description: playlist['description'] as String,
              imagePath: playlist['image'] as String,
              songCount: 25,
            ),
          ),
        );
      },
    );
  }

}
