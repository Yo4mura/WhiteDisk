import 'dart:io';
import 'package:flutter/material.dart';
import 'songs_screen.dart';
import 'playlist_screen.dart';
import 'artist_screen.dart';
import 'player_screen.dart';
import 'create_playlist_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedFilter = 'Все'; // Все, Плейлисты, Артисты, Песни, Альбомы
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Mock data
  final List<Map<String, dynamic>> _playlists = [
    {
      'title': 'Мой плейлист #1',
      'description': 'Лучшие треки',
      'songCount': 15,
      'image': 'assets/vinyl1.png',
    },
    {
      'title': 'Мой плейлист #2',
      'description': 'Для работы',
      'songCount': 23,
      'image': 'assets/vinyl2.png',
    },
    {
      'title': 'Мой плейлист #3',
      'description': 'Чилл виб',
      'songCount': 18,
      'image': 'assets/vinyl3.png',
    },
  ];

  final List<Map<String, dynamic>> _artists = [
    {'name': 'ALKUN', 'listeners': '5.4M', 'image': 'assets/vinyl1.png'},
    {'name': 'Yoshimura', 'listeners': '3.2M', 'image': 'assets/vinyl2.png'},
    {'name': 'CUPSIZE', 'listeners': '2.8M', 'image': 'assets/vinyl3.png'},
    {'name': 'shibob', 'listeners': '1.9M', 'image': 'assets/vinyl4.png'},
  ];

  final List<Map<String, dynamic>> _albums = [
    {
      'title': 'Midnight Sessions',
      'artist': 'ALKUN',
      'year': '2024',
      'image': 'assets/vinyl1.png',
      'songCount': 12,
    },
    {
      'title': 'Urban Dreams',
      'artist': 'Yoshimura',
      'year': '2023',
      'image': 'assets/vinyl2.png',
      'songCount': 10,
    },
    {
      'title': 'City Lights',
      'artist': 'CUPSIZE',
      'year': '2024',
      'image': 'assets/vinyl3.png',
      'songCount': 14,
    },
    {
      'title': 'Neon Nights',
      'artist': 'shibob',
      'year': '2023',
      'image': 'assets/vinyl4.png',
      'songCount': 11,
    },
  ];

  final List<Map<String, dynamic>> _recentItems = [
    {
      'title': 'Mad Boy',
      'artist': 'ALKUN & AI',
      'type': 'song',
      'image': 'assets/vinyl1.png',
    },
    {
      'title': 'Tokyo Drift',
      'artist': 'Yoshimura',
      'type': 'album',
      'image': 'assets/vinyl2.png',
    },
    {
      'title': 'Daily Mix 1',
      'artist': 'Плейлист',
      'type': 'playlist',
      'image': 'assets/vinyl3.png',
    },
    {
      'title': 'Night Drive',
      'artist': 'CUPSIZE',
      'type': 'song',
      'image': 'assets/vinyl4.png',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredItems() {
    final query = _searchController.text.toLowerCase();
    List<Map<String, dynamic>> items = [];

    if (_selectedFilter == 'Все' || _selectedFilter == 'Плейлисты') {
      final filtered = _playlists.where((p) {
        return p['title'].toString().toLowerCase().contains(query) ||
            p['description'].toString().toLowerCase().contains(query);
      }).toList();
      items.addAll(filtered.map((p) => {...p, 'type': 'playlist'}));
    }

    if (_selectedFilter == 'Все' || _selectedFilter == 'Артисты') {
      final filtered = _artists.where((a) {
        return a['name'].toString().toLowerCase().contains(query);
      }).toList();
      items.addAll(filtered.map((a) => {...a, 'type': 'artist'}));
    }

    if (_selectedFilter == 'Все' || _selectedFilter == 'Песни') {
      final filtered = _getFavoriteSongs().where((s) {
        return s.title.toLowerCase().contains(query) ||
            s.artist.toLowerCase().contains(query);
      }).toList();
      items.addAll(
        filtered.map(
          (s) => <String, dynamic>{
            'title': s.title,
            'artist': s.artist,
            'coverPath': s.coverPath,
            'type': 'song',
          },
        ),
      );
    }

    if (_selectedFilter == 'Все' || _selectedFilter == 'Альбомы') {
      final filtered = _albums.where((a) {
        return a['title'].toString().toLowerCase().contains(query) ||
            a['artist'].toString().toLowerCase().contains(query);
      }).toList();
      items.addAll(filtered.map((a) => {...a, 'type': 'album'}));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      body: SafeArea(
        child: Column(
          children: [
            // Header with search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Медиатека',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEDE3),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isSearching ? Icons.close : Icons.search,
                          color: const Color(0xFFEFEDE3),
                        ),
                        onPressed: () {
                          setState(() {
                            _isSearching = !_isSearching;
                            if (!_isSearching) {
                              _searchController.clear();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  if (_isSearching) ...[
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3D3B37),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Color(0xFFEFEDE3)),
                        decoration: InputDecoration(
                          hintText: 'Поиск в медиатеке...',
                          hintStyle: TextStyle(
                            color: const Color(
                              0xFFEFEDE3,
                            ).withValues(alpha: 0.6),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFEFEDE3),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                  ],
                  // Filter chips row
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _FilterChip(
                          label: 'Все',
                          selected: _selectedFilter == 'Все',
                          onTap: () => setState(() => _selectedFilter = 'Все'),
                        ),
                        const SizedBox(width: 10),
                        _FilterChip(
                          label: 'Плейлисты',
                          selected: _selectedFilter == 'Плейлисты',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Плейлисты'),
                        ),
                        const SizedBox(width: 10),
                        _FilterChip(
                          label: 'Артисты',
                          selected: _selectedFilter == 'Артисты',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Артисты'),
                        ),
                        const SizedBox(width: 10),
                        _FilterChip(
                          label: 'Песни',
                          selected: _selectedFilter == 'Песни',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Песни'),
                        ),
                        const SizedBox(width: 10),
                        _FilterChip(
                          label: 'Альбомы',
                          selected: _selectedFilter == 'Альбомы',
                          onTap: () =>
                              setState(() => _selectedFilter = 'Альбомы'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content based on filter
            Expanded(child: _buildContent()),
          ],
        ),
      ),
      floatingActionButton: _selectedFilter == 'Плейлисты'
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreatePlaylistScreen(),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _playlists.add(result as Map<String, dynamic>);
                  });
                }
              },
              backgroundColor: const Color(0xFFEFEDE3),
              child: const Icon(Icons.add, color: Color(0xFF171716)),
            )
          : null,
    );
  }

  Widget _buildContent() {
    if (_isSearching && _searchController.text.isNotEmpty) {
      return _buildSearchResults();
    }

    if (_selectedFilter == 'Плейлисты') {
      return _buildPlaylistsView();
    } else if (_selectedFilter == 'Артисты') {
      return _buildArtistsView();
    } else if (_selectedFilter == 'Песни') {
      return _buildSongsView();
    } else if (_selectedFilter == 'Альбомы') {
      return _buildAlbumsView();
    } else {
      return _buildAllView();
    }
  }

  Widget _buildAllView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Любимые песни
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SongsScreen(
                      playlistTitle: 'Любимые песни',
                      songs: _getFavoriteSongs(),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/vinyl1.png',
                          fit: BoxFit.cover,
                          color: const Color(0xFF000000).withOpacity(0.25),
                          colorBlendMode: BlendMode.darken,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        Icons.edit,
                        color: const Color(0xFFEFEDE3),
                        size: 20,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          height: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFEDE3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFEFEDE3),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDAD6CC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFBFBBAF),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Плейлист',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Любимые песни',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '227 песен',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 56,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDAD6CC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFBFBBAF),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Статистика
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatCard('${_playlists.length}', 'Плейлистов'),
                const SizedBox(width: 12),
                _buildStatCard('${_artists.length}', 'Артистов'),
                const SizedBox(width: 12),
                _buildStatCard('${_getFavoriteSongs().length}', 'Песен'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Плейлисты
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ваши Плейлисты',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _selectedFilter = 'Плейлисты'),
                  child: const Text(
                    'Все',
                    style: TextStyle(color: Color(0xFFEFEDE3)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (_, i) => _PlaylistRow(playlist: _playlists[i]),
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemCount: _playlists.length > 3 ? 3 : _playlists.length,
          ),
          const SizedBox(height: 24),
          // Артисты
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ваши Артисты',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedFilter = 'Артисты'),
                  child: const Text(
                    'Все',
                    style: TextStyle(color: Color(0xFFEFEDE3)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _artists.take(5).map((artist) {
                return Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: _buildArtistCard(artist, isCompact: true),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Недавно добавленные
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Недавно добавленные',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEDE3),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 225,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _recentItems.take(4).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildRecentItem(item),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Недавно прослушано
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Недавно прослушано',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEDE3),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 225,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _recentItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildRecentItem(item),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Альбомы
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Альбомы',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => _selectedFilter = 'Альбомы'),
                  child: const Text(
                    'Все',
                    style: TextStyle(color: Color(0xFFEFEDE3)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _albums.take(4).map((album) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildAlbumCard(album),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlaylistsView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Плейлисты (${_playlists.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEDE3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._playlists.map((playlist) => _PlaylistRow(playlist: playlist)),
      ],
    );
  }

  Widget _buildArtistsView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Артисты (${_artists.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEFEDE3),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort, color: Color(0xFFEFEDE3)),
                color: const Color(0xFF1C1C1C),
                onSelected: (value) {
                  // TODO: Implement sorting
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Имя',
                    child: Text(
                      'По имени',
                      style: TextStyle(color: Color(0xFFEFEDE3)),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Недавно добавленные',
                    child: Text(
                      'Недавно добавленные',
                      style: TextStyle(color: Color(0xFFEFEDE3)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: _artists.length,
            itemBuilder: (context, index) =>
                _buildArtistCard(_artists[index], isCompact: false),
          ),
        ),
      ],
    );
  }

  Widget _buildSongsView() {
    final songs = _getFavoriteSongs();
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Песни (${songs.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEDE3),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort, color: Color(0xFFEFEDE3)),
              color: const Color(0xFF1C1C1C),
              onSelected: (value) {
                // TODO: Implement sorting
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'Имя',
                  child: Text(
                    'По имени',
                    style: TextStyle(color: Color(0xFFEFEDE3)),
                  ),
                ),
                const PopupMenuItem(
                  value: 'Недавно добавленные',
                  child: Text(
                    'Недавно добавленные',
                    style: TextStyle(color: Color(0xFFEFEDE3)),
                  ),
                ),
                const PopupMenuItem(
                  value: 'Дата прослушивания',
                  child: Text(
                    'По дате прослушивания',
                    style: TextStyle(color: Color(0xFFEFEDE3)),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...songs.map((song) => _buildSongItem(song)),
      ],
    );
  }

  Widget _buildAlbumsView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Альбомы (${_albums.length})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEFEDE3),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort, color: Color(0xFFEFEDE3)),
                color: const Color(0xFF1C1C1C),
                onSelected: (value) {
                  // TODO: Implement sorting
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'Имя',
                    child: Text(
                      'По имени',
                      style: TextStyle(color: Color(0xFFEFEDE3)),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Недавно добавленные',
                    child: Text(
                      'Недавно добавленные',
                      style: TextStyle(color: Color(0xFFEFEDE3)),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'Дата прослушивания',
                    child: Text(
                      'По дате прослушивания',
                      style: TextStyle(color: Color(0xFFEFEDE3)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.66,
            ),
            itemCount: _albums.length,
            itemBuilder: (context, index) =>
                _buildAlbumCard(_albums[index], isGrid: true),
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumCard(Map<String, dynamic> album, {bool isGrid = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: album['title'] as String,
              description: '${album['artist']} • ${album['year']}',
              imagePath: album['image'] as String,
              songCount: album['songCount'] as int,
            ),
          ),
        );
      },
      child: Container(
        width: isGrid ? double.infinity : 140,
        height: isGrid ? null : 310,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: isGrid ? null : 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: isGrid
                    ? AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          album['image'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF2A2A28),
                              child: const Icon(
                                Icons.album,
                                color: Color(0xFFEFEDE3),
                                size: 60,
                              ),
                            );
                          },
                        ),
                      )
                    : Image.asset(
                        album['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF2A2A28),
                            child: const Icon(
                              Icons.album,
                              color: Color(0xFFEFEDE3),
                              size: 60,
                            ),
                          );
                        },
                      ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: isGrid ? 10 : 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      album['title'] as String,
                      style: const TextStyle(
                        color: Color(0xFFEFEDE3),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      album['artist'] as String,
                      style: TextStyle(
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isGrid) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${album['year']} • ${album['songCount']} треков',
                        style: TextStyle(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    final items = _getFilteredItems();
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Ничего не найдено',
              style: TextStyle(
                color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: items.map((item) {
        if (item['type'] == 'playlist') {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PlaylistRow(playlist: item),
          );
        } else if (item['type'] == 'artist') {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildArtistListItem(item),
          );
        } else if (item['type'] == 'song') {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildSongListItem(item),
          );
        } else if (item['type'] == 'album') {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAlbumListItem(item),
          );
        }
        return const SizedBox();
      }).toList(),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEFEDE3),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistCard(
    Map<String, dynamic> artist, {
    required bool isCompact,
  }) {
    if (isCompact) {
      return GestureDetector(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  artist['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2A2A28),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFEFEDE3),
                        size: 60,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 120,
              child: Text(
                artist['name'] as String,
                style: const TextStyle(
                  color: Color(0xFFEFEDE3),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
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
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    artist['image'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A28),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFFEFEDE3),
                          size: 60,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist['name'] as String,
                    style: const TextStyle(
                      color: Color(0xFFEFEDE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${artist['listeners']} слушателей',
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
      ),
    );
  }

  Widget _buildRecentItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        if (item['type'] == 'song') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                songTitle: item['title'] as String,
                artist: item['artist'] as String,
                coverPath: item['image'] as String,
              ),
            ),
          );
        } else if (item['type'] == 'playlist') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlaylistScreen(
                title: item['title'] as String,
                description: item['artist'] as String,
                imagePath: item['image'] as String,
                songCount: 25,
              ),
            ),
          );
        }
      },
      child: Container(
        width: 140,
        height: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  item['image'] as String,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2A2A28),
                      child: Icon(
                        item['type'] == 'song'
                            ? Icons.music_note
                            : Icons.playlist_play,
                        color: const Color(0xFFEFEDE3),
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: Color(0xFFEFEDE3),
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Text(
                        item['artist'] as String,
                        style: TextStyle(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(SongData song) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: song.coverPath != null
              ? Image.asset(
                  song.coverPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2A2A28),
                      child: const Icon(
                        Icons.music_note,
                        color: Color(0xFFEFEDE3),
                      ),
                    );
                  },
                )
              : Container(
                  color: const Color(0xFF2A2A28),
                  child: const Icon(Icons.music_note, color: Color(0xFFEFEDE3)),
                ),
        ),
      ),
      title: Text(
        song.title,
        style: const TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        song.artist,
        style: TextStyle(
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow, color: Color(0xFFEFEDE3)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                songTitle: song.title,
                artist: song.artist,
                coverPath: song.coverPath ?? 'assets/vinyl1.png',
              ),
            ),
          );
        },
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songTitle: song.title,
              artist: song.artist,
              coverPath: song.coverPath ?? 'assets/vinyl1.png',
            ),
          ),
        );
      },
    );
  }

  Widget _buildSongListItem(Map<String, dynamic> song) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Container(
            color: const Color(0xFF2A2A28),
            child: const Icon(Icons.music_note, color: Color(0xFFEFEDE3)),
          ),
        ),
      ),
      title: Text(
        song['title'] as String,
        style: const TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        song['artist'] as String,
        style: TextStyle(
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFEFEDE3)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songTitle: song['title'] as String,
              artist: song['artist'] as String,
              coverPath: song['coverPath'] ?? 'assets/vinyl1.png',
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtistListItem(Map<String, dynamic> artist) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipOval(
          child: Image.asset(
            artist['image'] as String,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF2A2A28),
                child: const Icon(Icons.person, color: Color(0xFFEFEDE3)),
              );
            },
          ),
        ),
      ),
      title: Text(
        artist['name'] as String,
        style: const TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${artist['listeners']} слушателей',
        style: TextStyle(
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFEFEDE3)),
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

  Widget _buildAlbumListItem(Map<String, dynamic> album) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Image.asset(
            album['image'] as String,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFF2A2A28),
                child: const Icon(Icons.album, color: Color(0xFFEFEDE3)),
              );
            },
          ),
        ),
      ),
      title: Text(
        album['title'] as String,
        style: const TextStyle(
          color: Color(0xFFEFEDE3),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${album['artist']} • ${album['year']}',
        style: TextStyle(
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFEFEDE3)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: album['title'] as String,
              description: '${album['artist']} • ${album['year']}',
              imagePath: album['image'] as String,
              songCount: album['songCount'] as int,
            ),
          ),
        );
      },
    );
  }

  // Helper method to get favorite songs list
  List<SongData> _getFavoriteSongs() {
    return [
      SongData(
        title: 'Mad Boy',
        artist: 'ALKUN & AI',
        coverPath: 'assets/vinyl1.png',
      ),
      SongData(
        title: 'Reset - Plastic tree',
        artist: 'shibob',
        coverPath: null,
      ),
      SongData(title: 'Neon Lights', artist: 'Yoshimura', coverPath: null),
      SongData(
        title: 'Tokyo Drift',
        artist: 'shit, денди, Amorbius',
        coverPath: null,
      ),
      SongData(title: 'Moonlight', artist: 'aishi', coverPath: null),
      SongData(title: 'Summer Vibes', artist: 'Kireko', coverPath: null),
      SongData(title: 'Night Drive', artist: 'shibob', coverPath: null),
      SongData(title: 'City Lights', artist: 'ALKUN', coverPath: null),
      SongData(title: 'Rain Dance', artist: 'Yoshimura', coverPath: null),
      SongData(title: 'Electric Dreams', artist: 'AI', coverPath: null),
      SongData(title: 'Sunset Boulevard', artist: 'денди', coverPath: null),
      SongData(title: 'Starlight', artist: 'Amorbius', coverPath: null),
      SongData(title: 'Ocean Waves', artist: 'aishi', coverPath: null),
      SongData(title: 'Mountain Echo', artist: 'Kireko', coverPath: null),
      SongData(title: 'Urban Jungle', artist: 'shibob', coverPath: null),
    ];
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFEDE3) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : const Color(0xFFEFEDE3),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _PlaylistRow extends StatelessWidget {
  final Map<String, dynamic> playlist;
  const _PlaylistRow({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: playlist['title'] as String,
              description: playlist['description'] as String,
              imagePath: playlist['image'] as String,
              songCount: playlist['songCount'] as int,
              isFromGallery: playlist['isFromGallery'] as bool? ?? false,
              backgroundImagePath: playlist['backgroundImage'] as String?,
              isBackgroundFromGallery: playlist['isBackgroundFromGallery'] as bool? ?? false,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildPlaylistImage(playlist['image'] as String, playlist['isFromGallery'] as bool? ?? false),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist['title'] as String,
                    style: const TextStyle(
                      color: Color(0xFFEFEDE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist['songCount']} треков',
                    style: const TextStyle(
                      color: Color(0xFFB8B6B0),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow, color: Color(0xFFEFEDE3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistImage(String imagePath, bool isFromGallery) {
    if (isFromGallery) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF3D3C38),
            child: const Icon(
              Icons.playlist_play,
              size: 40,
              color: Colors.white54,
            ),
          );
        },
      );
    } else {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF3D3C38),
            child: const Icon(
              Icons.playlist_play,
              size: 40,
              color: Colors.white54,
            ),
          );
        },
      );
    }
  }
}
