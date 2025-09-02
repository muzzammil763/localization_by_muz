![Localization by Muz banner](assets/banner.svg)

# Localization by Muz
 
 A simple Flutter package for easy JSON-based localization. No extra commands, no code generation - just add the package and start localizing!
 
## Features

- **JSON-based Localization**: Use a simple JSON file for organized translations
- **Parameter Interpolation**: Support for dynamic text with placeholders like `{name}` via args map
- **Number/Date Formatting**: Built-in helpers for formatting numbers, currencies, percentages, dates, and times with locale support
- **Namespaces/Dotted Keys**: Support for nested JSON structures and dotted key notation (e.g., `user.profile.name`)
- **Instant Language Switching**: Change languages instantly without app restart
- **No Code Generation**: No need for build runner or code generation commands
- **Simple Setup**: Just add the package and start using

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  localization_by_muz: ^2.0.0
```

## Usage

### JSON-based Localization

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

3. Initialize LocalizationManager and use in your Flutter app:

```dart
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the localization manager
  await LocalizationManager.initialize(
    defaultLocale: 'en',
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
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

### Parameter Interpolation

Support for dynamic text with placeholders using JSON-based translations:

```dart
// In localization.json:
// {
//   "userWelcome": {
//     "en": "Welcome back, {username}!",
//     "fr": "Bon retour, {username}!",
//     "es": "¡Bienvenido de vuelta, {username}!"
//   },
//   "greeting": {
//     "en": "Hello {name}, welcome to {app}!",
//     "fr": "Bonjour {name}, bienvenue dans {app}!",
//     "es": "¡Hola {name}, bienvenido a {app}!"
//   }
// }

// Use localizeArgs for translations with parameters
Text("userWelcome".localizeArgs(
  args: {"username": "Alice"}
))

Text("greeting".localizeArgs(
  args: {
    "name": "John",
    "app": "My App"
  }
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





## Complete Working Example

Here's a complete example showing language selection and switching:

```dart
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await LocalizationManager.initialize(
    defaultLocale: 'en',
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      child: MaterialApp(
        title: 'appTitle'.localize(),
        home: LanguageSelectionScreen(),
      ),
    );
  }
}

class LanguageSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'es', 'name': 'Spanish'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('selectLanguage'.localize()),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          return ListTile(
            title: Text(language['name']!),
            onTap: () {
              LocalizationProvider.setLocale(context, language['code']!);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'languageChangedTo'.localizeArgs(
                      args: {'language': language['name']!}
                    )
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

With corresponding `localization.json`:

```json
{
  "appTitle": {
    "en": "Localization Demo",
    "fr": "Démo de Localisation",
    "es": "Demo de Localización"
  },
  "selectLanguage": {
    "en": "Select Language",
    "fr": "Sélectionner la langue",
    "es": "Seleccionar idioma"
  },
  "languageChangedTo": {
    "en": "Language changed to {language}",
    "fr": "Langue changée en {language}",
    "es": "Idioma cambiado a {language}"
  }
}
```

## Features Breakdown

- **JSON-based localization**: Simple JSON file approach for organized translations
- **Parameter interpolation**: Dynamic text with `{placeholder}` support via `.localizeArgs(args: {...})`
- **Number/date formatting**: Built-in locale-aware formatting for numbers, currencies, percentages, dates, and times
- **Namespaces/dotted keys**: Support for nested JSON structures and dotted key notation for better organization
- **Missing key diagnostics**: Track missing translation keys for debugging
- **Instant updates**: Language changes reflect immediately in the UI without app restart
- **Zero configuration**: No build runner or code generation required
- **Simple API**: Just use `.localize()` for simple text and `.localizeArgs()` for parameterized text
- **Fallback support**: If translation not found, returns the key as fallback text
- **Provider pattern**: Efficient state management using Flutter's provider pattern
- **Easy initialization**: Simple async initialization in main() function

## Additional Information

This package is designed to make Flutter localization as simple as possible using JSON-based translations. Perfect for projects of any size that need organized, maintainable localization.

For issues and feature requests, please visit our GitHub repository.

## Author

**Muzamil Ghafoor**

- GitHub: [@muzzammil763](https://github.com/muzzammil763)

---

Made By Muzamil Ghafoor With ❤️ For The Flutter Developers To Make Localization Easy