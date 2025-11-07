import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'theme_manager.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  final ThemeManager _themeManager = ThemeManager.instance;
  final ImagePicker _imagePicker = ImagePicker();
  
  // Фоновое изображение
  File? _backgroundImage;
  double _imageScale = 1.0;
  double _imageOffsetX = 0.0;
  double _imageOffsetY = 0.0;
  double _previousScale = 1.0;

  // Цветовой пикер
  double _hue = 0.0; // 0-360
  double _saturation = 0.0; // 0-1
  double _brightness = 0.0; // 0-1
  Color _currentColor = const Color(0xFFEFEDE3);
  String _hexColor = 'EFEDE3';

  String _pickingType = 'primary'; // 'primary', 'background', 'secondary'

  @override
  void initState() {
    super.initState();
    _currentColor = _themeManager.primaryColor;
    _updateColorFromRGB(_currentColor);
  }

  void _updateColorFromRGB(Color color) {
    final hsl = HSLColor.fromColor(color);
    _hue = hsl.hue;
    _saturation = hsl.saturation;
    _brightness = hsl.lightness;
    _updateHexColor();
  }

  void _updateHexColor() {
    final color = HSLColor.fromAHSL(
      1.0, // Всегда непрозрачный
      _hue,
      _saturation,
      _brightness,
    ).toColor();
    _currentColor = color;
    _hexColor = color.value.toRadixString(16).substring(2).toUpperCase();
  }

  Color _getHueColor() {
    return HSLColor.fromAHSL(1.0, _hue, 1.0, 0.5).toColor();
  }

  void _resetToDefault() {
    setState(() {
      _themeManager.resetToDefault();
      _currentColor = _themeManager.primaryColor;
      _updateColorFromRGB(_currentColor);
      _backgroundImage = null;
      _imageScale = 1.0;
      _imageOffsetX = 0.0;
      _imageOffsetY = 0.0;
    });
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _backgroundImage = File(image.path);
          _imageScale = 1.0;
          _imageOffsetX = 0.0;
          _imageOffsetY = 0.0;
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

  void _showColorPickerDialog(String type) {
    setState(() {
      _pickingType = type;
      switch (type) {
        case 'primary':
          _currentColor = _themeManager.primaryColor;
          break;
        case 'background':
          _currentColor = _themeManager.backgroundColor;
          break;
        case 'secondary':
          _currentColor = _themeManager.secondaryBackgroundColor;
          break;
      }
      _updateColorFromRGB(_currentColor);
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: _themeManager.secondaryBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите цвет',
                    style: TextStyle(
                      color: _themeManager.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Основной квадрат с градиентом (Saturation/Brightness)
                  _buildSaturationBrightnessPicker(setDialogState),
                  const SizedBox(height: 16),
                  // Hue slider
                  _buildHueSlider(setDialogState),
                  const SizedBox(height: 16),
                  // Hex input
                  _buildHexInput(setDialogState),
                  const SizedBox(height: 20),
                  // Кнопки
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Отмена',
                          style: TextStyle(color: _themeManager.secondaryTextColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          _applyColor();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _currentColor,
                          foregroundColor: _getContrastColor(_currentColor),
                        ),
                        child: const Text('Применить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaturationBrightnessPicker(StateSetter setDialogState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            final localPosition = details.localPosition;
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            
            setDialogState(() {
              _saturation = (localPosition.dx / width).clamp(0.0, 1.0);
              _brightness = 1.0 - (localPosition.dy / height).clamp(0.0, 1.0);
              _updateHexColor();
            });
          },
          onTapDown: (details) {
            final localPosition = details.localPosition;
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            
            setDialogState(() {
              _saturation = (localPosition.dx / width).clamp(0.0, 1.0);
              _brightness = 1.0 - (localPosition.dy / height).clamp(0.0, 1.0);
              _updateHexColor();
            });
          },
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getHueColor(),
            ),
            child: Stack(
              children: [
                // Brightness gradient (top to bottom: white to black)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.transparent,
                        Colors.black,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                // Saturation gradient (left to right: transparent to grey)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.grey.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                ),
                // Индикатор текущей позиции
                Positioned(
                  left: _saturation * constraints.maxWidth - 10,
                  top: (1.0 - _brightness) * constraints.maxHeight - 10,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _brightness > 0.5 ? Colors.black : Colors.white,
                        width: 2,
                      ),
                      color: _currentColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHueSlider(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Оттенок',
          style: TextStyle(
            color: _themeManager.textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onPanUpdate: (details) {
                final localPosition = details.localPosition;
                final width = constraints.maxWidth;
                
                setDialogState(() {
                  _hue = (localPosition.dx / width * 360).clamp(0.0, 360.0);
                  _updateHexColor();
                });
              },
              onTapDown: (details) {
                final localPosition = details.localPosition;
                final width = constraints.maxWidth;
                
                setDialogState(() {
                  _hue = (localPosition.dx / width * 360).clamp(0.0, 360.0);
                  _updateHexColor();
                });
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF0000),
                      const Color(0xFFFFFF00),
                      const Color(0xFF00FF00),
                      const Color(0xFF00FFFF),
                      const Color(0xFF0000FF),
                      const Color(0xFFFF00FF),
                      const Color(0xFFFF0000),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: (_hue / 360) * constraints.maxWidth - 2,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }


  Widget _buildHexInput(StateSetter setDialogState) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _themeManager.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Hex:',
            style: TextStyle(
              color: _themeManager.textColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: TextStyle(
                color: _themeManager.textColor,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
              controller: TextEditingController(text: _hexColor),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  try {
                    final color = Color(int.parse('FF$value', radix: 16));
                    setDialogState(() {
                      _updateColorFromRGB(color);
                    });
                  } catch (e) {
                    // Invalid hex
                  }
                } else {
                  setDialogState(() {
                    _hexColor = value.toUpperCase();
                  });
                }
              },
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _themeManager.primaryColor.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _applyColor() {
    setState(() {
      switch (_pickingType) {
        case 'primary':
          _themeManager.setPrimaryColor(_currentColor);
          break;
        case 'background':
          _themeManager.setBackgroundColor(_currentColor);
          break;
        case 'secondary':
          _themeManager.setSecondaryBackgroundColor(_currentColor);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _themeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: _themeManager.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _themeManager.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Кастомизация',
          style: TextStyle(
            color: _themeManager.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _resetToDefault,
            child: Text(
              'Сбросить',
              style: TextStyle(
                color: _themeManager.primaryColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фоновое изображение
            Text(
              'Фоновое изображение',
              style: TextStyle(
                color: _themeManager.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBackgroundImageSection(),
            const SizedBox(height: 32),
            // Основная окраска
            Text(
              'Основная окраска',
              style: TextStyle(
                color: _themeManager.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildColorPickerTile(
              label: 'Основной цвет',
              color: _themeManager.primaryColor,
              type: 'primary',
            ),
            const SizedBox(height: 24),
            // Фон основных страниц
            Text(
              'Фон основных страниц',
              style: TextStyle(
                color: _themeManager.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildColorPickerTile(
              label: 'Цвет фона',
              color: _themeManager.backgroundColor,
              type: 'background',
            ),
            const SizedBox(height: 16),
            _buildColorPickerTile(
              label: 'Вторичный фон',
              color: _themeManager.secondaryBackgroundColor,
              type: 'secondary',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImageSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Превью изображения
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _themeManager.backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _themeManager.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _backgroundImage != null
                  ? GestureDetector(
                      onScaleStart: (details) {
                        _previousScale = _imageScale;
                      },
                      onScaleUpdate: (details) {
                        setState(() {
                          // Обработка масштабирования (относительное изменение)
                          _imageScale = (_previousScale * details.scale).clamp(0.5, 3.0);
                          // Обработка перемещения
                          _imageOffsetX += details.focalPointDelta.dx;
                          _imageOffsetY += details.focalPointDelta.dy;
                        });
                      },
                      onScaleEnd: (details) {
                        _previousScale = _imageScale;
                      },
                      child: Transform.scale(
                        scale: _imageScale,
                        child: Transform.translate(
                          offset: Offset(_imageOffsetX, _imageOffsetY),
                          child: Image.file(
                            _backgroundImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: _themeManager.secondaryTextColor,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Кнопки управления
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: Icon(Icons.photo_library, color: _themeManager.textColor),
                  label: Text(
                    'Выбрать из галереи',
                    style: TextStyle(color: _themeManager.textColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _themeManager.primaryColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              if (_backgroundImage != null) ...[
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _backgroundImage = null;
                      _imageScale = 1.0;
                      _imageOffsetX = 0.0;
                      _imageOffsetY = 0.0;
                    });
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ],
          ),
          if (_backgroundImage != null) ...[
            const SizedBox(height: 16),
            // Слайдеры для выравнивания
            Text(
              'Масштаб: ${(_imageScale * 100).toInt()}%',
              style: TextStyle(
                color: _themeManager.textColor,
                fontSize: 14,
              ),
            ),
            Slider(
              value: _imageScale,
              min: 0.5,
              max: 3.0,
              activeColor: _themeManager.primaryColor,
              onChanged: (value) {
                setState(() {
                  _imageScale = value;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _imageOffsetX = 0.0;
                        _imageOffsetY = 0.0;
                        _imageScale = 1.0;
                      });
                    },
                    child: Text(
                      'Сбросить позицию',
                      style: TextStyle(
                        color: _themeManager.textColor,
                        fontSize: 12,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _themeManager.primaryColor.withValues(alpha: 0.1),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColorPickerTile({
    required String label,
    required Color color,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: _themeManager.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showColorPickerDialog(type),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _themeManager.primaryColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
