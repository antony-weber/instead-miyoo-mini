# INSTEAD for Miyoo Mini / Miyoo Mini Plus (Onion OS)

[English](#english) | [Русский](#русский)

---

<a name="english"></a>
## English

A native port of the popular text-graphic quest and visual novel engine **[INSTEAD](https://instead-hub.github.io/)** (Simple Text Adventure, The Engine And Darkness) for **Miyoo Mini** and **Miyoo Mini Plus** handheld gaming consoles running **Onion OS**.

The engine allows playing hundreds of adventure games, text quests, parser adventures, and visual novels (including Space Rangers text quests, IF competition games, and translations).

Integrated as a **native OnionOS platform/emulator**:
- **OnionOS GameSwitcher**: Instant state switching with real-time screen capture on exit.
- **Isolated saves per game**: Saves are stored in separate directories (`appdata/<game_name>/`).
- **RAM-safe caching**: Archive extraction is cached directly to SD card to prevent low-memory OOM crashes.
- **Native OnionOS carousel art**: Includes 120×130 themed icons with focused active states and platform background art.

### 🎮 Handheld Controls

Controls have been adapted for convenient one- or two-handed handheld play:

| Miyoo Button | In-Game Action |
|---|---|
| **D-Pad** | Navigate between links / menu items / inventory items |
| **A / Start** | **Confirm / Action** (select link, inspect, use item, proceed) |
| **B** | **Switch Focus** between scene text and inventory (Back / Close menu) |
| **Select** | **Main Menu / Pause** (save, load, settings) |
| **X / Y** | **Cancel action** / Deselect item / Close dialog |
| **R2** | **Look / Examine** (contextual scene inspection) |
| **L1 / R1** | Scroll text page up / down (Page Up / Page Down) |
| **Menu (Center)** | **Save & Exit** (clean exit with autosave & GameSwitcher screenshot) |

### 📦 Installation

1. Download `INSTEAD-OnionOS.zip` from [Releases](https://github.com/antony-weber/instead-miyoo-mini/releases).
2. Extract the archive into the root of your SD card. It installs:
   - `Emu/INSTEAD/` (emulator engine, runtime libraries, and launcher)
   - `Icons/Default/instead.png` (carousel system icon)
   - `Roms/INSTEAD/` (games directory)
3. Insert the SD card into your console — **INSTEAD** will appear on your **Games / Consoles** carousel!

### 🎲 Adding Quests & Games

1. Download games from the official game repository:
   👉 **[instead-games.ru](https://instead-games.ru/)**
2. Supported formats:
   - Archive files: `.zip` or `.idf`
   - Extracted game directories (containing `main3.lua` or `main.lua`)
3. Place game files on your SD card into:
   ```text
   SDCARD/Roms/INSTEAD/
   ```
4. *(Optional)* Add boxart / cover images into:
   ```text
   SDCARD/Roms/INSTEAD/Imgs/<ROM_NAME>.png
   ```

### 🛠 Technical Highlights

- **GameSwitcher & Snapshot Pipeline**: Captures the exact 640×480 framebuffer before renderer destruction to `/tmp/screenshot.png` and syncs with OnionOS `.romScreens`.
- **Modular Platform Abstraction**: All Miyoo-specific hooks are isolated in `src/platform/miyoo.c` with zero impact on generic builds.
- **Sigmastar MMA Framebuffer Safety**: Fixed crash (`SIGSEGV` in `GFX_Copy`) caused by fading textures overflowing the hardware 640×480 memory layer.
- **Onion OS Audio Integration**: Configured DSP audio driver via Onion OS's `libpadsp.so` multiplexer with safe buffer size negotiation.

### 🔧 Building from Source

Build using cross-compilation for `arm-linux-gnueabihf` (ARMv7 Cortex-A7):

```bash
git clone https://github.com/antony-weber/instead-miyoo-mini.git
cd instead-miyoo-mini

mkdir build_miyoo && cd build_miyoo
cmake .. \
  -DCMAKE_C_COMPILER=arm-linux-gnueabihf-gcc \
  -DCMAKE_CXX_COMPILER=arm-linux-gnueabihf-g++ \
  -DWITH_LUAJIT=OFF \
  -DWITH_GTK2=OFF \
  -DWITH_GTK3=OFF \
  -DSTANDALONE=ON \
  -DTARGET_MIYOO=ON \
  -DCMAKE_BUILD_TYPE=Release

make -j$(nproc)
cd ..
./package_onion.sh
```

---

<a name="русский"></a>
## Русский

Нативный порт популярного интерпретатора текстографических квестов и визуальных новелл **[INSTEAD](https://instead-hub.github.io/)** (Simple Text Adventure, The Engine And Darkness) для портативных игровых консолей **Miyoo Mini** и **Miyoo Mini Plus** под управлением **Onion OS**.

Движок позволяет запускать сотни русскоязычных и зарубежных квестов (включая текстовые квесты Космических Рейнджеров, игры с конкурсов КРИЛ, визуальные новеллы и парсерные приключения).

Интегрирован как **нативная платформа/эмулятор OnionOS**:
- **OnionOS GameSwitcher**: Мгновенное переключение между играми с сохранением живых карточек экрана.
- **Изоляция сохранений**: Сейвы каждого квеста хранятся в изолированной папке (`appdata/<имя_квеста>/`).
- **Защита от переполнения RAM**: Распаковка квестов кешируется на SD-карту во избежание падений из-за маленького RAM-диска `/tmp`.
- **Нативные системные ассеты**: Иконки 120×130 в стилистике OnionOS Default (обычное и активное состояние с подсветкой) и фоновый арт платформы.

### 🎮 Управление на консоли

Управление оптимизировано для удобной игры одной или двумя руками без мыши:

| Кнопка Miyoo | Действие в игре |
|---|---|
| **D-Pad (Крестовина)** | Перемещение между ссылками / пунктами меню / предметами |
| **A / Start** | **Подтверждение / Действие** (переход по ссылке, осмотр, применить предмет) |
| **B** | **Переключение фокуса** между текстом сцены и инвентарём (в меню — возврат) |
| **Select** | **Главное меню / Пауза** (сохранение, загрузка, настройки) |
| **X / Y** | **Отмена действия** / Снять выбор предмета / Закрыть диалог |
| **R2** | **Осмотреться / Контекст** (команда «Осмотреться» в квесте) |
| **L1 / R1** | Прокрутка текста на страницу вверх / вниз (Page Up / Page Down) |
| **Menu (Центральная)** | **Выход с сохранением** (автосохранение и скриншот для GameSwitcher) |

### 📦 Установка

1. Скачайте архив `INSTEAD-OnionOS.zip` со страницы [Releases](https://github.com/antony-weber/instead-miyoo-mini/releases).
2. Распакуйте архив в корень вашей SD-карты консоли. Он установит:
   - `Emu/INSTEAD/` (движок, библиотеки, скрипт запуска и темы)
   - `Icons/Default/instead.png` (иконка в карусели систем)
   - `Roms/INSTEAD/` (каталог для квестов)
3. Вставьте SD-карту в консоль — **INSTEAD** появится в меню выбора игровых систем!

### 🎲 Добавление квестов и игр

1. Скачайте любые понравившиеся игры с официального каталога:
   👉 **[instead-games.ru](https://instead-games.ru/)**
2. Поддерживаемые форматы:
   - Файлы архивов: `.zip` или `.idf`
   - Папки квестов (содержащие `main3.lua` или `main.lua`)
3. Скопируйте файлы квестов на SD-карту в папку:
   ```text
   SDCARD/Roms/INSTEAD/
   ```
4. *(Опционально)* Обложки квестов можно положить в:
   ```text
   SDCARD/Roms/INSTEAD/Imgs/<ИМЯ_РОМА>.png
   ```

### 🛠 Особенности порта и исправления

- **Интеграция с GameSwitcher**: Гарантированный захват кадра 640×480 из фреймбуфера перед завершением процесса и синхронизация с системным кешем `.romScreens`.
- **Изоляция платформенного кода**: Все платформенные хуки вынесены в `src/platform/miyoo.c`, ядро INSTEAD сохраняет 100% совместимость с апстримом.
- **Поддержка Sigmastar MMA Framebuffer**: Устранён фатальный сбой памяти (`SIGSEGV` в `GFX_Copy`) при анимации смены экранов на 640×480 IPS-дисплее.
- **Звук и музыка в Onion OS**: Интеграция с DSP-драйвером через `libpadsp.so` с безопасными размерами аудио-буферов.

---

## Лицензия / License

Проект распространяется под свободной лицензией **MIT License** в соответствии с оригинальным движком INSTEAD (автор: Пётр Косых / Peter Kosyh). См. файл [COPYING](COPYING).
