import 'dart:async';
import 'package:flutter/material.dart';
import 'theme_manager.dart';
import 'artist_screen.dart';
import 'music_service.dart';
import 'track_model.dart';
import 'queue_screen.dart';

class PlayerScreen extends StatefulWidget {
  final Track? track;

  const PlayerScreen({super.key, this.track});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final MusicService _musicService = MusicService();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    // Если передан трек, запускаем его
    if (widget.track != null) {
      _musicService.playTrack(widget.track!);
    }

    // Слушаем изменения состояния через периодический стрим
    _subscription = Stream.periodic(const Duration(milliseconds: 100)).listen((
      _,
    ) {
      if (mounted) {
        setState(() {});
      }
    });

    // Также слушаем изменения через ChangeNotifier
    _musicService.addListener(_onMusicServiceChanged);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _musicService.removeListener(_onMusicServiceChanged);
    super.dispose();
  }

  void _onMusicServiceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.instance;
    final currentTrack = _musicService.currentTrack;
    final isPlaying = _musicService.isPlaying;
    final isLoading = _musicService.isLoading;
    final position = _musicService.position;
    final duration = _musicService.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    if (currentTrack == null) {
      return Scaffold(
        backgroundColor: themeManager.backgroundColor,
        appBar: AppBar(
          backgroundColor: themeManager.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'Нет активного трека',
            style: TextStyle(color: Color(0xFFEFEDE3)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeManager.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: themeManager.backgroundColor,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              // Album cover - 338x338 с белой обводкой
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: SizedBox(
                        width: 380,
                        height: 380,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: themeManager.textColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: currentTrack.coverPath != null
                                ? Image.asset(
                                    currentTrack.coverPath!,
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
                ),
              ),
              // Song info and controls
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Song title and artist
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentTrack.title,
                                  style: TextStyle(
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
                                          artistName: currentTrack.artist,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    currentTrack.artist,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(
                                        0xFFEFEDE3,
                                      ).withValues(alpha: 0.7),
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
                            icon: Icon(
                              Icons.favorite_border,
                              color: Color(0xFFEFEDE3),
                              size: 32,
                            ),
                            iconSize: 32,
                            padding: EdgeInsets.zero,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.more_vert,
                              color: Color(0xFFEFEDE3),
                              size: 32,
                            ),
                            iconSize: 32,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Progress bar
                      Column(
                        children: [
                          Slider(
                            value: progress.clamp(0.0, 1.0),
                            onChanged: (value) {
                              final newPosition = Duration(
                                milliseconds: (value * duration.inMilliseconds)
                                    .toInt(),
                              );
                              _musicService.seekTo(newPosition);
                            },
                            activeColor: themeManager.textColor,
                            inactiveColor: const Color(
                              0xFFEFEDE3,
                            ).withValues(alpha: 0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(position),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color(
                                      0xFFEFEDE3,
                                    ).withValues(alpha: 0.7),
                                  ),
                                ),
                                Text(
                                  _formatDuration(duration),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color(
                                      0xFFEFEDE3,
                                    ).withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Playback controls with Shuffle and Repeat
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          // Shuffle button
                          IconButton(
                            onPressed: () => _musicService.toggleShuffle(),
                            icon: Icon(
                              Icons.shuffle,
                              color: _musicService.isShuffleEnabled
                                  ? themeManager.textColor
                                  : const Color(
                                      0xFFEFEDE3,
                                    ).withValues(alpha: 0.5),
                              size: 24,
                            ),
                            iconSize: 24,
                            padding: const EdgeInsets.all(4),
                          ),
                          const SizedBox(width: 8),
                          // Previous track
                          IconButton(
                            onPressed: () => _musicService.previousTrack(),
                            icon: Icon(
                              Icons.skip_previous,
                              color: Color(0xFFEFEDE3),
                              size: 48,
                            ),
                            iconSize: 48,
                            padding: const EdgeInsets.all(8),
                          ),
                          const SizedBox(width: 16),
                          // Play button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _musicService.togglePlayPause(),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 100,
                                height: 100,
                                padding: const EdgeInsets.all(20),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFFEFEDE3),
                                            ),
                                      )
                                    : isPlaying
                                    ? Icon(
                                        Icons.pause,
                                        color: Color(0xFFEFEDE3),
                                        size: 70,
                                      )
                                    : Icon(
                                        Icons.play_arrow,
                                        color: Color(0xFFEFEDE3),
                                        size: 65,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Next track
                          IconButton(
                            onPressed: () => _musicService.nextTrack(),
                            icon: Icon(
                              Icons.skip_next,
                              color: Color(0xFFEFEDE3),
                              size: 48,
                            ),
                            iconSize: 48,
                            padding: const EdgeInsets.all(8),
                          ),
                          const SizedBox(width: 8),
                          // Repeat button
                          IconButton(
                            onPressed: () => _musicService.toggleRepeat(),
                            icon: Icon(
                              _musicService.repeatMode == RepeatMode.one
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                              color: _musicService.repeatMode != RepeatMode.off
                                  ? themeManager.textColor
                                  : const Color(
                                      0xFFEFEDE3,
                                    ).withValues(alpha: 0.5),
                              size: 24,
                            ),
                            iconSize: 24,
                            padding: const EdgeInsets.all(4),
                          ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Bottom action buttons (без текста)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const QueueScreen(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.queue_music,
                              color: Color(0xFFEFEDE3),
                              size: 28,
                            ),
                            iconSize: 28,
                            padding: const EdgeInsets.all(8),
                          ),
                        ],
                      ),
                    ],
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
    final themeManager = ThemeManager.instance;
    return Container(
      decoration: BoxDecoration(
        color: themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          size: 80,
          color: themeManager.textColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
