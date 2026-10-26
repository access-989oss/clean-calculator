# Clean Calculator — Full Flutter Android App (Dart)

A modern, minimalist, and high-performance Calculator Android application built with **Flutter** and **Dart**.

---

## 📸 Key Features

- **Clean & Minimalist Modern UI**:
  - OLED Deep Dark Theme & Clean Light Theme.
  - Dynamic display font scaling: equations smoothly scale so numbers never clip or overflow.
  - Real-time calculation preview: dynamic answer displays underneath as you type.
  - Tactile touch feedback: scale animation on tap down, ripple effect, and Android vibration (`HapticFeedback.lightImpact()`).
- **Standard & Scientific Modes**:
  - **Basic Mode**: Addition (`+`), Subtraction (`−`), Multiplication (`×`), Division (`÷`), Percentage (`%`), Sign flip (`±`), Decimal, and Backspace (`⌫`) with long-press to Clear All (`AC`).
  - **Scientific Mode** (Smooth expandable drawer): `sin`, `cos`, `tan`, DEG/RAD toggle, `ln`, `log`, `π`, `e`, `xʸ`, `√`, `x²`, `1/x`, `|x|`, and parentheses `(` `)`.
- **Persistent Calculation History**:
  - Automatically saves calculations with timestamps using `shared_preferences`.
  - Modern bottom sheet drawer to review, reload, or clear history.
- **Pure Dart Math Engine**:
  - Built-in recursive-descent math parser (`math_parser.dart`) using `dart:math`.
  - Zero external math dependency conflicts; handles BODMAS operator precedence and error handling cleanly.

---

## 📂 Project Structure

```
flutter_clean_calculator/
├── pubspec.yaml                 # Dependencies and app metadata
├── README.md                    # Project documentation
├── android/                     # Android native platform configuration
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/AndroidManifest.xml
│   ├── build.gradle
│   └── settings.gradle
└── lib/
    ├── main.dart                # App entry point, system overlays & themes
    ├── models/
    │   └── history_item.dart    # Calculation history data model
    ├── controllers/
    │   └── calculator_controller.dart # State management & calculation actions
    ├── screens/
    │   └── calculator_screen.dart     # Main calculator view & layout
    ├── widgets/
    │   ├── calc_button.dart           # Interactive animated tactile button
    │   ├── display_area.dart          # Auto-scaling display & preview widget
    │   ├── scientific_panel.dart      # Expandable scientific keyboard
    │   └── history_bottom_sheet.dart  # Modal bottom sheet for history
    └── utils/
        ├── app_colors.dart            # Dark and light color palettes
        └── math_parser.dart           # Mathematical expression parser & evaluator
```

---

## 🛠️ How to Build & Run

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Run on Connected Android Device or Emulator
```bash
flutter run
```

### 3. Generate Release APK
To build a standalone installable Android APK file:
```bash
flutter build apk --release
```
The output APK will be generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 💻 Importing to Android Studio / VS Code
1. Open Android Studio or VS Code.
2. Select **Open Folder** and choose this directory:
   `/data/user/0/com.termux/files/home/.gemini/antigravity-cli/scratch/flutter_clean_calculator`
3. Hit **Run** (`F5`) or choose your Android target device.
