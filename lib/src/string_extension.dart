import 'localization_manager.dart';

/// Adds localization helpers to `String`.
///
/// - When [translations] are provided, the string is treated as the default
///   text and the map contains per-locale overrides (e.g. `{ 'en': 'Hello' }`).
/// - When [translations] is omitted, the string is treated as a translation
///   key that will be looked up from `lib/localization.json` via
///   [LocalizationManager].
extension LocalizationExtension on String {
  /// Returns the localized value for this string.
  ///
  /// If [translations] is provided, the current app locale is used to pick the
  /// value from the map; if the locale is missing, the original string is
  /// returned as a sensible fallback.
  ///
  /// If [translations] is `null`, the string is interpreted as a translation
  /// key and resolved using [LocalizationManager.translate].
  ///
  /// Example (inline):
  /// ```dart
  /// Text('Welcome'.localize({ 'en': 'Welcome', 'fr': 'Bienvenue' }));
  /// ```
  ///
  /// Example (JSON key):
  /// ```dart
  /// Text('welcome'.localize());
  /// ```
  String localize([Map<String, String>? translations]) {
    if (translations != null) {
      final currentLocale = LocalizationManager.instance.currentLocale;
      return translations[currentLocale] ?? this;
    }

    return LocalizationManager.instance.translate(this);
  }
}
