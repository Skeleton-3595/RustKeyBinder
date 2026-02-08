<div align="center">
  <h1>Rust Key Binder</h1>

  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![Platform](https://img.shields.io/badge/Platform-Windows-blue?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
  [![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

  <br>

  [![English](https://img.shields.io/badge/Language-English-blue?style=flat-square)](#english)
  [![Russian](https://img.shields.io/badge/Language-Русский-red?style=flat-square)](#russian)
</div>

<a name="english"></a>
# Rust Key Binder (English)

**Rust Key Binder** is a powerful and intuitive tool for managing key binds in the game Rust. Forget about manually entering complex console commands — create professional macros and configurations through a convenient visual interface.

## Key Features

### Visual Interface
*   **Interactive Keyboard**: Full keyboard layout with highlighting of assigned keys.
*   **Mouse Configuration**: Support for configuring all mouse buttons, including side buttons (M3, M4) and the scroll wheel.
*   **Beautiful Interface**: Pleasant dark theme to reduce eye strain.

### Powerful Bind Editor
*   **Command Chains**: Easily create complex combinations.
*   **Preset Library**: Built-in categories of useful commands:
    *   **Movement**: Auto Run, Infinite Crouch, Auto Swim, and others...
    *   **Combat**: Auto Attack, Zoom, Combat Log, and others...
    *   **Utility**: Fast Loot, Auto Upgrade, Teleport Home, Kit, and others...
*   **Smart Parameters**: Support for commands with variables (e.g., entering home name for `/home`).
*   **Cycle Mode**: Support for cyclic binds to create toggles.

### Advanced Features
*   **Game Tips**: Built-in support for `gametip.showtoast` to display notifications on the game screen when keys are pressed.
*   **Direct Editing**: Ability to edit or remove individual links in the command chain without recreating the entire bind.
*   **Automation**: The application automatically finds and edits the `keys.cfg` configuration file.

## Installation and Launch

To run the application, the **Flutter SDK** is required.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Skeleton-3595/RustKeyBinder.git
    ```

2.  **Navigate to the project folder:**
    ```bash
    cd rustkeybinder
    ```

3.  **Run the program (Windows):**
    ```bash
    flutter run -d windows
    ```

## User Guide

1.  **Loading Configuration**:
    *   On startup, the application attempts to automatically find the `keys.cfg` file in standard Steam paths.
    *   If the file is not found, specify the path manually using the folder button.

2.  **Creating a Bind**:
    *   Click on the desired key on the screen.
    *   In the window that opens, select presets from the list on the left.
    *   Added commands will appear in the "Active Command Chain" list.
    *   You can edit or remove individual commands in the list.
    *   Click **Save** to apply changes to the key.

3.  **Saving to Game**:
    *   After configuring all necessary keys, click the save button in the top right corner.
    *   Changes will be written directly to the game configuration file.

## Technologies

*   **Flutter** & **Dart**
*   **Material Design 3**
*   **Animate Do** (interface animations)

---

<a name="russian"></a>
# Rust Key Binder (Russian)

**Rust Key Binder** — это мощный и интуитивно понятный инструмент для управления биндами в игре Rust. Забудьте о ручном вводе сложных консольных команд — создавайте профессиональные макросы и настройки через удобный визуальный интерфейс.

## Основные возможности

### Визуальный Интерфейс
*   **Интерактивная клавиатура**: Полная раскладка клавиатуры с подсветкой уже занятых клавиш.
*   **Настройка мыши**: Поддержка настройки всех кнопок мыши, включая боковые (M3, M4) и колесико.
*   **Красивый интерфейс**: Приятная темная тема, снижающая нагрузку на глаза.

### Мощный Редактор Биндов
*   **Цепочки команд**: Легко создавайте сложные комбинации.
*   **Библиотека пресетов**: Встроенные категории полезных команд:
    *   **Movement**: Auto Run, Infinite Crouch, Auto Swim и другие...
    *   **Combat**: Auto Attack, Zoom, Combat Log и другие...
    *   **Utility**: Fast Loot, Auto Upgrade, Teleport Home, Kit и другие...
*   **Умные параметры**: Поддержка команд с переменными (например, ввод имени дома для `/home`).
*   **Режим переключения (Cycle)**: Поддержка цикличных биндов для создания переключателей.

### Продвинутые функции
*   **Game Tips**: Встроенная поддержка `gametip.showtoast` для вывода уведомлений на экран игры при нажатии клавиш.
*   **Прямое редактирование**: Возможность изменять или удалять отдельные звенья в цепочке команд без пересоздания всего бинда.
*   **Автоматизация**: Приложение само находит и редактирует файл конфигурации `keys.cfg`.

## Установка и Запуск

Для работы приложения требуется установленный **Flutter SDK**.

1.  **Склонируйте репозиторий:**
    ```bash
    git clone https://github.com/Skeleton-3595/RustKeyBinder.git
    ```

2.  **Перейдите в папку проекта:**
    ```bash
    cd rustkeybinder
    ```

3.  **Запустите программу (Windows):**
    ```bash
    flutter run -d windows
    ```

## Руководство пользователя

1.  **Загрузка конфигурации**:
    *   При запуске приложение попытается автоматически найти файл `keys.cfg` в стандартных путях Steam.
    *   Если файл не найден, укажите путь вручную через кнопку папки.

2.  **Создание бинда**:
    *   Нажмите на желаемую клавишу на экране.
    *   В открывшемся окне выберите пресеты из списка слева.
    *   Добавленные команды появятся в списке "Active Command Chain".
    *   Вы можете редактировать или удалять отдельные команды в списке.
    *   Нажмите **Save**, чтобы применить изменения к клавише.

3.  **Сохранение в игру**:
    *   После настройки всех необходимых клавиш нажмите кнопку сохранения в правом верхнем углу.
    *   Изменения будут записаны напрямую в файл конфигурации игры.

## Технологии

*   **Flutter** & **Dart**
*   **Material Design 3**
*   **Animate Do** (анимации интерфейса)
