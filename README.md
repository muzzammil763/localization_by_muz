![Localization by Muz banner](assets/banner.svg)

# Localization by Muz
 
 A simple Flutter package for easy localization with inline text support and JSON-based translations. No extra commands, no code generation - just add the package and start localizing!
 
## Features

- **Navigation Preservation**: Navigation stack is preserved when changing locale - no more losing your place in the app!
- **Animated Localized Text**: Smooth animated transitions when locale changes with 5 animation types (rotation, scale, fade, slide, 3D rotation)
- **Locale Persistence**: Automatically save and restore selected locale across app restarts using SharedPreferences
- **Inline Localization**: Use `.localize()` method directly on strings with inline translations
- **JSON-based Localization**: Use a simple JSON file for organized translations
- **Parameter Interpolation**: Support for dynamic text with placeholders like `{name}` via args map
- **Number/Date Formatting**: Built-in helpers for formatting numbers, currencies, percentages, dates, and times with locale support
- **Namespaces/Dotted Keys**: Support for nested JSON structures and dotted key notation (e.g., `user.profile.name`)
- **Custom Asset Loading**: Pluggable asset loaders including per-locale files and composite strategies
- **Instant Language Switching**: Change languages instantly without app restart
- **No Code Generation**: No need for build runner or code generation commands
- **Simple Setup**: Just add the package and start using

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  localization_by_muz: ^1.0.6
```

## Usage

### Method 1: Inline Localization

```dart
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      defaultLocale: 'en',
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World!".localize({
          "en": "Hello World!",
          "fr": "Bonjour le monde!",
          "es": "¡Hola Mundo!"
        })),
      ),
      body: Column(
        children: [
          Text("Welcome".localize({
            "en": "Welcome",
            "fr": "Bienvenue",
            "es": "Bienvenido"
          })),
          ElevatedButton(
            onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
            child: Text("Switch to French"),
          ),
          ElevatedButton(
            onPressed: () => LocalizationProvider.setLocale(context, 'en'),
            child: Text("Switch to English"),
          ),
        ],
      ),
    );
  }
}
```

### Method 2: JSON-based Localization

1. Create a `localization.json` file in your `lib/` directory (required path for this package):

```json
{
  "helloWorld": {
    "en": "Hello World",
    "fr": "Bonjour Le Monde",
    "es": "Hola Mundo"
  },
  "welcome": {
    "en": "Welcome", 
    "fr": "Bienvenue",
    "es": "Bienvenido"
  },
  "goodbye": {
    "en": "Goodbye",
    "fr": "Au revoir", 
    "es": "Adiós"
  }
}
```

2. Add it to your app's `pubspec.yaml` assets so Flutter bundles it:

```yaml
flutter:
  assets:
    - lib/localization.json
```

> Note: The package reads from `lib/localization.json` via `rootBundle`. Keep this exact path and add it to assets as shown above.

3. Use in your Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      defaultLocale: 'en',
      child: MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("helloWorld".localize()),
      ),
      body: Column(
        children: [
          Text("welcome".localize()),
          Text("goodbye".localize()),
          ElevatedButton(
            onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
            child: Text("Switch to French"),
          ),
          ElevatedButton(
            onPressed: () => LocalizationProvider.setLocale(context, 'es'),
            child: Text("Switch to Spanish"),
          ),
        ],
      ),
    );
  }
}
```

### Language Switching

To change the language instantly:

```dart
LocalizationProvider.setLocale(context, 'fr'); // Switch to French
LocalizationProvider.setLocale(context, 'en'); // Switch to English
LocalizationProvider.setLocale(context, 'es'); // Switch to Spanish
```

The UI will update instantly without requiring app restart or refresh!

### Animated Localized Text

New in v1.0.5! Use `AnimatedLocalizedText` for smooth animated transitions when locale changes:

```dart
import 'package:localization_by_muz/localization_by_muz.dart';

// Basic animated text with rotation transition (default)
AnimatedLocalizedText(
  'welcome',
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
)

// Different animation types
AnimatedLocalizedText(
  'hello',
  transition: AnimatedLocalizedTextTransition.scale,
  duration: Duration(milliseconds: 500),
)

AnimatedLocalizedText(
  'goodbye',
  transition: AnimatedLocalizedTextTransition.fade,
  duration: Duration(milliseconds: 300),
)

AnimatedLocalizedText(
  'title',
  transition: AnimatedLocalizedTextTransition.slide,
  duration: Duration(milliseconds: 400),
)

AnimatedLocalizedText(
  'header',
  transition: AnimatedLocalizedTextTransition.rotation3D,
  duration: Duration(milliseconds: 600),
)

// With inline translations
AnimatedLocalizedText(
  'welcome',
  translations: {
    'en': 'Welcome!',
    'fr': 'Bienvenue!',
    'es': '¡Bienvenido!'
  },
  transition: AnimatedLocalizedTextTransition.rotation,
  style: TextStyle(fontSize: 20),
)
```

**Available Animation Types:**
- `rotation` - Rotates text during transition (default)
- `scale` - Scales text in/out during transition
- `fade` - Fades text in/out during transition
- `slide` - Slides text horizontally during transition
- `rotation3D` - 3D Y-axis rotation effect during transition

**Features:**
- Smooth animations when locale changes
- Customizable animation duration
- Support for all text styling options
- Works with both JSON-based and inline translations
- Automatic RTL text direction support
- Backward compatible with existing `LocalizedText` widget

### Parameter Interpolation

Support for dynamic text with placeholders:

```dart
// Inline translations with parameters
Text("greeting".localizeArgs(
  translations: {
    "en": "Hello {name}, welcome to {app}!",
    "fr": "Bonjour {name}, bienvenue dans {app}!",
    "es": "¡Hola {name}, bienvenido a {app}!"
  },
  args: {
    "name": "John",
    "app": "My App"
  }
))

// JSON-based translations with parameters
// In localization.json:
// {
//   "userWelcome": {
//     "en": "Welcome back, {username}!",
//     "fr": "Bon retour, {username}!"
//   }
// }

Text("userWelcome".localizeArgs(
  args: {"username": "Alice"}
))
```

### Number and Date Formatting

The package includes built-in formatting helpers for numbers, currencies, percentages, dates, and times with locale-aware formatting:

```dart
import 'package:localization_by_muz/localization_by_muz.dart';

// Number formatting
String formattedNumber = FormattingHelpers.formatNumber(1234.56, 'en'); // "1,234.56"
String germanNumber = FormattingHelpers.formatNumber(1234.56, 'de'); // "1.234,56"
String frenchNumber = FormattingHelpers.formatNumber(1234.56, 'fr'); // "1 234,56"

// Currency formatting
String usdAmount = FormattingHelpers.formatCurrency(1234.56, 'en', 'USD'); // "$1,234.56"
String euroAmount = FormattingHelpers.formatCurrency(1234.56, 'de', 'EUR'); // "1.234,56 €"

// Percentage formatting
String percentage = FormattingHelpers.formatPercentage(0.1234, 'en'); // "12.3%"
String germanPercent = FormattingHelpers.formatPercentage(0.1234, 'de'); // "12,3 %"

// Date formatting
String usDate = FormattingHelpers.formatDate(DateTime.now(), 'en'); // "12/25/2023"
String germanDate = FormattingHelpers.formatDate(DateTime.now(), 'de'); // "25.12.2023"
String customDate = FormattingHelpers.formatDate(DateTime.now(), 'en', pattern: 'yyyy-MM-dd'); // "2023-12-25"

// Time formatting
String usTime = FormattingHelpers.formatTime(DateTime.now(), 'en'); // "3:30 PM"
String germanTime = FormattingHelpers.formatTime(DateTime.now(), 'de'); // "15:30"
```

**Optional Intl Integration**: The formatting helpers are designed with a feature flag (`kUseIntlFormatting`) that can be enabled to use the `intl` package for more advanced formatting when needed.

### Namespaces and Dotted Keys

Support for nested JSON structures and dotted key notation for better organization:

```json
{
  "user": {
    "profile": {
      "name": {
        "en": "Name",
        "fr": "Nom",
        "es": "Nombre"
      },
      "email": {
        "en": "Email Address",
        "fr": "Adresse e-mail",
        "es": "Dirección de correo"
      }
    },
    "settings": {
      "theme": {
        "en": "Theme",
        "fr": "Thème",
        "es": "Tema"
      }
    }
  },
  "app": {
    "title": {
      "en": "My Application",
      "fr": "Mon Application",
      "es": "Mi Aplicación"
    }
  }
}
```

Use dotted notation to access nested translations:

```dart
// Access nested translations using dotted keys
Text("user.profile.name".localize()), // "Name" (in English)
Text("user.profile.email".localize()), // "Email Address"
Text("user.settings.theme".localize()), // "Theme"
Text("app.title".localize()), // "My Application"

// Also works with parameter interpolation
Text("user.welcome.message".localizeArgs(
  args: {"username": "John"}
)), // If the nested key contains "Welcome back, {username}!"
```

**Backward Compatibility**: The package still supports flat key structures, so existing implementations continue to work without changes.

### Custom Asset Loading

Use different asset loading strategies:

```dart
// Per-locale files (assets/i18n/en.json, fr.json, etc.)
LocalizationProvider(
  defaultLocale: 'en',
  assetLoader: PerLocaleAssetLoader(basePath: 'assets/i18n'),
  child: MyApp(),
)

// Composite loading (combine multiple loaders)
LocalizationProvider(
  defaultLocale: 'en',
  assetLoader: CompositeAssetLoader([
    DefaultAssetLoader(),
    PerLocaleAssetLoader(basePath: 'assets/i18n'),
  ]),
  child: MyApp(),
)
```

### Missing Key Diagnostics

Track and debug missing translation keys:

```dart
// Enable logging and debug overlay
LocalizationProvider(
  defaultLocale: 'en',
  enableMissingKeyLogging: true,
  showDebugOverlay: true, // Only works in debug mode
  onMissingKey: (key, locale) {
    print('Missing key: $key for locale: $locale');
    // Send to analytics, log to file, etc.
  },
  child: MyApp(),
)

// Configure at runtime
LocalizationManager.instance.configureMissingKeyDiagnostics(
  enableLogging: true,
  onMissingKey: (key, locale) {
    // Handle missing keys
  },
);

// Access missing keys
Set<String> missingKeys = LocalizationManager.instance.missingKeys;

// Clear tracked missing keys
LocalizationManager.instance.clearMissingKeys();
```

### Hot-reload Translations (Debug Mode)

Enable automatic reloading of translations during development for faster iteration:

```dart
LocalizationProvider(
  defaultLocale: 'en',
  enableHotReload: true, // Enable hot-reload in debug mode
  child: MyApp(),
)
```

**Features:**
- **Debug-only**: Hot-reload only works in debug mode for performance
- **Automatic detection**: Checks for translation changes every 2 seconds
- **Live updates**: UI updates automatically when translations change
- **Error handling**: Gracefully handles asset loading failures
- **Performance optimized**: Only reloads when actual changes are detected

**How it works:**
```dart
// Hot-reload is automatically enabled when:
// 1. enableHotReload: true is set
// 2. App is running in debug mode
// 3. Asset loader is available

// Console output when hot-reload is active:
// 🔥 Hot-reload enabled for translations (checking every 2 seconds)
// 🔄 Translation changes detected, reloading...
// ✅ Translations reloaded successfully
```

**Note:** Hot-reload requires your translations to be loaded from assets. It works with all asset loaders including `DefaultAssetLoader`, `PerLocaleAssetLoader`, and custom implementations.

## Features Breakdown

- **Animated localized text**: Smooth transitions with 5 animation types (rotation, scale, fade, slide, 3D rotation) when locale changes
- **Locale persistence**: Automatic saving and restoring of selected locale across app restarts using SharedPreferences
- **Two localization methods**: Choose between inline translations or JSON file approach
- **Parameter interpolation**: Dynamic text with `{placeholder}` support via `.localizeArgs(args: {...})`
- **Number/date formatting**: Built-in locale-aware formatting for numbers, currencies, percentages, dates, and times
- **Namespaces/dotted keys**: Support for nested JSON structures and dotted key notation for better organization
- **Custom asset loading**: Pluggable loaders (DefaultAssetLoader, PerLocaleAssetLoader, CompositeAssetLoader, MemoryAssetLoader)
- **Missing key diagnostics**: Toggleable logs, `onMissingKey` callback, optional debug overlay
- **Hot-reload translations**: Automatic translation reloading in debug mode for faster development
- **Instant updates**: Language changes reflect immediately in the UI
- **Zero configuration**: No build runner or code generation required
- **Simple API**: Just use `.localize()` on any string
- **Fallback support**: If translation not found, returns original text
- **Provider pattern**: Efficient state management using Flutter's provider pattern

## Additional Information

This package is designed to make Flutter localization as simple as possible. Whether you prefer inline translations for small projects or JSON files for larger applications, this package has you covered.

For issues and feature requests, please visit our GitHub repository.

## Author

**Muzamil Ghafoor**

- GitHub: [@muzzammil763](https://github.com/muzzammil763)

---

Made By Muzamil Ghafoor With ❤️ For The Flutter Developers To Make Localization Easy