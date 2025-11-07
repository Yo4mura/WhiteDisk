import 'dart:io';
import 'package:flutter/material.dart';
import 'player_screen.dart';

class PlaylistScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final int songCount;
  final bool isFromGallery;
  final String? backgroundImagePath;
  final bool isBackgroundFromGallery;

  const PlaylistScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.songCount = 10,
    this.isFromGallery = false,
    this.backgroundImagePath,
    this.isBackgroundFromGallery = false,
  });

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 500,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isFromGallery
                  ? Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2A28),
                          child: const Icon(
                            Icons.album,
                            size: 120,
                            color: Colors.white54,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2A28),
                          child: const Icon(
                            Icons.album,
                            size: 120,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      body: Stack(
        children: [
          // Фон плейлиста на весь экран
          if (backgroundImagePath != null)
            Positioned.fill(
              child: isBackgroundFromGallery
                  ? Image.file(
                      File(backgroundImagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox();
                      },
                    )
                  : Image.asset(
                      backgroundImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox();
                      },
                    ),
            ),
          // Контент поверх фона
          CustomScrollView(
        slivers: [
          // App bar with cover
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: backgroundImagePath != null
                ? Colors.transparent
                : const Color(0xFF171716),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Color(0xFFEFEDE3)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Color(0xFFEFEDE3)),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Градиент для читаемости текста
                  if (backgroundImagePath != null)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Cover image - clickable
                  GestureDetector(
                    onTap: () => _showFullImage(context),
                    child: Hero(
                      tag: 'playlist_cover_$title',
                      child: Container(
                        width: 240,
                        height: 240,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isFromGallery
                              ? Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF2A2A28),
                                      child: const Icon(
                                        Icons.album,
                                        size: 80,
                                        color: Colors.white54,
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: const Color(0xFF2A2A28),
                                      child: const Icon(
                                        Icons.album,
                                        size: 80,
                                        color: Colors.white54,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEFEDE3),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: backgroundImagePath != null
                  ? BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    )
                  : null,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Description
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.7),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // Song count
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '$songCount треков',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      // Play button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow, size: 28),
                          label: const Text(
                            'Слушать',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEFEDE3),
                            foregroundColor: const Color(0xFF171716),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Shuffle button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.shuffle, color: Color(0xFFEFEDE3)),
                          iconSize: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Like button
                      Container(
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
                            Icons.favorite_border,
                            color: Color(0xFFEFEDE3),
                          ),
                          iconSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
              ),
            ),
          ),
          // Songs list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  decoration: backgroundImagePath != null
                      ? BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                        )
                      : null,
                  child: _buildSongItem(
                    context,
                    index: index + 1,
                    title: 'Название песни ${index + 1}',
                    artist: 'Исполнитель',
                    duration: '3:${(20 + index * 5) % 60}',
                  ),
                );
              },
              childCount: songCount,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(
    BuildContext context, {
    required int index,
    required String title,
    required String artist,
    required String duration,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            children: [
              // Index
              SizedBox(
                width: 24,
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),
              // Cover thumbnail
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
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
              // Title and artist
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
                      artist,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Duration
              Text(
                duration,
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 8),
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
}

