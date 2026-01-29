/// Модель музыкального трека
class Track {
  final String id;
  final String title;
  final String artist;
  final String? album;
  final String filePath; // Путь к файлу в assets
  final Duration? duration;
  final String? coverPath; // Путь к обложке
  final DateTime? dateAdded;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.filePath,
    this.duration,
    this.coverPath,
    this.dateAdded,
  });

  /// Создание из имени файла (для автоматического сканирования)
  factory Track.fromFileName(String fileName) {
    // Убираем расширение
    final nameWithoutExt = fileName.replaceAll(RegExp(r'\.[^.]+$'), '');
    
    // Пытаемся извлечь название и артиста из имени файла
    // Форматы: "Artist - Title", "Title", "Artist_Title"
    String title = nameWithoutExt;
    String artist = 'Unknown Artist';
    
    if (nameWithoutExt.contains(' - ')) {
      final parts = nameWithoutExt.split(' - ');
      if (parts.length >= 2) {
        artist = parts[0].trim();
        title = parts.sublist(1).join(' - ').trim();
      }
    } else if (nameWithoutExt.contains('_')) {
      final parts = nameWithoutExt.split('_');
      if (parts.length >= 2) {
        artist = parts[0].trim();
        title = parts.sublist(1).join('_').trim();
      }
    }
    
    // Заменяем подчеркивания на пробелы для читаемости
    title = title.replaceAll('_', ' ');
    artist = artist.replaceAll('_', ' ');
    
    return Track(
      id: fileName,
      title: title.isEmpty ? nameWithoutExt : title,
      artist: artist,
      filePath: 'assets/music/$fileName',
      dateAdded: DateTime.now(),
    );
  }

  /// Конвертация в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'filePath': filePath,
      'duration': duration?.inSeconds,
      'coverPath': coverPath,
      'dateAdded': dateAdded?.toIso8601String(),
    };
  }

  /// Создание из JSON
  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] as String,
      title: json['title'] as String,
      artist: json['artist'] as String,
      album: json['album'] as String?,
      filePath: json['filePath'] as String,
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
      coverPath: json['coverPath'] as String?,
      dateAdded: json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'] as String)
          : null,
    );
  }

  /// Копирование с изменениями
  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    Duration? duration,
    String? coverPath,
    DateTime? dateAdded,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      coverPath: coverPath ?? this.coverPath,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}

