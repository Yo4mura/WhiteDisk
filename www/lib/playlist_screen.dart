import 'dart:io';
import 'package:flutter/material.dart';
import 'theme_manager.dart';
import 'player_screen.dart';
import 'music_service.dart';
import 'track_model.dart';

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
  
  /// Поиск трека по названию и артисту
  static Track? _findTrack(String title, String artist) {
    final musicService = MusicService();
    try {
      return musicService.tracks.firstWhere(
        (t) => t.title == title && t.artist == artist,
      );
    } catch (e) {
      return null;
    }
  }

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
                          color: ThemeManager.instance.secondaryBackgroundColor,
                          child: Icon(
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
                          color: ThemeManager.instance.secondaryBackgroundColor,
                          child: Icon(
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
      backgroundColor: ThemeManager.instance.backgroundColor,
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
                : ThemeManager.instance.backgroundColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: Color(0xFFEFEDE3)),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Color(0xFFEFEDE3)),
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
                                      color: ThemeManager.instance.secondaryBackgroundColor,
                                      child: Icon(
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
                                      color: ThemeManager.instance.secondaryBackgroundColor,
                                      child: Icon(
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
                      style: TextStyle(
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
                      color: ThemeManager.instance.textColor.withValues(alpha: 0.7),
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
                      color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
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
                          icon: Icon(Icons.play_arrow, size: 28),
                          label: Text(
                            'Слушать',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeManager.instance.textColor,
                            foregroundColor: ThemeManager.instance.backgroundColor,
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
                            color: ThemeManager.instance.textColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.shuffle, color: Color(0xFFEFEDE3)),
                          iconSize: 24,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Like button
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ThemeManager.instance.textColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
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
                  final track = _findTrack(title, artist);
                  if (track != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(track: track),
                      ),
                    );
                  } else {
                    final musicService = MusicService();
                    if (musicService.tracks.isNotEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(track: musicService.tracks.first),
                        ),
                      );
                    }
                  }
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
                    color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
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
                        color: ThemeManager.instance.secondaryBackgroundColor,
                        child: Icon(
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
                      style: TextStyle(
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
                        color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
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
                  color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              // More button
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert,
                  color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
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
