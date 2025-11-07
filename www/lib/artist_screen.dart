import 'package:flutter/material.dart';
import 'player_screen.dart';
import 'playlist_screen.dart';

class ArtistScreen extends StatefulWidget {
  final String artistName;
  final String? bio;
  final String? bannerPath;
  final String? avatarPath;
  final int monthlyListeners;
  final int followers;

  const ArtistScreen({
    super.key,
    required this.artistName,
    this.bio,
    this.bannerPath,
    this.avatarPath,
    this.monthlyListeners = 0,
    this.followers = 0,
  });

  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  bool _isFollowing = false;

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  void _showFullImage(BuildContext context, String? imagePath, String title) {
    if (imagePath == null) return;
    
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEFEDE3),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Image
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 500,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A28),
                        child: const Icon(
                          Icons.broken_image,
                          size: 120,
                          color: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Close hint
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Нажмите, чтобы закрыть',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFEFEDE3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      body: CustomScrollView(
        slivers: [
          // App bar with banner
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: const Color(0xFF171716),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: Color(0xFFEFEDE3)),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Banner image - clickable
                  GestureDetector(
                    onTap: () => _showFullImage(
                      context,
                      widget.bannerPath,
                      'Баннер ${widget.artistName}',
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF2A2A28),
                            const Color(0xFF171716),
                          ],
                        ),
                      ),
                      child: widget.bannerPath != null
                          ? Image.asset(
                              widget.bannerPath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                            )
                          : null,
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFF171716).withValues(alpha: 0.7),
                          const Color(0xFF171716),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Artist info at bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Avatar (optional) - clickable and larger
                          if (widget.avatarPath != null) ...[
                            GestureDetector(
                              onTap: () => _showFullImage(
                                context,
                                widget.avatarPath,
                                widget.artistName,
                              ),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFEFEDE3),
                                    width: 4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 25,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    widget.avatarPath!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: const Color(0xFF3D3C38),
                                        child: const Icon(
                                          Icons.person,
                                          size: 60,
                                          color: Colors.white54,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          // Artist name
                          Text(
                            widget.artistName,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFEFEDE3),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Stats
                          Text(
                            '${_formatNumber(widget.monthlyListeners)} слушателей в месяц',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Play button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFEDE3),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Color(0xFF171716),
                            size: 32,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Shuffle button
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.shuffle,
                            color: Color(0xFFEFEDE3),
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const Spacer(),
                      // Follow button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isFollowing = !_isFollowing;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFollowing
                              ? Colors.transparent
                              : const Color(0xFFEFEDE3),
                          foregroundColor: _isFollowing
                              ? const Color(0xFFEFEDE3)
                              : const Color(0xFF171716),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: _isFollowing
                                  ? const Color(0xFFEFEDE3)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          elevation: _isFollowing ? 0 : 2,
                        ),
                        child: Text(
                          _isFollowing ? 'Подписан' : 'Подписаться',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Bio (if exists)
                if (widget.bio != null && widget.bio!.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.bio!,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                // Popular tracks
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Популярное',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEFEDE3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Top 5 tracks
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return _buildPopularTrack(
                      context,
                      index: index + 1,
                      title: 'Популярный трек ${index + 1}',
                      plays: (5000000 - index * 500000),
                    );
                  },
                ),
                const SizedBox(height: 32),
                // Albums section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Альбомы',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEFEDE3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildAlbumCard(
                          context,
                          title: 'Альбом ${index + 1}',
                          year: '${2024 - index}',
                          imagePath: 'assets/vinyl${(index % 5) + 1}.png',
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                // Singles section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Синглы и EP',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEFEDE3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildAlbumCard(
                          context,
                          title: 'Сингл ${index + 1}',
                          year: '2024',
                          imagePath: 'assets/vinyl${(index % 5) + 1}.png',
                          isSingle: true,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTrack(
    BuildContext context, {
    required int index,
    required String title,
    required int plays,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(
                songTitle: title,
                artist: widget.artistName,
                coverPath: widget.avatarPath ?? 'assets/vinyl1.png',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Index
              SizedBox(
                width: 32,
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              // Cover
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    widget.avatarPath ?? 'assets/vinyl${(index % 5) + 1}.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2A2A28),
                        child: const Icon(
                          Icons.music_note,
                          size: 24,
                          color: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Title and plays
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFEFEDE3),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatNumber(plays)} прослушиваний',
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // More button
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumCard(
    BuildContext context, {
    required String title,
    required String year,
    required String imagePath,
    bool isSingle = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaylistScreen(
              title: title,
              description: 'Альбом артиста ${widget.artistName} • $year',
              imagePath: imagePath,
              songCount: isSingle ? 1 : 12,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album cover
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFEFEDE3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF2A2A28),
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
            const SizedBox(height: 12),
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEFEDE3),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Year and type
            Text(
              '$year${isSingle ? " • Сингл" : ""}',
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
}

