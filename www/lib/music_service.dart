import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'track_model.dart';

/// Сервис для работы с музыкой
class MusicService extends ChangeNotifier {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  
  List<Track> _tracks = [];
  Track? _currentTrack;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  PlayerState _playerState = PlayerState.stopped;
  
  // Shuffle и Repeat
  bool _isShuffleEnabled = false;
  bool _isRepeatEnabled = false;
  RepeatMode _repeatMode = RepeatMode.off;
  
  // Очередь
  List<Track> _queue = [];
  
  // Таймер сна
  Timer? _sleepTimer;
  Duration? _sleepTimerDuration;
  bool _isSleepTimerActive = false;

  // Геттеры
  List<Track> get tracks => _tracks;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  PlayerState get playerState => _playerState;
  bool get isShuffleEnabled => _isShuffleEnabled;
  bool get isRepeatEnabled => _isRepeatEnabled;
  RepeatMode get repeatMode => _repeatMode;
  List<Track> get queue => List.unmodifiable(_queue);
  Duration? get sleepTimerDuration => _sleepTimerDuration;
  bool get isSleepTimerActive => _isSleepTimerActive;

  /// Инициализация сервиса
  Future<void> init() async {
    // Слушаем изменения позиции
    _audioPlayer.onPositionChanged.listen((position) {
      _position = position;
      notifyListeners();
    });

    // Слушаем изменения длительности
    _audioPlayer.onDurationChanged.listen((duration) {
      _duration = duration;
      notifyListeners();
    });

    // Слушаем изменения состояния
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      _isPlaying = state == PlayerState.playing;
      _isLoading = false; // audioplayers не имеет состояния loading
      notifyListeners();
    });

    // Слушаем завершение трека
    _audioPlayer.onPlayerComplete.listen((_) {
      _onTrackComplete();
    });

    // Загружаем треки
    await loadTracks();
  }

  /// Загрузка треков из assets
  Future<void> loadTracks() async {
    try {
      // Получаем список файлов из assets/music
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifestContent);
      
      // Фильтруем только музыкальные файлы
      final musicFiles = manifestMap.keys
          .where((key) => key.startsWith('assets/music/'))
          .where((key) {
            final ext = key.split('.').last.toLowerCase();
            return ['mp3', 'm4a', 'aac', 'wav', 'ogg'].contains(ext);
          })
          .map((key) => key.replaceFirst('assets/music/', ''))
          .toList();

      // Создаем треки из имен файлов
      _tracks = musicFiles.map((fileName) => Track.fromFileName(fileName)).toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка загрузки треков: $e');
      _tracks = [];
      notifyListeners();
    }
  }

  /// Воспроизведение трека
  Future<void> playTrack(Track track) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentTrack = track;
      
      // Останавливаем текущее воспроизведение
      await _audioPlayer.stop();
      
      // Запускаем новый трек (убираем 'assets/' из пути для AssetSource)
      final sourcePath = track.filePath.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(sourcePath));
      
      _isPlaying = true;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка воспроизведения: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Пауза/возобновление
  Future<void> togglePlayPause() async {
    if (_currentTrack == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  /// Остановка
  Future<void> stop() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _position = Duration.zero;
    notifyListeners();
  }

  /// Переключение на следующий трек
  Future<void> nextTrack() async {
    if (_tracks.isEmpty || _currentTrack == null) return;

    // Если есть очередь, используем её
    if (_queue.isNotEmpty) {
      final nextTrack = _queue.removeAt(0);
      await playTrack(nextTrack);
      notifyListeners();
      return;
    }

    final currentIndex = _tracks.indexWhere((t) => t.id == _currentTrack!.id);
    if (currentIndex == -1) return;

    int nextIndex;
    if (_isShuffleEnabled) {
      // Случайный трек
      final random = Random();
      nextIndex = random.nextInt(_tracks.length);
      // Убеждаемся, что не выбрали тот же трек
      while (nextIndex == currentIndex && _tracks.length > 1) {
        nextIndex = random.nextInt(_tracks.length);
      }
    } else {
      nextIndex = (currentIndex + 1) % _tracks.length;
    }
    
    // Если Repeat выключен и достигли конца плейлиста, останавливаем
    if (!_isShuffleEnabled && nextIndex == 0 && _repeatMode == RepeatMode.off) {
      // Достигли конца плейлиста и Repeat выключен - останавливаем
      _isPlaying = false;
      notifyListeners();
      return;
    }
    
    await playTrack(_tracks[nextIndex]);
  }

  /// Переключение на предыдущий трек
  Future<void> previousTrack() async {
    if (_tracks.isEmpty || _currentTrack == null) return;

    final currentIndex = _tracks.indexWhere((t) => t.id == _currentTrack!.id);
    if (currentIndex == -1) return;

    int prevIndex;
    if (_isShuffleEnabled) {
      // Случайный трек
      final random = Random();
      prevIndex = random.nextInt(_tracks.length);
      while (prevIndex == currentIndex && _tracks.length > 1) {
        prevIndex = random.nextInt(_tracks.length);
      }
    } else {
      prevIndex = currentIndex == 0 ? _tracks.length - 1 : currentIndex - 1;
    }
    
    await playTrack(_tracks[prevIndex]);
  }
  
  /// Переключение Shuffle
  void toggleShuffle() {
    _isShuffleEnabled = !_isShuffleEnabled;
    notifyListeners();
  }
  
  /// Переключение Repeat
  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }
  
  /// Добавление трека в очередь
  void addToQueue(Track track) {
    _queue.add(track);
    notifyListeners();
  }
  
  /// Удаление трека из очереди
  void removeFromQueue(int index) {
    if (index >= 0 && index < _queue.length) {
      _queue.removeAt(index);
      notifyListeners();
    }
  }
  
  /// Очистка очереди
  void clearQueue() {
    _queue.clear();
    notifyListeners();
  }
  
  /// Перестановка треков в очереди
  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final track = _queue.removeAt(oldIndex);
    _queue.insert(newIndex, track);
    notifyListeners();
  }
  
  /// Запуск таймера сна
  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    _sleepTimerDuration = duration;
    _isSleepTimerActive = true;
    
    _sleepTimer = Timer(duration, () {
      stop();
      _isSleepTimerActive = false;
      _sleepTimerDuration = null;
      notifyListeners();
    });
    
    notifyListeners();
  }
  
  /// Остановка таймера сна
  void stopSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _isSleepTimerActive = false;
    _sleepTimerDuration = null;
    notifyListeners();
  }

  /// Переход к позиции
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Обработка завершения трека
  void _onTrackComplete() {
    _isPlaying = false;
    _position = Duration.zero;
    
    // Если включен Repeat для одного трека, повторяем его
    if (_repeatMode == RepeatMode.one && _currentTrack != null) {
      playTrack(_currentTrack!);
      return;
    }
    
    // Автоматически переключаем на следующий трек
    // (nextTrack сам обработает Repeat.all и очередь)
    nextTrack();
  }

  /// Получение трека по ID
  Track? getTrackById(String id) {
    try {
      return _tracks.firstWhere((track) => track.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Поиск треков
  List<Track> searchTracks(String query) {
    if (query.isEmpty) return _tracks;
    
    final lowerQuery = query.toLowerCase();
    return _tracks.where((track) {
      return track.title.toLowerCase().contains(lowerQuery) ||
             track.artist.toLowerCase().contains(lowerQuery) ||
             (track.album?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Освобождение ресурсов
  @override
  void dispose() {
    _sleepTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// Режимы повтора
enum RepeatMode {
  off,   // Выключен
  all,   // Повторять весь плейлист
  one,   // Повторять один трек
}

