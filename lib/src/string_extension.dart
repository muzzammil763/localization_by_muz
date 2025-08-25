import 'localization_manager.dart';

/// Adds Localization Helpers To `String`.
///
/// - When [translations] Are Provided, The String Is Treated As The Default
///   Text And The Map Contains Per-Locale Overrides (e.g. `{ 'en': 'Hello' }`).
/// - When [translations] Is Omitted, The String Is Treated As A Translation
///   Key That Will Be Looked Up From `lib/localization.json` Via
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
