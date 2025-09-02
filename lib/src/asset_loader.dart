import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Abstract base class for loading localization assets.
///
/// Implement this interface to create custom asset loading strategies.
abstract class AssetLoader {
  /// Loads translations and returns a map structure.
  ///
  /// The returned map can be in flat format:
  /// ```
  /// {
  ///   'translationKey': {
  ///     'en': 'English text',
  ///     'fr': 'French text',
  ///     ...
  ///   }
  /// }
  /// ```
  ///
  /// Or nested format for dotted keys:
  /// ```
  /// {
  ///   'user': {
  ///     'profile': {
  ///       'name': {
  ///         'en': 'Name',
  ///         'fr': 'Nom'
  ///       }
  ///     }
  ///   }
  /// }
  /// ```
  Future<Map<String, dynamic>> loadTranslations();
}

/// Default asset loader that reads from a single JSON file.
///
/// This maintains backward compatibility with the original implementation.
class DefaultAssetLoader implements AssetLoader {
  /// The path to the JSON file containing translations.
  final String assetPath;

  const DefaultAssetLoader({this.assetPath = 'lib/localization.json'});

  @override
  Future<Map<String, dynamic>> loadTranslations() async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Support both flat and nested structures
      return _processTranslationMap(jsonMap);
    } catch (e) {
      debugPrint(
          'Warning: Could not load localization file from $assetPath: $e');
      return {};
    }
  }

  /// Processes the translation map to handle both flat and nested structures.
  Map<String, dynamic> _processTranslationMap(Map<String, dynamic> jsonMap) {
    final Map<String, dynamic> translations = {};

    jsonMap.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        // Check if this is a locale map (contains locale keys like 'en', 'fr')
        if (_isLocaleMap(value)) {
          translations[key] = Map<String, String>.from(value);
        } else {
          // This is a nested structure, process recursively
          translations[key] = _processTranslationMap(value);
        }
      }
    });

    return translations;
  }

  /// Checks if a map contains locale keys (simple heuristic).
  bool _isLocaleMap(Map<String, dynamic> map) {
    // Common locale codes to check for
    const commonLocales = [
      'en',
      'fr',
      'es',
      'de',
      'it',
      'pt',
      'ru',
      'ja',
      'ko',
      'zh'
    ];

    // If any key is a common locale and all values are strings, treat as locale map
    return map.keys.any((key) => commonLocales.contains(key)) &&
        map.values.every((value) => value is String);
  }
}
