import 'package:flutter/material.dart';
import 'music_service.dart';
import 'track_model.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final MusicService _musicService = MusicService();

  @override
  void initState() {
    super.initState();
    _musicService.addListener(_onMusicServiceChanged);
  }

  @override
  void dispose() {
    _musicService.removeListener(_onMusicServiceChanged);
    super.dispose();
  }

  void _onMusicServiceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _playTrack(Track track) {
    _musicService.playTrack(track);
    Navigator.of(context).pop();
  }

  void _removeFromQueue(int index) {
    setState(() {
      _musicService.removeFromQueue(index);
    });
  }

  void _reorderQueue(int oldIndex, int newIndex) {
    setState(() {
      _musicService.reorderQueue(oldIndex, newIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final queue = _musicService.queue;
    final currentTrack = _musicService.currentTrack;

    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171716),
        elevation: 0,
        title: const Text(
          'Очередь',
          style: TextStyle(color: Color(0xFFEFEDE3)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFEFEDE3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (queue.isNotEmpty)
            TextButton(
              onPressed: () {
                _musicService.clearQueue();
                setState(() {});
              },
              child: const Text(
                'Очистить',
                style: TextStyle(color: Color(0xFFEFEDE3)),
              ),
            ),
        ],
      ),
      body: queue.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.queue_music,
                    size: 64,
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Очередь пуста',
                    style: TextStyle(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Добавьте треки в очередь',
                    style: TextStyle(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: queue.length,
              onReorder: _reorderQueue,
              itemBuilder: (context, index) {
                final track = queue[index];
                final isCurrentTrack = currentTrack?.id == track.id;

                return ListTile(
                  key: ValueKey(track.id),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF3D3B37),
                    ),
                    child: track.coverPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              track.coverPath!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.music_note,
                            color: Color(0xFFEFEDE3),
                            size: 24,
                          ),
                  ),
                  title: Text(
                    track.title,
                    style: TextStyle(
                      color: isCurrentTrack
                          ? const Color(0xFFEFEDE3)
                          : const Color(0xFFEFEDE3).withValues(alpha: 0.9),
                      fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    track.artist,
                    style: TextStyle(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCurrentTrack)
                        const Icon(
                          Icons.equalizer,
                          color: Color(0xFFEFEDE3),
                          size: 20,
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFFEFEDE3),
                          size: 20,
                        ),
                        onPressed: () => _removeFromQueue(index),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  onTap: () => _playTrack(track),
                );
              },
            ),
    );
  }
}

