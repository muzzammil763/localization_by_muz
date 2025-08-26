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

  /// Returns the localized value for this string with parameter interpolation.
  ///
  /// This is a non-breaking companion to [localize] that adds support for
  /// replacing `{param}` placeholders with values provided in [args].
  ///
  /// - If [translations] is provided, the current locale value is selected
  ///   from the map and placeholders are substituted using [args].
  /// - If [translations] is omitted, the string is treated as a JSON key and
  ///   resolved via [LocalizationManager.translate] with [args].
  /// - Missing args leave their placeholders unchanged.
  String localizeArgs({
    Map<String, String>? translations,
    Map<String, Object?>? args,
  }) {
    if (translations != null) {
      final currentLocale = LocalizationManager.instance.currentLocale;
      final value = translations[currentLocale] ?? this;
      if (args == null || args.isEmpty) return value;

      final regExp = RegExp(r'\{(\w+)\}');
      return value.replaceAllMapped(regExp, (match) {
        final key = match.group(1)!;
        final val = args[key];
        if (val == null) return match.group(0)!;
        return val.toString();
      });
    }

    return LocalizationManager.instance.translate(this, args: args);
  }
}
