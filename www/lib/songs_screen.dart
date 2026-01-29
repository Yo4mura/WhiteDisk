import 'package:flutter/material.dart';
import 'theme_manager.dart';
import 'player_screen.dart';
import 'music_service.dart';
import 'track_model.dart';

class SongsScreen extends StatefulWidget {
  const SongsScreen({super.key});

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final MusicService _musicService = MusicService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _musicService.addListener(_onMusicServiceChanged);
  }

  @override
  void dispose() {
    _musicService.removeListener(_onMusicServiceChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onMusicServiceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<Track> get _filteredTracks {
    if (_searchQuery.isEmpty) {
      return _musicService.tracks;
    }
    return _musicService.searchTracks(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final tracks = _filteredTracks;

    return Scaffold(
      backgroundColor: ThemeManager.instance.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeManager.instance.backgroundColor,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Color(0xFFEFEDE3)),
          decoration: InputDecoration(
            hintText: 'Поиск песен...',
            hintStyle: TextStyle(
              color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: ThemeManager.instance.textColor.withValues(alpha: 0.7),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: ThemeManager.instance.textColor.withValues(alpha: 0.7),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
      body: tracks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_off,
                    size: 64,
                    color: ThemeManager.instance.textColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Нет загруженных треков'
                        : 'Ничего не найдено',
                    style: TextStyle(
                      color: ThemeManager.instance.textColor.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                final isCurrentTrack = _musicService.currentTrack?.id == track.id;
                final isPlaying = isCurrentTrack && _musicService.isPlaying;

                return _buildSongItem(track, index + 1, isCurrentTrack, isPlaying);
              },
            ),
    );
  }

  Widget _buildSongItem(
    Track track,
    int index,
    bool isCurrentTrack,
    bool isPlaying,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PlayerScreen(track: track),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Row(
            children: [
              // Track number or playing indicator
              SizedBox(
                width: 32,
                child: isPlaying
                    ? Icon(
                        Icons.equalizer,
                        color: Color(0xFFEFEDE3),
                        size: 20,
                      )
                    : Text(
                        '$index.',
                        style: TextStyle(
                          color: isCurrentTrack
                              ? ThemeManager.instance.textColor
                              : ThemeManager.instance.textColor.withValues(alpha: 0.6),
                          fontSize: 16,
                          fontWeight: isCurrentTrack ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: TextStyle(
                        color: isCurrentTrack
                            ? ThemeManager.instance.textColor
                            : ThemeManager.instance.textColor.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: isCurrentTrack ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.artist,
                      style: TextStyle(
                        color: isCurrentTrack
                            ? ThemeManager.instance.textColor.withValues(alpha: 0.7)
                            : ThemeManager.instance.textColor.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Duration
              if (track.duration != null)
                Text(
                  _formatDuration(track.duration!),
                  style: TextStyle(
                    color: ThemeManager.instance.textColor.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                )
              else
                const SizedBox(width: 40),
              const SizedBox(width: 12),
              // More options
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Color(0xFFEFEDE3),
                  size: 20,
                ),
                onPressed: () {
                  // TODO: Показать меню действий
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}