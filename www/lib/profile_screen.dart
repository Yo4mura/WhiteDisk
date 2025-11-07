import 'package:flutter/material.dart';
import 'playlist_screen.dart';
import 'artist_screen.dart';
import 'player_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTab = 'Плейлисты';
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'author': 'reiik0',
      'text': 'найс треки',
    },
    {
      'id': '2',
      'author': 'alkun_music',
      'text': 'Отличный вкус!',
    },
    {
      'id': '3',
      'author': 'yoshimura_fan',
      'text': 'Классная коллекция',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      _comments.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'author': 'Yoshimura',
        'text': _commentController.text.trim(),
      });
    });
    _commentController.clear();
  }

  void _deleteComment(String commentId) {
    setState(() {
      _comments.removeWhere((comment) => comment['id'] == commentId);
    });
  }

  void _showCommentMenu(BuildContext context, String commentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                'Удалить комментарий',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _deleteComment(commentId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Color(0xFFEFEDE3)),
              title: const Text(
                'Отмена',
                style: TextStyle(color: Color(0xFFEFEDE3)),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Container(
            height: 180,
            width: double.infinity,
            color: const Color(0xFF2A2A28),
            child: Image.asset(
              'assets/vinyl2.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox();
              },
            ),
          ),
          // Header: avatar, name, handle, stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEFEDE3),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/vinyl1.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: const Color(0xFF3D3C38));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Yoshimura',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '@yos',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB8B6B0),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '2 подписчика  •  30 подписок',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFEFEDE3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Settings button on own profile
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings, color: Color(0xFFEFEDE3)),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: const Text(
                    'I am so interesting',
                    style: TextStyle(fontSize: 14, color: Color(0xFFEFEDE3)),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEDE3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow, size: 14, color: Colors.black),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'Reset - Plastic tree',
                          style: const TextStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _ProfileTab(
                  label: 'Плейлисты',
                  selected: _selectedTab == 'Плейлисты',
                  onTap: () => setState(() => _selectedTab = 'Плейлисты'),
                ),
                const SizedBox(width: 16),
                _ProfileTab(
                  label: 'Песни',
                  selected: _selectedTab == 'Песни',
                  onTap: () => setState(() => _selectedTab = 'Песни'),
                ),
                const SizedBox(width: 16),
                _ProfileTab(
                  label: 'Лайки',
                  selected: _selectedTab == 'Лайки',
                  onTap: () => setState(() => _selectedTab = 'Лайки'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFF3D3C38), height: 1),
          const SizedBox(height: 12),
          // Content based on selected tab
          _buildTabContent(),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Любимые артисты',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEFEDE3),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildArtist(context, 'shibob', 'assets/vinyl3.png'),
                const SizedBox(width: 12),
                _buildArtist(context, 'Yoshimura', 'assets/vinyl4.png'),
                const SizedBox(width: 12),
                _buildArtist(context, 'ALKUN', 'assets/vinyl5.png'),
                const SizedBox(width: 12),
                _buildArtist(context, 'CUPSIZE', 'assets/vinyl1.png'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Color(0xFF3D3C38), height: 1),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Комментарии ${_comments.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Add comment input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1C),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _commentController,
                      style: const TextStyle(color: Color(0xFFEFEDE3)),
                      decoration: InputDecoration(
                        hintText: 'Добавить комментарий...',
                        hintStyle: TextStyle(
                          color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send, color: Color(0xFFEFEDE3)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Comments list
          ..._comments.map((comment) => _buildCommentItem(comment)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Плейлисты':
        return SizedBox(
          height: 167,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: const [
              _PlaylistTile(title: 'самое круто на..', imagePath: 'assets/vinyl1.png'),
              SizedBox(width: 12),
              _PlaylistTile(title: 'самое круто на..', imagePath: 'assets/vinyl2.png'),
              SizedBox(width: 12),
              _PlaylistTile(title: 'самое круто на..', imagePath: 'assets/vinyl3.png'),
            ],
          ),
        );
      case 'Песни':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildSongItem('Mad Boy', 'ALKUN & AI', 'assets/vinyl1.png'),
              const SizedBox(height: 12),
              _buildSongItem('Tokyo Drift', 'Yoshimura', 'assets/vinyl2.png'),
              const SizedBox(height: 12),
              _buildSongItem('Night Drive', 'CUPSIZE', 'assets/vinyl3.png'),
              const SizedBox(height: 12),
              _buildSongItem('Sunset Boulevard', 'ALKUN', 'assets/vinyl4.png'),
            ],
          ),
        );
      case 'Лайки':
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildSongItem('Reset - Plastic tree', 'shibob', 'assets/vinyl1.png'),
              const SizedBox(height: 12),
              _buildSongItem('Neon Lights', 'Yoshimura', 'assets/vinyl2.png'),
              const SizedBox(height: 12),
              _buildSongItem('City Lights', 'ALKUN', 'assets/vinyl3.png'),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildSongItem(String title, String artist, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              songTitle: title,
              artist: artist,
              coverPath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1C),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                color: const Color(0xFF3D3C38),
                child: Image.asset(
                  imagePath,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                    artist,
                    style: TextStyle(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_arrow, color: Color(0xFFEFEDE3)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF3D3C38),
                child: Icon(Icons.person, color: Color(0xFFEFEDE3)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['author'] as String,
                      style: const TextStyle(
                        color: Color(0xFFEFEDE3),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment['text'] as String,
                      style: TextStyle(
                        color: const Color(0xFFB8B6B0).withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  _showCommentMenu(context, comment['id'] as String);
                },
                icon: const Icon(Icons.more_vert, color: Color(0xFFEFEDE3), size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtist(BuildContext context, String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistScreen(
              artistName: name,
              bio: 'Один из ваших любимых артистов',
              bannerPath: imagePath,
              avatarPath: imagePath,
              monthlyListeners: 3500000,
              followers: 1200000,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFEFEDE3), width: 2),
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
                      size: 30,
                      color: Colors.white54,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFFEFEDE3).withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ProfileTab({
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected ? const Color(0xFFEFEDE3) : const Color(0xFFB8B6B0),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: selected ? 36 : 0,
            height: 3,
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFEFEDE3) : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  final String title;
  final String imagePath;

  const _PlaylistTile({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: title,
              description: 'Личный плейлист пользователя',
              imagePath: imagePath,
              songCount: 12,
            ),
          ),
        );
      },
      child: SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFEFEDE3).withValues(alpha: 0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      ),
    );
  }
}


