import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ==================== CREATE PLAYLIST SCREEN ====================
class CreatePlaylistScreen extends StatefulWidget {
  const CreatePlaylistScreen({super.key});

  @override
  State<CreatePlaylistScreen> createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  String? _selectedImage;
  File? _selectedImageFromGallery;
  bool _isFromGallery = false;
  
  // Фон плейлиста
  File? _backgroundImage;
  bool _isBackgroundFromGallery = false;

  final List<String> _imageOptions = [
    'assets/vinyl1.png',
    'assets/vinyl2.png',
    'assets/vinyl3.png',
    'assets/vinyl4.png',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171716),
      appBar: AppBar(
        backgroundColor: const Color(0xFF171716),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFFEFEDE3)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Создать плейлист',
          style: TextStyle(
            color: Color(0xFFEFEDE3),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _nameController.text.isNotEmpty ? _createPlaylist : null,
            child: const Text(
              'Создать',
              style: TextStyle(
                color: Color(0xFFEFEDE3),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Playlist preview
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A28),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                  child: _selectedImageFromGallery != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            _selectedImageFromGallery!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.music_note,
                              size: 80,
                              color: Color(0xFFEFEDE3),
                            ),
                ),
              ),
              const SizedBox(height: 24),
              // Name field
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Color(0xFFEFEDE3)),
                decoration: InputDecoration(
                  labelText: 'Название плейлиста',
                  labelStyle: TextStyle(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                  ),
                  hintText: 'Мой плейлист',
                  hintStyle: TextStyle(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFEFEDE3),
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),
              // Description field
              TextField(
                controller: _descriptionController,
                style: const TextStyle(color: Color(0xFFEFEDE3)),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Описание (необязательно)',
                  labelStyle: TextStyle(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
                  ),
                  hintText: 'Добавьте описание...',
                  hintStyle: TextStyle(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFEFEDE3),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Image selection
              const Text(
                'Выберите обложку',
                style: TextStyle(
                  color: Color(0xFFEFEDE3),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Кнопка выбора из галереи
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo_library, color: Color(0xFFEFEDE3)),
                  label: const Text(
                    'Выбрать из галереи',
                    style: TextStyle(
                      color: Color(0xFFEFEDE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              ),
              // Предустановленные изображения
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Кнопка "Из галереи" в списке (если выбрано)
                    if (_selectedImageFromGallery != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageFromGallery = null;
                            _isFromGallery = false;
                            _selectedImage = null;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFEFEDE3),
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(11),
                                child: Image.file(
                                  _selectedImageFromGallery!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Предустановленные изображения
                    ..._imageOptions.map((imagePath) {
                      final isSelected = _selectedImage == imagePath && !_isFromGallery;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImage = imagePath;
                            _selectedImageFromGallery = null;
                            _isFromGallery = false;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFEFEDE3)
                                  : const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF2A2A28),
                                  child: const Icon(
                                    Icons.image,
                                    color: Color(0xFFEFEDE3),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Фон плейлиста
              const Text(
                'Фон плейлиста',
                style: TextStyle(
                  color: Color(0xFFEFEDE3),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              // Превью фона
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _backgroundImage != null
                      ? Stack(
                          children: [
                            Image.file(
                              _backgroundImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _backgroundImage = null;
                                    _isBackgroundFromGallery = false;
                                  });
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 40,
                                color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Фон не выбран',
                                style: TextStyle(
                                  color: const Color(0xFFEFEDE3).withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              // Кнопка выбора фона из галереи
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickBackgroundFromGallery,
                  icon: const Icon(Icons.photo_library, color: Color(0xFFEFEDE3)),
                  label: Text(
                    _backgroundImage != null
                        ? 'Изменить фон'
                        : 'Выбрать фон из галереи',
                    style: const TextStyle(
                      color: Color(0xFFEFEDE3),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C1C1C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: const Color(0xFFEFEDE3).withValues(alpha: 0.2),
                      ),
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

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _selectedImageFromGallery = File(image.path);
          _selectedImage = null;
          _isFromGallery = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выборе изображения: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickBackgroundFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _backgroundImage = File(image.path);
          _isBackgroundFromGallery = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выборе фона: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _createPlaylist() {
    if (_nameController.text.isNotEmpty) {
      Navigator.of(context).pop({
        'title': _nameController.text,
        'description': _descriptionController.text,
        'image': _isFromGallery && _selectedImageFromGallery != null
            ? _selectedImageFromGallery!.path
            : _selectedImage ?? 'assets/vinyl1.png',
        'isFromGallery': _isFromGallery,
        'backgroundImage': _backgroundImage?.path,
        'isBackgroundFromGallery': _isBackgroundFromGallery,
        'songCount': 0,
      });
    }
  }
}

