import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'theme_manager.dart';

// ==================== WIDGET CREATOR SCREEN ====================
class WidgetCreatorScreen extends StatefulWidget {
  const WidgetCreatorScreen({super.key});

  @override
  State<WidgetCreatorScreen> createState() => _WidgetCreatorScreenState();
}

class _WidgetCreatorScreenState extends State<WidgetCreatorScreen> {
  final ThemeManager _themeManager = ThemeManager.instance;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  
  String? _selectedContentType; // 'song', 'playlist', 'album', 'artist'
  String? _selectedContentName;
  
  int _currentStep = 0; // 0: name, 1: content type, 2: content selection, 3: customization
  
  // Настройки виджета
  String _widgetSize = 'medium'; // medium, large (удлиненный)
  File? _backgroundImage;
  bool _isBackgroundFromGallery = false;
  bool _hideWidgetInfo = false; // Скрыть информацию на виджете

  // Mock data
  final Map<String, List<String>> _contentData = {
    'song': [
      'Mad Boy (feat. ALKUN)',
      'Tokyo Drift',
      'Night Drive',
      'Sunset Boulevard',
    ],
    'playlist': [
      'Daily Mix 1',
      'Chill Vibes',
      'Workout Mix',
      'Evening Relax',
      'Мои лайки',
    ],
    'album': [
      'Midnight Sessions',
      'Urban Dreams',
      'City Lights',
      'Neon Nights',
    ],
    'artist': [
      'ALKUN',
      'Yoshimura',
      'CUPSIZE',
      'shibob',
    ],
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: _themeManager.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: _themeManager.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _getStepTitle(),
          style: TextStyle(
            color: _themeManager.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_currentStep == 3)
            TextButton(
              onPressed: _canSave() ? _saveWidget : null,
              child: Text(
                'Сохранить',
                style: TextStyle(
                  color: _canSave() ? _themeManager.primaryColor : _themeManager.secondaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Прогресс
            _buildProgressIndicator(),
            // Widget preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _themeManager.secondaryBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: _themeManager.primaryColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Превью виджета',
                    style: TextStyle(
                      color: Color(0xFFEFEDE3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: _buildWidgetPreview(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: _buildStepContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
              decoration: BoxDecoration(
                color: isActive
                    ? _themeManager.primaryColor
                    : _themeManager.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWidgetPreview() {
    final isLarge = _widgetSize == 'large';
    final previewWidth = isLarge ? 360.0 : 180.0;
    final previewHeight = isLarge ? 180.0 : 180.0;

    return Container(
      width: previewWidth,
      height: previewHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: _buildWidgetBackground(),
      ),
    );
  }

  Widget _buildWidgetBackground() {
    Widget background;
    
    if (_backgroundImage != null) {
      background = Image.file(
        _backgroundImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      background = Container(color: const Color(0xFF2A2A28));
    }

    return Stack(
      children: [
        background,
        // Контент виджета - внизу (только если не скрыто)
        if (!_hideWidgetInfo && _selectedContentName != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              _selectedContentName!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }


  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Название виджета';
      case 1:
        return 'Тип контента';
      case 2:
        return 'Выбор контента';
      case 3:
        return 'Настройка виджета';
      default:
        return 'Создание виджета';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildNameStep();
      case 1:
        return _buildContentTypeSelection();
      case 2:
        return _buildContentSelection();
      case 3:
        return _buildCustomizationStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Дайте название виджету',
            style: TextStyle(
              color: Color(0xFFEFEDE3),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Например: "Мои лайки", "Рабочая музыка"',
            style: TextStyle(
              color: const Color(0xFFEFEDE3).withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Color(0xFFEFEDE3)),
            decoration: InputDecoration(
              hintText: 'Название виджета',
              hintStyle: TextStyle(
                color: const Color(0xFFEFEDE3).withValues(alpha: 0.4),
              ),
              filled: true,
              fillColor: const Color(0xFF1C1C1C),
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
          const Spacer(),
          ElevatedButton(
            onPressed: _nameController.text.isNotEmpty
                ? () => setState(() => _currentStep = 1)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _themeManager.primaryColor,
              foregroundColor: _themeManager.backgroundColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Далее',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTypeSelection() {
    final types = [
      {'id': 'playlist', 'name': 'Плейлист', 'icon': Icons.queue_music},
      {'id': 'song', 'name': 'Песня', 'icon': Icons.music_note},
      {'id': 'album', 'name': 'Альбом', 'icon': Icons.album},
      {'id': 'artist', 'name': 'Исполнитель', 'icon': Icons.person},
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Выберите тип контента для виджета',
          style: TextStyle(
            color: Color(0xFFEFEDE3),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 24),
        ...types.map((type) => _buildTypeCard(
          type['id'] as String,
          type['name'] as String,
          type['icon'] as IconData,
        )),
      ],
    );
  }

  Widget _buildTypeCard(String id, String name, IconData icon) {
    final isSelected = _selectedContentType == id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? _themeManager.primaryColor
              : _themeManager.primaryColor.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedContentType = id;
              _selectedContentName = null;
            });
            Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                _currentStep = 2;
              });
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _themeManager.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: _themeManager.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: _themeManager.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: _themeManager.secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSelection() {
    if (_selectedContentType == null) return const SizedBox();
    
    final items = _contentData[_selectedContentType] ?? [];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: _themeManager.primaryColor),
              onPressed: () {
                setState(() {
                  _currentStep = 1;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Выберите ${_getContentTypeName(_selectedContentType!)}',
                style: TextStyle(
                  color: _themeManager.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildContentItem(item)),
      ],
    );
  }

  Widget _buildContentItem(String name) {
    final isSelected = _selectedContentName == name;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? _themeManager.primaryColor
              : _themeManager.primaryColor.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedContentName = name;
            });
            Future.delayed(const Duration(milliseconds: 300), () {
              setState(() {
                _currentStep = 3;
              });
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: _themeManager.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: _themeManager.primaryColor,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizationStep() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: _themeManager.primaryColor),
              onPressed: () {
                setState(() {
                  _currentStep = 2;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Настройка виджета',
                style: TextStyle(
                  color: _themeManager.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Размер виджета
        _buildSectionTitle('Размер виджета'),
        const SizedBox(height: 12),
        _buildSizeSelector(),
        const SizedBox(height: 32),
        // Фон виджета
        _buildSectionTitle('Фон виджета'),
        const SizedBox(height: 12),
        _buildImagePicker(),
        const SizedBox(height: 32),
        // Скрытие информации
        _buildSectionTitle('Отображение'),
        const SizedBox(height: 12),
        _buildSwitchOption(
          'Скрыть информацию на виджете',
          _hideWidgetInfo,
          (value) => setState(() => _hideWidgetInfo = value),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _themeManager.textColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildSizeOption('medium', 'Средний'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSizeOption('large', 'Удлиненный'),
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size, String label) {
    final isSelected = _widgetSize == size;
    return GestureDetector(
      onTap: () => setState(() => _widgetSize = size),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? _themeManager.primaryColor.withValues(alpha: 0.2)
              : _themeManager.secondaryBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? _themeManager.primaryColor
                : _themeManager.primaryColor.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? _themeManager.primaryColor
                : _themeManager.textColor,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_backgroundImage != null)
          Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _themeManager.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _backgroundImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () => setState(() => _backgroundImage = null),
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
            ),
          ),
        ElevatedButton.icon(
          onPressed: _pickBackgroundImage,
          icon: Icon(Icons.photo_library, color: _themeManager.textColor),
          label: Text(
            _backgroundImage != null ? 'Изменить изображение' : 'Выбрать из галереи',
            style: TextStyle(color: _themeManager.textColor),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _themeManager.secondaryBackgroundColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }


  Future<void> _pickBackgroundImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _backgroundImage = File(image.path);
          _isBackgroundFromGallery = true;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  bool _canSave() {
    return _nameController.text.isNotEmpty &&
        _selectedContentType != null &&
        _selectedContentName != null;
  }

  void _saveWidget() {
    if (_canSave()) {
      Navigator.of(context).pop({
        'name': _nameController.text,
        'contentType': _selectedContentType,
        'contentName': _selectedContentName,
        'size': _widgetSize,
        'backgroundImage': _backgroundImage?.path,
        'isBackgroundFromGallery': _isBackgroundFromGallery,
        'hideWidgetInfo': _hideWidgetInfo,
      });
    }
  }

  Widget _buildSwitchOption(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: _themeManager.textColor,
              fontSize: 16,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _themeManager.primaryColor,
          ),
        ],
      ),
    );
  }

  String _getContentTypeName(String type) {
    switch (type) {
      case 'song':
        return 'песню';
      case 'playlist':
        return 'плейлист';
      case 'album':
        return 'альбом';
      case 'artist':
        return 'исполнителя';
      default:
        return '';
    }
  }
}
