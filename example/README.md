# Localization Example App

This example app demonstrates the full capabilities of the `localization_by_muz` package, showing both inline and JSON-based localization methods.

## Features Demonstrated

### 🌍 Two Localization Methods
1. **Inline Localization**: Define translations directly in code
2. **JSON Localization**: Use a centralized JSON file for translations

### 📱 Supported Platforms
- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

### 🗣️ Multiple Languages
- English (🇺🇸)
- French (🇫🇷)
- Spanish (🇪🇸)
- German (🇩🇪)
- Arabic (🇸🇦)

## App Structure

### Screens

1. **Home Screen** (`lib/screens/home_screen.dart`)
   - Navigation hub with feature cards
   - Demonstrates both inline and JSON localization
   - Language switcher in app bar

2. **Inline Example Screen** (`lib/screens/inline_example_screen.dart`)
   - Shows inline localization syntax
   - Interactive counter with localized text
   - Real-time language switching
   - Demonstrates pluralization handling

3. **JSON Example Screen** (`lib/screens/json_example_screen.dart`)
   - Uses JSON file for translations
   - Shows clean `.localize()` syntax
   - Code examples included

4. **Language Selection Screen** (`lib/screens/language_selection_screen.dart`)
   - Interactive language picker
   - Shows current language
   - Instant switching with visual feedback

5. **About Screen** (`lib/screens/about_screen.dart`)
   - Package information
   - Feature list
   - Usage examples

### Key Files

- `lib/main.dart` - App entry point with LocalizationProvider
- `lib/localization.json` - JSON translations file
- `lib/screens/` - All app screens

## Running the App

### Prerequisites
- Flutter SDK 3.0.0+
- Dart 3.0.0+

### Commands

```bash
# Get dependencies
flutter pub get

# Run on your preferred platform
flutter run                    # Default platform
flutter run -d chrome          # Web
flutter run -d macos          # macOS
flutter run -d windows        # Windows
flutter run -d linux          # Linux

# Build for production
flutter build apk             # Android APK
flutter build ios             # iOS
flutter build web             # Web
flutter build windows         # Windows
flutter build macos           # macOS
flutter build linux           # Linux
```

## Usage Examples

### Inline Localization
```dart
Text("Hello World!".localize({
  "en": "Hello World!",
  "fr": "Bonjour le monde!",
  "es": "¡Hola Mundo!",
  "de": "Hallo Welt!",
  "ar": "مرحبا بالعالم"
}))
```

### JSON Localization
```dart
// 1. Add to lib/localization.json
{
  "greeting": {
    "en": "Hello",
    "fr": "Bonjour",
    "es": "Hola"
  }
}

// 2. Use in your code
Text("greeting".localize())
```

### Language Switching
```dart
// Change language instantly
LocalizationProvider.setLocale(context, 'fr');
```

## Features Highlighted

### ✨ Instant Language Switching
- No app restart required
- All text updates immediately
- Smooth user experience

### 🎯 Easy Implementation
- No code generation needed
- No build runner required
- Simple `.localize()` method

### 📦 Flexible Usage
- Choose inline or JSON approach
- Mix both methods in same app
- Fallback to original text if translation missing

### 🌐 Unicode Support
- Supports all Unicode characters
- Right-to-left languages (Arabic)
- Special characters and emojis

### 📱 Widget Integration
- Works with all Flutter widgets
- Provider pattern for state management
- Automatic UI rebuilds

## Testing the App

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

## Project Structure

```
example/
├── android/                 # Android platform files
├── ios/                    # iOS platform files  
├── web/                    # Web platform files
├── windows/                # Windows platform files
├── macos/                  # macOS platform files
├── linux/                  # Linux platform files
├── lib/
│   ├── main.dart          # App entry point
│   ├── localization.json  # JSON translations
│   └── screens/           # App screens
│       ├── home_screen.dart
│       ├── inline_example_screen.dart
│       ├── json_example_screen.dart
│       ├── language_selection_screen.dart
│       └── about_screen.dart
├── test/                   # Widget tests
├── pubspec.yaml           # Dependencies
└── README.md              # This file
```

## Learn More

- [Package Documentation](../README.md)
- [API Reference](../lib/)
- [Test Suite](../test/)

This example app serves as both a demonstration and a template for implementing localization in your own Flutter applications using the `localization_by_muz` package.