import 'package:flutter/material.dart';
import 'player_screen.dart';

class SongsScreen extends StatefulWidget {
  final String playlistTitle;
  final List<SongData> songs;

  const SongsScreen({
    super.key,
    required this.playlistTitle,
    required this.songs,
  });

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSortMenu = false;
  String _sortBy = 'Дата добавления';

  final List<String> _sortOptions = [
    'Дата добавления',
    'Недавно добавленные',
    'Артист',
    'По алфавиту',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171716),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFEFEDE3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.playlistTitle,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEFEDE3),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D3B37),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Color(0xFFEFEDE3), fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Поиск',
                            hintStyle: TextStyle(
                              color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 18,
                              color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onChanged: (value) => setState(() {}),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow, size: 16),
                              label: const Text(
                                'Играть',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEFEDE3),
                                foregroundColor: const Color(0xFF302F2C),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.shuffle, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF3D3B37),
                              foregroundColor: const Color(0xFFEFEDE3),
                              padding: const EdgeInsets.all(10),
                              shape: const CircleBorder(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.download, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF3D3B37),
                              foregroundColor: const Color(0xFFEFEDE3),
                              padding: const EdgeInsets.all(10),
                              shape: const CircleBorder(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => setState(() => _showSortMenu = true),
                            icon: const Icon(Icons.tune, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFF3D3B37),
                              foregroundColor: const Color(0xFFEFEDE3),
                              padding: const EdgeInsets.all(10),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Songs List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: widget.songs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final song = widget.songs[index];
                      return _buildSongItem(song);
                    },
                  ),
                ),
              ],
            ),
            // Sort Menu Bottom Sheet
            if (_showSortMenu) _buildSortMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(SongData song) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songTitle: song.title,
              artist: song.artist,
              coverPath: song.coverPath,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            // Cover
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF3D3B37),
                borderRadius: BorderRadius.circular(8),
              ),
              child: song.coverPath != null && song.coverPath!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        song.coverPath!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.music_note,
                              size: 20,
                              color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.music_note,
                        size: 20,
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFEFEDE3),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // More button
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                size: 18,
                color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortMenu() {
    return GestureDetector(
      onTap: () => setState(() => _showSortMenu = false),
      child: Container(
        color: Colors.black.withValues(alpha: 0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {}, // Prevent dismiss when tapping inside
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3D3B37),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Сортировка',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEFEDE3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._sortOptions.map((option) {
                      final isSelected = _sortBy == option;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _sortBy = option;
                            _showSortMenu = false;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFEFEDE3).withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFEFEDE3),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  size: 18,
                                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for songs
class SongData {
  final String title;
  final String artist;
  final String? coverPath;

  SongData({
    required this.title,
    required this.artist,
    this.coverPath,
  });
}

