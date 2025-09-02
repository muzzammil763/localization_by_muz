import 'package:flutter/widgets.dart';

import 'localization_manager.dart';

/// Adds JSON-based localization helpers to `String`.
///
/// The string is treated as a translation key that will be looked up from
/// `lib/localization.json` via [LocalizationManager].
extension LocalizationExtension on String {
  /// Returns the localized value for this string key.
  ///
  /// The string is interpreted as a translation key and resolved using
  /// [LocalizationManager.translate] from the JSON file.
  ///
  /// Example:
  /// ```dart
  /// Text('welcome'.localize());
  /// ```
  String localize() {
    // Return empty string until LocalizationManager is fully initialized
    // This prevents showing the key before the translation is loaded
    if (!LocalizationManager.instance.isInitialized) {
      return '';
    }
    return LocalizationManager.instance.translate(this);
  }

  /// Returns the localized value for this string key with parameter interpolation.
  ///
  /// Supports replacing `{param}` placeholders with values provided in [args].
  /// The string is treated as a JSON key and resolved via [LocalizationManager.translate].
  /// Missing args leave their placeholders unchanged.
  ///
  /// Example:
  /// ```dart
  /// Text('welcome_user'.localizeArgs(args: {'name': 'John'}));
  /// ```
  String localizeArgs({Map<String, Object?>? args}) {
    // Return empty string until LocalizationManager is fully initialized
    // This prevents showing the key before the translation is loaded
    if (!LocalizationManager.instance.isInitialized) {
      return '';
    }
    return LocalizationManager.instance.translate(this, args: args);
  }

  /// Returns the current text direction for the active locale.
  ///
  /// This is useful when you need to know the directionality of the current locale
  /// for custom widgets or layout decisions.
  TextDirection get textDirection {
    // Return default LTR direction until LocalizationManager is fully initialized
    if (!LocalizationManager.instance.isInitialized) {
      return TextDirection.ltr;
    }
    return LocalizationManager.instance.textDirection;
  }

  /// Returns a record containing both the localized text and its text direction.
  ///
  /// This is useful when you need both the translated text and its directionality
  /// in a single call.
  ///
  /// Example:
  /// ```dart
  /// final result = "welcome".localizeWithDirection();
  /// Text(
  ///   result.text,
  ///   textDirection: result.direction,
  /// )
  /// ```
  ({String text, TextDirection direction}) localizeWithDirection({
    Map<String, Object?>? args,
  }) {
    final localizedText = localizeArgs(args: args);

    return (
      text: localizedText,
      direction:
          textDirection, // Use the extension's textDirection getter which handles initialization
    );
  }
}
