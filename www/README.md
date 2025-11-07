# WhiteDisk - Flutter приложение

Музыкальное приложение с кастомизацией, виджетами и управлением плейлистами.

## Требования

- Flutter SDK (версия 3.9.2 или выше)
- Dart SDK (входит в состав Flutter)
- Xcode (для iOS/macOS разработки)
- Android Studio или Android SDK (для Android разработки, опционально)

## Установка зависимостей

Перед первым запуском необходимо установить зависимости проекта:

```bash
cd www
flutter pub get
```

## Проверка окружения

Проверьте, что Flutter настроен правильно:

```bash
flutter doctor
```

Убедитесь, что все необходимые компоненты установлены и настроены.

## Запуск проекта

### iOS Simulator (рекомендуется)

1. **Запустите iOS Simulator:**

   ```bash
   open -a Simulator
   ```

   Или через Xcode: Xcode → Open Developer Tool → Simulator

2. **Выберите устройство:**

   - В Simulator: File → Open Simulator → iPhone 16 Pro (или другое устройство)

3. **Запустите приложение:**

   ```bash
   cd www
   flutter run
   ```

   Или для конкретного устройства:

   ```bash
   flutter run -d "iPhone 16 Pro"
   ```

   Чтобы узнать ID устройства:

   ```bash
   flutter devices
   ```

### macOS

```bash
cd www
flutter run -d macos
```

## Полезные команды

### Просмотр доступных устройств

```bash
flutter devices
```

### Hot Reload (горячая перезагрузка)

Во время работы приложения нажмите `r` в терминале для быстрой перезагрузки изменений.

### Hot Restart (полная перезагрузка)

Нажмите `R` (заглавная) для полной перезагрузки приложения.

### Остановка приложения

Нажмите `q` в терминале или `Ctrl+C`.

### Очистка проекта

```bash
flutter clean
flutter pub get
```

### Сборка релизной версии

**iOS:**

```bash
flutter build ios --release
```

**macOS:**

```bash
flutter build macos --release
```

**Android:**

```bash
flutter build apk --release
```

## Структура проекта

- `lib/` - исходный код приложения

  - `main.dart` - точка входа
  - `home_screen.dart` - главный экран
  - `settings_screen.dart` - настройки
  - `customization_screen.dart` - кастомизация цветов и фона
  - `widget_creator_screen.dart` - создание виджетов
  - `widgets_management_screen.dart` - управление виджетами
  - и другие экраны...

- `assets/` - ресурсы (изображения, иконки)

## Основные функции

- 🎨 Кастомизация цветовой схемы приложения
- 🖼️ Выбор фонового изображения из галереи
- 📱 Создание и управление виджетами для главного экрана
- 🎵 Управление плейлистами с кастомными фонами
- 👤 Профиль пользователя с настройками

## Решение проблем

### Ошибка "Could not find Dart in your Flutter SDK"

```bash
flutter upgrade
flutter doctor
```

### Проблемы с iOS Simulator

```bash
# Перезапустите Simulator
killall Simulator
open -a Simulator
```

### Проблемы с зависимостями

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

### Проблемы с кешем

```bash
flutter clean
cd ios && pod deintegrate && pod install && cd ..
flutter pub get
```

## Разработка

Приложение использует:

- Flutter SDK 3.9.2+
- `image_picker` для выбора изображений из галереи
- Кастомный `ThemeManager` для управления темами

## Загрузка проекта в GitHub

### Первоначальная настройка

1. **Создайте репозиторий на GitHub:**

   - Перейдите на [github.com](https://github.com)
   - Нажмите "New repository" (или "+" → "New repository")
   - Введите название репозитория (например, `WhiteDisk`)
   - Выберите публичный или приватный репозиторий
   - **НЕ** добавляйте README, .gitignore или лицензию (они уже есть)
   - Нажмите "Create repository"

2. **Подготовьте проект к загрузке:**

   ```bash
   cd www
   git add .
   git commit -m "Initial commit: WhiteDisk music app"
   ```

3. **Подключите удаленный репозиторий:**

   ```bash
   git remote add origin https://github.com/ВАШ_USERNAME/НАЗВАНИЕ_РЕПОЗИТОРИЯ.git
   ```

   Или если используете SSH:

   ```bash
   git remote add origin git@github.com:ВАШ_USERNAME/НАЗВАНИЕ_РЕПОЗИТОРИЯ.git
   ```

4. **Загрузите проект:**
   ```bash
   git branch -M main
   git push -u origin main
   ```

### Обновление проекта

После внесения изменений:

```bash
git add .
git commit -m "Описание изменений"
git push
```

### Полезные команды Git

```bash
# Проверить статус
git status

# Посмотреть историю коммитов
git log

# Посмотреть изменения
git diff

# Отменить изменения в файле
git checkout -- имя_файла
```

## Лицензия

Проект создан для образовательных целей.
