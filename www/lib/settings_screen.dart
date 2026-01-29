import 'package:flutter/material.dart';
import 'customization_screen.dart';
import 'profile_settings_screen.dart';
import 'theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ThemeManager _themeManager = ThemeManager.instance;
  
  // Настройки уведомлений
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;
  bool _pushNotifications = true;
  
  // Настройки приватности
  bool _privateProfile = false;
  bool _showActivity = true;
  
  // Настройки воспроизведения
  bool _autoPlay = true;
  bool _highQuality = false;
  double _volume = 0.7;

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
          'Настройки',
          style: TextStyle(
            color: _themeManager.textColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 8),
          // Кастомизация
          _buildSettingsSection(
            title: 'Внешний вид',
            children: [
              _buildSettingsTile(
                icon: Icons.palette_outlined,
                title: 'Кастомизация',
                subtitle: 'Изменить цвета и фон приложения',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CustomizationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Профиль
          _buildSettingsSection(
            title: 'Профиль',
            children: [
              _buildSettingsTile(
                icon: Icons.edit_outlined,
                title: 'Редактировать профиль',
                subtitle: 'Изменить имя, username и описание',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileSettingsScreen(),
                    ),
                  );
                },
              ),
              _buildSwitchTile(
                icon: Icons.lock_outline,
                title: 'Приватный профиль',
                subtitle: 'Скрыть профиль от других пользователей',
                value: _privateProfile,
                onChanged: (value) {
                  setState(() {
                    _privateProfile = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.visibility_outlined,
                title: 'Показывать активность',
                subtitle: 'Другие пользователи видят вашу активность',
                value: _showActivity,
                onChanged: (value) {
                  setState(() {
                    _showActivity = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Воспроизведение
          _buildSettingsSection(
            title: 'Воспроизведение',
            children: [
              _buildSwitchTile(
                icon: Icons.play_arrow_outlined,
                title: 'Автовоспроизведение',
                subtitle: 'Автоматически воспроизводить следующий трек',
                value: _autoPlay,
                onChanged: (value) {
                  setState(() {
                    _autoPlay = value;
                  });
                },
              ),
              _buildSwitchTile(
                icon: Icons.high_quality_outlined,
                title: 'Высокое качество',
                subtitle: 'Воспроизведение в высоком качестве',
                value: _highQuality,
                onChanged: (value) {
                  setState(() {
                    _highQuality = value;
                  });
                },
              ),
              _buildSliderTile(
                icon: Icons.volume_up_outlined,
                title: 'Громкость',
                value: _volume,
                onChanged: (value) {
                  setState(() {
                    _volume = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Уведомления
          _buildSettingsSection(
            title: 'Уведомления',
            children: [
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
                title: 'Уведомления',
                subtitle: 'Включить все уведомления',
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                    if (!value) {
                      _emailNotifications = false;
                      _pushNotifications = false;
                    }
                  });
                },
              ),
              if (_notificationsEnabled) ...[
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Email уведомления',
                  subtitle: 'Получать уведомления на email',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _emailNotifications = value;
                    });
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.phone_android_outlined,
                  title: 'Push уведомления',
                  subtitle: 'Получать push уведомления',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _pushNotifications = value;
                    });
                  },
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          // Хранилище
          _buildSettingsSection(
            title: 'Хранилище',
            children: [
              _buildSettingsTile(
                icon: Icons.download_outlined,
                title: 'Загруженная музыка',
                subtitle: '12 треков • 245 МБ',
                onTap: () {
                  // TODO: Открыть список загруженной музыки
                },
              ),
              _buildSettingsTile(
                icon: Icons.delete_outline,
                title: 'Очистить кеш',
                subtitle: 'Освободить 89 МБ',
                onTap: () {
                  // TODO: Очистить кеш
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Кеш очищен'),
                      backgroundColor: _themeManager.secondaryBackgroundColor,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // О приложении
          _buildSettingsSection(
            title: 'О приложении',
            children: [
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'Версия',
                subtitle: '1.0.0',
                onTap: null,
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Условия использования',
                subtitle: 'Прочитать условия использования',
                onTap: () {
                  // TODO: Открыть условия использования
                },
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Политика конфиденциальности',
                subtitle: 'Прочитать политику конфиденциальности',
                onTap: () {
                  // TODO: Открыть политику конфиденциальности
                },
              ),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Помощь и поддержка',
                subtitle: 'Получить помощь',
                onTap: () {
                  // TODO: Открыть помощь
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: TextStyle(
              color: _themeManager.secondaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: _themeManager.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _themeManager.primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _themeManager.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isEnabled
                      ? _themeManager.primaryColor
                      : _themeManager.secondaryTextColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isEnabled
                            ? _themeManager.textColor
                            : _themeManager.secondaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: _themeManager.secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isEnabled)
                Icon(
                  Icons.chevron_right,
                  color: _themeManager.secondaryTextColor,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: _themeManager.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _themeManager.primaryColor.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _themeManager.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: _themeManager.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _themeManager.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: _themeManager.secondaryTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: _themeManager.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _themeManager.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _themeManager.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _themeManager.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: _themeManager.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _themeManager.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${(value * 100).toInt()}%',
                style: TextStyle(
                  color: _themeManager.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            activeColor: _themeManager.primaryColor,
            inactiveColor: _themeManager.primaryColor.withValues(alpha: 0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

