import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Abstract base class for loading localization assets.
///
/// Implement this interface to create custom asset loading strategies.
abstract class AssetLoader {
  /// Loads translations and returns a map of locale -> key -> value.
  ///
  /// The returned map should be in the format:
  /// ```
  /// {
  ///   'translationKey': {
  ///     'en': 'English text',
  ///     'fr': 'French text',
  ///     ...
  ///   }
  /// }
  /// ```
  Future<Map<String, Map<String, String>>> loadTranslations();
}

/// Default asset loader that reads from a single JSON file.
///
/// This maintains backward compatibility with the original implementation.
class DefaultAssetLoader implements AssetLoader {
  /// The path to the JSON file containing translations.
  final String assetPath;

  const DefaultAssetLoader({this.assetPath = 'lib/localization.json'});

  @override
  Future<Map<String, Map<String, String>>> loadTranslations() async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final Map<String, Map<String, String>> translations = {};
      jsonMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          translations[key] = Map<String, String>.from(value);
        }
      });
      return translations;
    } catch (e) {
      debugPrint('Warning: Could not load localization file from $assetPath: $e');
      return {};
    }
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
  Future<Map<String, Map<String, String>>> loadTranslations() async {
    final Map<String, Map<String, String>> allTranslations = {};

    for (final locale in supportedLocales) {
      final filePath = '$basePath/$locale$fileExtension';
      try {
        final String jsonString = await rootBundle.loadString(filePath);
        final Map<String, dynamic> localeData = json.decode(jsonString);

        // Convert flat locale file to nested structure
        localeData.forEach((key, value) {
          if (value is String) {
            allTranslations.putIfAbsent(key, () => {})[locale] = value;
          }
        });
      } catch (e) {
        debugPrint('Warning: Could not load locale file $filePath: $e');
      }
    }

    return allTranslations;
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
  Future<Map<String, Map<String, String>>> loadTranslations() async {
    final Map<String, Map<String, String>> mergedTranslations = {};

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
    Map<String, Map<String, String>> target,
    Map<String, Map<String, String>> source,
  ) {
    source.forEach((key, localeMap) {
      target.putIfAbsent(key, () => {}).addAll(localeMap);
    });
  }
}

/// Memory-based asset loader for testing or runtime translations.
class MemoryAssetLoader implements AssetLoader {
  /// The translations data.
  final Map<String, Map<String, String>> translations;

  const MemoryAssetLoader(this.translations);

  @override
  Future<Map<String, Map<String, String>>> loadTranslations() async {
    return Map.from(translations);
  }
}