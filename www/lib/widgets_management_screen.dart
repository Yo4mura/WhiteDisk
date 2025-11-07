import 'dart:io';
import 'package:flutter/material.dart';
import 'widget_creator_screen.dart';
import 'theme_manager.dart';

class WidgetsManagementScreen extends StatefulWidget {
  const WidgetsManagementScreen({super.key});

  @override
  State<WidgetsManagementScreen> createState() => _WidgetsManagementScreenState();
}

class _WidgetsManagementScreenState extends State<WidgetsManagementScreen> {
  final ThemeManager _themeManager = ThemeManager.instance;

  // Список созданных виджетов
  List<Map<String, dynamic>> _widgets = [
    {
      'id': '1',
      'name': 'Мои лайки',
      'type': 'playlist',
      'contentName': 'Избранное',
      'size': 'medium', // medium, large
      'backgroundImage': 'assets/vinyl1.png',
      'isBackgroundFromGallery': false,
      'hideWidgetInfo': false,
    },
  ];

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
          'Виджеты',
          style: TextStyle(
            color: _themeManager.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: _themeManager.primaryColor),
            onPressed: () => _createNewWidget(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Информационный баннер
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _themeManager.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _themeManager.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: _themeManager.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Виджеты позволяют управлять музыкой прямо с главного экрана',
                    style: TextStyle(
                      color: _themeManager.textColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Список виджетов
          Expanded(
            child: _widgets.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Text(
                        'Мои виджеты (${_widgets.length})',
                        style: TextStyle(
                          color: _themeManager.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._widgets.map((widget) => _buildWidgetCard(widget)),
                      const SizedBox(height: 16),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.widgets_outlined,
            size: 80,
            color: _themeManager.secondaryTextColor,
          ),
          const SizedBox(height: 24),
          Text(
            'Нет созданных виджетов',
            style: TextStyle(
              color: _themeManager.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Создайте виджет для управления музыкой\nпрямо с главного экрана',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _themeManager.secondaryTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _createNewWidget,
            icon: Icon(Icons.add, color: _themeManager.backgroundColor),
            label: Text(
              'Создать виджет',
              style: TextStyle(color: _themeManager.backgroundColor),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _themeManager.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetCard(Map<String, dynamic> widget) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Превью виджета
          GestureDetector(
            onTap: () {
              // Имитация запуска контента
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Запуск: ${widget['contentName']}'),
                  backgroundColor: _themeManager.secondaryBackgroundColor,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Фон виджета
                  if (widget['backgroundImage'] != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: (widget['isBackgroundFromGallery'] as bool? ?? false)
                          ? Image.file(
                              File(widget['backgroundImage'] as String),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Image.asset(
                              widget['backgroundImage'] as String,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    )
                  else
                    Container(
                      color: const Color(0xFF2A2A28),
                    ),
                  // Название контента - внизу (только если не скрыто)
                  if (!(widget['hideWidgetInfo'] as bool? ?? false))
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Text(
                        widget['contentName'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
              ),
            ),
          ),
          // Информация и действия
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget['name'] as String,
                        style: TextStyle(
                          color: _themeManager.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getSizeName(widget['size'] as String),
                        style: TextStyle(
                          color: _themeManager.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: _themeManager.primaryColor),
                  onPressed: () => _editWidget(widget),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _deleteWidget(widget['id'] as String),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getSizeName(String size) {
    switch (size) {
      case 'medium':
        return 'Средний';
      case 'large':
        return 'Удлиненный';
      default:
        return 'Средний';
    }
  }

  void _createNewWidget() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WidgetCreatorScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        _widgets.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'name': result['name'] ?? 'Новый виджет',
          'type': result['contentType'],
          'contentName': result['contentName'],
          'size': result['size'] ?? 'medium',
          'backgroundImage': result['backgroundImage'] ?? 'assets/vinyl1.png',
          'isBackgroundFromGallery': result['isBackgroundFromGallery'] ?? false,
          'hideWidgetInfo': result['hideWidgetInfo'] ?? false,
        });
      });
    }
  }

  void _editWidget(Map<String, dynamic> widget) {
    // TODO: Открыть экран редактирования виджета
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Редактирование виджета "${widget['name']}"'),
        backgroundColor: _themeManager.secondaryBackgroundColor,
      ),
    );
  }

  void _deleteWidget(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _themeManager.secondaryBackgroundColor,
        title: Text(
          'Удалить виджет?',
          style: TextStyle(color: _themeManager.textColor),
        ),
        content: Text(
          'Виджет будет удален с главного экрана',
          style: TextStyle(color: _themeManager.secondaryTextColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: _themeManager.secondaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _widgets.removeWhere((w) => w['id'] == id);
              });
              Navigator.of(context).pop();
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

