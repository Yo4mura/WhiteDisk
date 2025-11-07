import 'package:flutter/material.dart';
import 'comments_screen.dart';
import 'artist_screen.dart';

class PlayerScreen extends StatelessWidget {
  final String songTitle;
  final String artist;
  final String? coverPath;
  final String currentTime;
  final String totalTime;
  final double progress;

  const PlayerScreen({
    super.key,
    required this.songTitle,
    required this.artist,
    this.coverPath,
    this.currentTime = '2:46',
    this.totalTime = '2:46',
    this.progress = 0.0,
  });

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
      ),
      body: Container(
        color: const Color(0xFF171716),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Album cover - 338x338
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    width: 338,
                    height: 338,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: coverPath != null && coverPath!.isNotEmpty
                            ? Image.asset(
                                coverPath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderCover();
                                },
                              )
                            : _buildPlaceholderCover(),
                      ),
                    ),
                  ),
                ),
              ),
              // Song info and controls
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        // Song title and artist
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    songTitle,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEFEDE3),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ArtistScreen(
                                            artistName: artist,
                                            bio:
                                                'Один из самых популярных артистов современной музыкальной сцены',
                                            bannerPath: coverPath,
                                            avatarPath: coverPath,
                                            monthlyListeners: 5420000,
                                            followers: 1250000,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      artist,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color(
                                          0xFFEFEDE3,
                                        ).withValues(alpha: 0.6),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert,
                                color: Color(0xFFEFEDE3),
                                size: 32,
                              ),
                              iconSize: 32,
                              padding: const EdgeInsets.all(8),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite_border,
                                color: Color(0xFFEFEDE3),
                                size: 32,
                              ),
                              iconSize: 32,
                              padding: const EdgeInsets.all(8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Progress bar
                        Column(
                          children: [
                            Slider(
                              value: progress,
                              onChanged: (value) {},
                              activeColor: const Color(0xFFEFEDE3),
                              inactiveColor: const Color(
                                0xFFEFEDE3,
                              ).withValues(alpha: 0.3),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    currentTime,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color(
                                        0xFFEFEDE3,
                                      ).withValues(alpha: 0.6),
                                    ),
                                  ),
                                  Text(
                                    totalTime,
                                    style: TextStyle(
                                      fontSize: 12,
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
                        const SizedBox(height: 16),
                        // Playback controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.skip_previous,
                                color: Color(0xFFEFEDE3),
                                size: 56,
                              ),
                              iconSize: 56,
                              padding: const EdgeInsets.all(20),
                            ),
                            const SizedBox(width: 32),
                            // Play button with rounded triangle
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  padding: const EdgeInsets.all(20),
                                  child: CustomPaint(
                                    painter: RoundedTrianglePainter(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 32),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.skip_next,
                                color: Color(0xFFEFEDE3),
                                size: 56,
                              ),
                              iconSize: 56,
                              padding: const EdgeInsets.all(20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Bottom action buttons with labels
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildBottomAction(
                                context,
                                Icons.music_note,
                                'Текст',
                              ),
                              const SizedBox(width: 16),
                              _buildBottomAction(
                                context,
                                Icons.chat_bubble_outline,
                                'Комментарии',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CommentsScreen(
                                        songTitle: songTitle,
                                        artist: artist,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 16),
                              _buildBottomAction(
                                context,
                                Icons.queue_music,
                                'Очередь',
                              ),
                              const SizedBox(width: 16),
                              _buildBottomAction(
                                context,
                                Icons.access_time,
                                'Таймер',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3D3B37),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          size: 80,
          color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildBottomAction(
    BuildContext context,
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap ?? () {},
          icon: Icon(icon, color: const Color(0xFFEFEDE3), size: 32),
          iconSize: 32,
          padding: const EdgeInsets.all(12),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

// Custom painter for rounded triangle (play button)
class RoundedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEFEDE3)
      ..style = PaintingStyle.fill;

    final path = Path();
    final radius = 6.0; // Rounded corner radius
    final width = size.width;
    final height = size.height;

    // Triangle points (pointing right)
    final leftTop = Offset(0, 0);
    final leftBottom = Offset(0, height);
    final rightTip = Offset(width, height / 2);

    // Create rounded triangle path
    // Start from top-left with rounded corner
    path.moveTo(leftTop.dx + radius, leftTop.dy);

    // Line towards tip, but stop before reaching it
    final tipTop = Offset(
      rightTip.dx - radius * 0.8,
      rightTip.dy - radius * 0.6,
    );
    path.lineTo(tipTop.dx, tipTop.dy);

    // Rounded corner at top of tip
    path.quadraticBezierTo(
      rightTip.dx,
      rightTip.dy - radius,
      rightTip.dx,
      rightTip.dy,
    );

    // Rounded corner at bottom of tip
    path.quadraticBezierTo(
      rightTip.dx,
      rightTip.dy + radius,
      tipTop.dx,
      rightTip.dy + radius * 0.6,
    );

    // Line to bottom-left
    path.lineTo(leftBottom.dx + radius, leftBottom.dy);

    // Rounded corner at bottom-left
    path.quadraticBezierTo(
      leftBottom.dx,
      leftBottom.dy,
      leftBottom.dx,
      leftBottom.dy - radius,
    );

    // Line back to top-left
    path.lineTo(leftTop.dx, leftTop.dy + radius);

    // Rounded corner at top-left
    path.quadraticBezierTo(
      leftTop.dx,
      leftTop.dy,
      leftTop.dx + radius,
      leftTop.dy,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
