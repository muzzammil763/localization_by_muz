## 2.1.0

**Major Improvements:**

- **Simplified Setup**: No longer requires wrapping individual screens with `LocalizedBuilder` - just wrap your `MaterialApp` once
- **Automatic Rebuilding**: All localized text automatically updates when language changes without manual wrapping
- **Enhanced LocalizationProvider**: Improved to force complete widget tree rebuilds on locale changes using `KeyedSubtree`
- **Better User Experience**: Instant language switching across the entire app with minimal setup
- **Updated Documentation**: Complete rewrite of README with correct, simplified usage instructions
- **Migration Guide**: Added clear migration path from older versions that required per-screen wrapping
- **Working Examples**: All README examples are verified to work correctly with instant language switching

**API Changes:**

- `LocalizationProvider` now automatically handles rebuilding without requiring `LocalizedBuilder` on each screen
- Recommended pattern: Wrap `MaterialApp` with `LocalizedBuilder` once instead of wrapping individual screens
- All existing APIs remain backward compatible

**Example Migration:**

```dart
// Old approach (still works but not recommended)
class MyScreen extends StatelessWidget {
  Widget build(context) {
    return LocalizedBuilder(  // ❌ No longer needed on each screen
      builder: (context, locale) => Scaffold(...)
    );
  }
}

// New simplified approach  
class MyApp extends StatelessWidget {
  Widget build(context) {
    return LocalizationProvider(
      child: LocalizedBuilder(  // ✅ Wrap MaterialApp once
        builder: (context, locale) => MaterialApp(...)
      )
    );
  }
}
```

**Documentation:**

- Updated all examples to show the simplified one-time setup
- Added complete working localization.json examples
- Enhanced feature descriptions to highlight automatic rebuilding
- Added troubleshooting and migration sections

## 2.0.0

**BREAKING CHANGES:**

- **Removed inline translation support**: The `translations` parameter has been removed from `LocalizedText` and `AnimatedLocalizedText` widgets. Use JSON-based localization exclusively.
- **Removed deprecated LocalizationManager parameters**: 
  - `enableMissingKeyLogging` parameter removed from `LocalizationManager.initialize()`
  - `onMissingKey` callback parameter removed from `LocalizationManager.initialize()`
- **Removed deprecated LocalizationProvider parameters**:
  - `defaultLocale` parameter removed from `LocalizationProvider` constructor
  - `showDebugOverlay` parameter removed from `LocalizationProvider` constructor
  - `enableMissingKeyLogging` parameter removed from `LocalizationProvider` constructor
  - `onMissingKey` parameter removed from `LocalizationProvider` constructor
- **Removed unused internal methods**: `_translationsEqual` method removed from LocalizationManager
- **Removed debug overlay functionality**: Complete removal of `MissingKeyDebugOverlay` widget and all related debug overlay features

**Migration Guide:**

1. **Update LocalizationManager initialization**:
   ```dart
   // Before (v1.x)
   LocalizationProvider(
     defaultLocale: 'en',
     showDebugOverlay: true,
     enableMissingKeyLogging: true,
     child: MyApp(),
   )
   
   // After (v2.0)
   void main() async {
     await LocalizationManager.initialize(
       defaultLocale: 'en',
       showDebugOverlay: true,
     );
     runApp(MyApp());
   }
   
   LocalizationProvider(
     child: MyApp(),
   )
   ```

2. **Replace inline translations with JSON keys**:
   ```dart
   // Before (v1.x)
   LocalizedText(
     "greeting",
     translations: {
       "en": "Hello {name}!",
       "fr": "Bonjour {name}!"
     },
     args: {"name": "John"}
   )
   
   // After (v2.0) - Add to localization.json:
   // {
   //   "greeting": {
   //     "en": "Hello {name}!",
   //     "fr": "Bonjour {name}!"
   //   }
   // }
   LocalizedText(
     "greeting",
     args: {"name": "John"}
   )
   ```

**Improvements:**
- Simplified API with consistent JSON-based approach
- Updated documentation with complete working examples
- Enhanced package description to reflect JSON-only localization
- Improved example app demonstrating best practices

## 1.0.6

- Fix navigation stack reset issue when changing locale by removing KeyedSubtree from LocalizationProvider
- Improve AnimatedLocalizedText property naming for better consistency
- Enhance navigation preservation during locale changes for better user experience
- Update test coverage for navigation preservation scenarios
- Maintain backward compatibility with existing localization functionality

## 1.0.5

- Add `AnimatedLocalizedText` widget with smooth transition animations for locale changes
- Add `AnimatedLocalizedTextTransition` enum with 5 animation types: rotation, scale, fade, slide, and 3D Y-axis rotation
- Add locale persistence using `SharedPreferences` to maintain selected locale across app restarts
- Add comprehensive test coverage for animated widgets and locale persistence
- Update RTL demo screen to showcase animated locale switching functionality
- Maintain backward compatibility with existing `LocalizedText` widget
- Enhanced user experience with instant animated feedback on locale changes

## 1.0.4

- Add number and date formatting helpers with optional `intl` integration
- Add namespaces and dotted keys support for nested JSON structures
- Add new `FormattingHelpers` class with methods for numbers, currency, percentages, dates, and times
- Add support for accessing nested keys using dot notation (e.g., `user.profile.name`)
- Add enhanced example app with formatting demo screen
- Fix `MissingKeyDebugOverlay` Directionality widget error
- Update documentation with comprehensive examples for new features
- Maintain backward compatibility with existing flat key structures

## 1.0.3

- Add missing key diagnostics with configurable logging and debug overlay
- Implement hot-reload translations in debug mode for faster development
- Add `enableMissingKeyLogging` and `onMissingKey` callback to LocalizationProvider
- Add `showDebugOverlay` option to display missing keys visually
- Add `enableHotReload` option for automatic translation reloading in debug mode
- Comprehensive test coverage for new diagnostic and hot-reload features
- Update documentation and example app to demonstrate new features

## 1.0.2

- Bump package version to 1.0.2
- README: update dependency example to ^1.0.2
- Example: update About screen version text to v1.0.2

## 1.0.1

- Bump package version to 1.0.1
- README: add SVG banner, author section (GitHub: @muzzammil763), and closing tagline
- Docs: clarify JSON asset path and setup for `lib/localization.json`
- Example: update About screen version text to `v1.0.1`

## 1.0.0

- Initial stable release
- Inline localization via `String.localize([Map<String, String>? translations])`
- JSON-based localization read from `lib/localization.json`
- Widgets: `LocalizationProvider`, `LocalizedText`, `LocalizedBuilder`
- Instant language switching with `LocalizationProvider.setLocale(context, locale)`
- Fallback behavior when translation key/locale is missing
- Example app and comprehensive tests
