import 'package:flutter/material.dart';
import 'playlist_screen.dart';
import 'artist_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final String username;
  final String? displayName;
  final String? bio;
  final int followers;
  final int following;

  const UserProfileScreen({
    super.key,
    required this.username,
    this.displayName,
    this.bio,
    this.followers = 0,
    this.following = 0,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isFollowing = false;
  late final String _displayName;
  late final String _username;

  @override
  void initState() {
    super.initState();
    _displayName = widget.displayName ?? widget.username;
    _username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171716),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _displayName,
          style: const TextStyle(color: Color(0xFFEFEDE3)),
        ),
      ),
      body: SingleChildScrollView(
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
                    offset: const Offset(0, -36),
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _displayName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFEFEDE3),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '@$_username',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFB8B6B0),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${widget.followers} подписчика  •  ${widget.following} подписок',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFEFEDE3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Subscribe button
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isFollowing = !_isFollowing;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFollowing
                                ? const Color(0xFF2A2A28)
                                : const Color(0xFFEFEDE3),
                            foregroundColor: _isFollowing
                                ? const Color(0xFFEFEDE3)
                                : const Color(0xFF171716),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: _isFollowing
                                    ? const Color(0xFFEFEDE3)
                                    : Colors.transparent,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            _isFollowing ? 'Отписаться' : 'Подписаться',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.bio != null && widget.bio!.isNotEmpty) ...[
                    Transform.translate(
                      offset: const Offset(0, -36),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: Text(
                          widget.bio!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFEFEDE3),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _ProfileTab(label: 'Плейлисты', selected: true),
                  SizedBox(width: 16),
                  _ProfileTab(label: 'Песни'),
                  SizedBox(width: 16),
                  _ProfileTab(label: 'Лайки'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Color(0xFF3D3C38), height: 1),
            const SizedBox(height: 12),
            // Playlists - horizontal scroll
            SizedBox(
              height: 167,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: const [
                  _PlaylistTile(
                    title: 'самое круто на..',
                    imagePath: 'assets/vinyl1.png',
                  ),
                  SizedBox(width: 12),
                  _PlaylistTile(
                    title: 'самое круто на..',
                    imagePath: 'assets/vinyl2.png',
                  ),
                  SizedBox(width: 12),
                  _PlaylistTile(
                    title: 'самое круто на..',
                    imagePath: 'assets/vinyl3.png',
                  ),
                ],
              ),
            ),
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
            const SizedBox(height: 24),
          ],
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
              bio: 'Любимый артист пользователя',
              bannerPath: imagePath,
              avatarPath: imagePath,
              monthlyListeners: 2900000,
              followers: 950000,
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

  const _ProfileTab({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFFEFEDE3),
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
              description: 'Плейлист пользователя',
              imagePath: imagePath,
              songCount: 10,
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

