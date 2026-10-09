# INSTEAD for Miyoo Mini / Miyoo Mini Plus (Onion OS)

[English](#english) | [Русский](#русский)

---

<a name="english"></a>
## English

A port of the popular text-graphic quest and visual novel engine **[INSTEAD](https://instead-hub.github.io/)** (Simple Text Adventure, The Engine And Darkness) for **Miyoo Mini** and **Miyoo Mini Plus** handheld gaming consoles running **Onion OS**.

The engine allows playing hundreds of adventure games, text quests, parser adventures, and visual novels (including Space Rangers text quests, IF competition games, and translations).

### 🎮 Handheld Controls

Controls have been adapted for convenient one- or two-handed handheld play without requiring a mouse:

| Miyoo Button | In-Game Action |
|---|---|
| **D-Pad** | Navigate between links / menu items / inventory items |
| **A / Start** | **Confirm / Action** (select link, inspect, use item, proceed) |
| **B / L2** | **Switch Focus** between scene text and inventory (Back / Close menu) |
| **Select** | **Main Menu / Pause** (save, load, settings) |
| **X / R2** | **Cancel action** / Deselect item / Close dialog |
| **L1 / R1** | Scroll text page up / down (Page Up / Page Down) |
| **Menu (Center)** | **Save & Exit** (clean exit with autosave) |

### 📦 Installation

#### Quick Install (Pre-built Release):

1. Download `INSTEAD-Miyoo.zip` from [Releases](https://github.com/antony-weber/instead-miyoo-mini/releases).
2. Extract the archive into the root of your SD card (it will place files into `/App/INSTEAD/`).
3. Insert the SD card into your console — **INSTEAD** will appear in the **Apps** section.

#### Adding Games:

1. Download games from the official game repository:
   👉 **[instead-games.ru](https://instead-games.ru/)**
2. Games are distributed as `.zip` or `.idf` files.
3. Extract the game folder onto your SD card at:
   ```text
   SDCARD/App/INSTEAD/games/<game_folder>/
   ```
   *(Ensure `main3.lua` or `main.lua` is present in `<game_folder>`)*.
4. Launch INSTEAD on your console — the newly added game will appear in the game selection menu.

### 🛠 Technical Highlights

- **Sigmastar MMA Framebuffer Safety**: Fixed crash (`SIGSEGV` in `GFX_Copy`) caused by fading textures overflowing the hardware 640×480 memory layer.
- **Onion OS Audio Integration**: Configured DSP audio driver via Onion OS's `libpadsp.so` multiplexer with automatic safe buffer size fallback.
- **640×480 Display Scaling**: Automatic scaling of themes and relative resource paths for the 3.5" IPS display.
- **Built-in Fonts**: Full Cyrillic and Latin typography support across themes.

### 🔧 Building from Source

Build using cross-compilation for `arm-linux-gnueabihf` (ARMv7 Cortex-A7):

```bash
git clone -b miyoo-mini https://github.com/antony-weber/instead-miyoo-mini.git
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
```

The resulting binary `src/sdl-instead` will be optimized specifically for Miyoo Mini.

---

<a name="русский"></a>
## Русский

Порт популярного интерпретатора текстографических квестов и визуальных новелл **[INSTEAD](https://instead-hub.github.io/)** (Simple Text Adventure, The Engine And Darkness) для портативных игровых консолей **Miyoo Mini** и **Miyoo Mini Plus** под управлением **Onion OS**.

Движок позволяет запускать сотни русскоязычных и зарубежных квестов (включая текстовые квесты Космических Рейнджеров, игры с конкурсов КРИЛ, визуальные новеллы и парсерные приключения).

### 🎮 Управление на консоли

Управление оптимизировано для удобной игры одной или двумя руками без необходимости в мыши:

| Кнопка Miyoo | Действие в игре |
|---|---|
| **D-Pad (Крестовина)** | Перемещение между ссылками / пунктами меню / предметами |
| **A / Start** | **Подтверждение / Действие** (переход по ссылке, осмотр, применить предмет) |
| **B / L2** | **Переключение фокуса** между текстом сцены и инвентарём (в меню — возврат назад) |
| **Select** | **Главное меню / Пауза** (сохранение, загрузка, настройки) |
| **X / R2** | **Отмена действия** / Снять выбор предмета / Закрыть диалог |
| **L1 / R1** | Прокрутка текста на страницу вверх / вниз (Page Up / Page Down) |
| **Menu (Центральная)** | **Выход с сохранением** (быстрое автосохранение и чистый выход) |

### 📦 Установка

#### Быстрая установка (Готовый релиз):

1. Скачайте архив `INSTEAD-Miyoo.zip` со страницы [Releases](https://github.com/antony-weber/instead-miyoo-mini/releases).
2. Распакуйте архив в корень вашей SD-карты консоли (содержимое попадёт в `/App/INSTEAD/`).
3. Вставьте SD-карту в консоль — иконка **INSTEAD** появится в разделе **Apps (Приложения)**.

#### Как добавлять квесты и игры:

1. Скачайте любые понравившиеся игры с официального каталога:
   👉 **[instead-games.ru](https://instead-games.ru/)**
2. Игры распространяются в архивах `.zip` или `.idf`.
3. Распакуйте папку с игрой на SD-карте по пути:
   ```text
   SDCARD/App/INSTEAD/games/<папка_с_игрой>/
   ```
   *(Внутри папки игры должен лежать файл `main3.lua` или `main.lua`)*.
4. Запустите INSTEAD на консоли — новая игра появится в списке выбора игр меню.

### 🛠 Особенности порта и исправления

- **Поддержка Sigmastar MMA Framebuffer**: Устранён фатальный сбой памяти (`SIGSEGV` в `GFX_Copy`), возникавший при анимации смены экранов (fading) на аппаратном слое 640×480 консоли.
- **Звук и музыка в Onion OS**: Настроена интеграция с DSP-драйвером через библиотеку `libpadsp.so` Onion OS с автоматическим подбором безопасных размеров звуковых буферов SDL_mixer.
- **Адаптация интерфейса 640×480**: Автоматическое масштабирование тем оформления и относительных путей ресурсов под нативный экран 3.5" IPS.
- **Встроенные шрифты**: Корректный рендеринг кириллицы в темах оформления.

---

## Лицензия / License

Проект распространяется под свободной лицензией **MIT License** в соответствии с оригинальным движком INSTEAD (автор: Пётр Косых / Peter Kosyh). См. файл [COPYING](COPYING).
