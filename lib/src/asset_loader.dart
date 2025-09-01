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

/// Asset loader that supports per-locale files.
///
/// Loads separate JSON files for each locale and merges them.
/// Example file structure:
/// ```
/// assets/i18n/
///   ├── en.json
///   ├── fr.json
///   └── es.json
/// ```
class PerLocaleAssetLoader implements AssetLoader {
  /// The base directory path containing locale files.
  final String basePath;

  /// List of supported locale codes.
  final List<String> supportedLocales;

  /// File extension for locale files.
  final String fileExtension;

  const PerLocaleAssetLoader({
    required this.basePath,
    required this.supportedLocales,
    this.fileExtension = '.json',
  });

  @override
  Future<Map<String, dynamic>> loadTranslations() async {
    final Map<String, dynamic> allTranslations = {};

    for (final locale in supportedLocales) {
      final filePath = '$basePath/$locale$fileExtension';
      try {
        final String jsonString = await rootBundle.loadString(filePath);
        final Map<String, dynamic> localeData = json.decode(jsonString);

        // Convert flat locale file to nested structure
        _mergeLocaleData(allTranslations, localeData, locale);
      } catch (e) {
        debugPrint('Warning: Could not load locale file $filePath: $e');
      }
    }

    return allTranslations;
  }

  /// Merges locale data into the main translations structure.
  void _mergeLocaleData(
      Map<String, dynamic> target, Map<String, dynamic> source, String locale) {
    source.forEach((key, value) {
      if (value is String) {
        // Handle flat keys
        if (!target.containsKey(key)) {
          target[key] = <String, String>{};
        }
        if (target[key] is Map<String, String>) {
          (target[key] as Map<String, String>)[locale] = value;
        }
      } else if (value is Map<String, dynamic>) {
        // Handle nested structures
        if (!target.containsKey(key)) {
          target[key] = <String, dynamic>{};
        }
        if (target[key] is Map<String, dynamic>) {
          _mergeLocaleData(target[key] as Map<String, dynamic>, value, locale);
        }
      }
    });
  }
}

/// Asset loader that combines multiple loading strategies.
///
/// Loads from multiple sources and merges the results, with later loaders
/// taking precedence over earlier ones.
class CompositeAssetLoader implements AssetLoader {
  /// List of asset loaders to combine.
  final List<AssetLoader> loaders;

  const CompositeAssetLoader(this.loaders);

  @override
  Future<Map<String, dynamic>> loadTranslations() async {
    final Map<String, dynamic> mergedTranslations = {};

    for (final loader in loaders) {
      try {
        final translations = await loader.loadTranslations();
        _mergeTranslations(mergedTranslations, translations);
      } catch (e) {
        debugPrint('Warning: Asset loader failed: $e');
      }
    }

    return mergedTranslations;
  }

  void _mergeTranslations(
    Map<String, dynamic> target,
    Map<String, dynamic> source,
  ) {
    source.forEach((key, value) {
      if (value is Map<String, String>) {
        // Handle locale maps
        if (!target.containsKey(key)) {
          target[key] = <String, String>{};
        }
        if (target[key] is Map<String, String>) {
          (target[key] as Map<String, String>).addAll(value);
        }
      } else if (value is Map<String, dynamic>) {
        // Handle nested structures
        if (!target.containsKey(key)) {
          target[key] = <String, dynamic>{};
        }
        if (target[key] is Map<String, dynamic>) {
          _mergeTranslations(target[key] as Map<String, dynamic>, value);
        }
      }
    });
  }
}

/// Memory-based asset loader for testing or runtime translations.
class MemoryAssetLoader implements AssetLoader {
  /// The translations data.
  final Map<String, dynamic> translations;

  const MemoryAssetLoader(this.translations);

  @override
  Future<Map<String, dynamic>> loadTranslations() async {
    return Map.from(translations);
  }
}
