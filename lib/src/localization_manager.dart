import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'asset_loader.dart';

/// Manages loading translations and resolving localized strings.
///
/// This is a simple singleton that reads a JSON file from
/// `lib/localization.json` and provides translation lookup for the current
/// locale. Use [initialize] once at app start (handled by
/// `LocalizationProvider`) and [setLocale] to switch languages at runtime.
///
/// Supports missing key diagnostics with toggleable logging and callbacks.
class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();

  /// Returns the singleton instance of [LocalizationManager].
  static LocalizationManager get instance => _instance;

  LocalizationManager._internal();

  /// The currently selected locale code (e.g. `en`, `fr`).
  String _currentLocale = 'en';
  Map<String, dynamic> _translations = {};
  bool _isInitialized = false;
  AssetLoader? _assetLoader;

  /// Cache for text direction to avoid repeated calculations
  TextDirection? _cachedTextDirection;

  /// SharedPreferences key for storing locale
  static const String _localeKey = 'localization_by_muz_locale';

  /// Cached SharedPreferences instance for synchronous access
  SharedPreferences? _cachedPrefs;

  // Missing key diagnostics
  final Set<String> _missingKeys = <String>{};

  /// The currently selected locale code (e.g. `en`, `fr`).
  String get currentLocale => _currentLocale;

  /// Gets the text direction for the current locale.
  /// Returns TextDirection.rtl for RTL languages (Arabic, Urdu, Persian, Hebrew, etc.)
  /// and TextDirection.ltr for all other languages.
  TextDirection get textDirection {
    _cachedTextDirection ??= _getTextDirectionForLocale(_currentLocale);
    return _cachedTextDirection!;
  }

  /// Whether the manager has been initialized.
  bool get isInitialized => _isInitialized;

  /// Set of missing translation keys that have been encountered.
  Set<String> get missingKeys => Set.unmodifiable(_missingKeys);

  /// Initializes the manager and loads translations from JSON.
  ///
  /// The [defaultLocale] determines the initial locale for lookups.
  /// This method is safe to call multiple times; subsequent calls are no-ops.
  ///
  /// Set [skipAssetLoading] to `true` to bypass reading `lib/localization.json`.
  /// This is primarily useful in tests where the asset may not be present.
  ///
  /// Provide a custom [assetLoader] to use alternative loading strategies.
  /// If not provided, defaults to [DefaultAssetLoader] with 'lib/localization.json'.
  ///
  Future<void> initialize({
    String defaultLocale = 'en',
    bool skipAssetLoading = false,
    AssetLoader? assetLoader,
  }) async {
    if (_isInitialized) return;

    // If SharedPreferences is already cached, use the provided defaultLocale
    // (which should already be the correct saved locale from LocalizationProvider)
    // Otherwise, load saved locale from SharedPreferences
    if (_cachedPrefs != null) {
      _currentLocale = defaultLocale;
    } else {
      _currentLocale = await _loadSavedLocale() ?? defaultLocale;
    }
    _assetLoader = assetLoader ?? const DefaultAssetLoader();

    if (!skipAssetLoading) {
      await _loadTranslations();
    } else {
      _translations = {};
    }
    _isInitialized = true;
  }

  /// Resets the cached state. Primarily useful in tests.
  void reset() {
    _currentLocale = 'en';
    _isInitialized = false;
    _translations.clear();
    _listeners.clear();
    _assetLoader = null;
    _cachedPrefs = null; // Clear cached SharedPreferences
    _cachedTextDirection = null; // Clear cached text direction

    // Reset missing key diagnostics
    _missingKeys.clear();
  }

  Future<void> _loadTranslations() async {
    try {
      final loader = _assetLoader ?? const DefaultAssetLoader();
      _translations = await loader.loadTranslations();
    } catch (e) {
      debugPrint('Warning: Could not load translations: $e');
      _translations = {};
    }
  }

  /// Sets the current [locale] and notifies listeners.
  /// Also saves the locale to SharedPreferences for persistence.
  void setLocale(String locale) {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      _cachedTextDirection = null; // Clear cache when locale changes
      _saveLocale(locale); // Save to SharedPreferences
      _notifyListeners();
    }
  }

  /// Loads the saved locale from SharedPreferences.
  /// Returns null if no locale is saved.
  Future<String?> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedPrefs = prefs; // Cache for synchronous access
      return prefs.getString(_localeKey);
    } catch (e) {
      debugPrint('Warning: Could not load saved locale: $e');
      return null;
    }
  }

  /// Preloads SharedPreferences for synchronous access.
  /// Call this early in app startup to enable synchronous locale loading.
  Future<void> preloadSharedPreferences() async {
    try {
      _cachedPrefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('Warning: Could not preload SharedPreferences: $e');
    }
  }

  /// Gets the saved locale synchronously if SharedPreferences is already loaded.
  /// Returns null if SharedPreferences is not yet loaded or no locale is saved.
  String? getSavedLocaleSync() {
    try {
      return _cachedPrefs?.getString(_localeKey);
    } catch (e) {
      debugPrint('Warning: Could not get saved locale synchronously: $e');
      return null;
    }
  }

  /// Returns true if SharedPreferences is already cached.
  bool get isSharedPreferencesCached => _cachedPrefs != null;

  /// Sets the current locale synchronously without full initialization.
  /// Used by LocalizationProvider to ensure immediate locale availability.
  void setCurrentLocaleSync(String locale) {
    _currentLocale = locale;
  }

  /// Saves the current locale to SharedPreferences.
  Future<void> _saveLocale(String locale) async {
    try {
      final prefs = _cachedPrefs ?? await SharedPreferences.getInstance();
      _cachedPrefs = prefs; // Cache for future use
      await prefs.setString(_localeKey, locale);
    } catch (e) {
      debugPrint('Warning: Could not save locale: $e');
    }
  }

  /// Looks up a localized value for a translation [key].
  ///
  /// Supports simple parameter interpolation using `{param}` placeholders via
  /// [args]. If an argument is missing, the placeholder is left unchanged.
  ///
  /// Supports namespaces/dotted keys for nested JSON structures.
  /// For example, 'user.profile.name' will look for nested structure:
  /// ```json
  /// {
  ///   "user.profile.name": {
  ///     "en": "Name",
  ///     "fr": "Nom"
  ///   }
  /// }
  /// ```
  /// Or in nested format:
  /// ```json
  /// {
  ///   "user": {
  ///     "profile": {
  ///       "name": {
  ///         "en": "Name",
  ///         "fr": "Nom"
  ///       }
  ///     }
  ///   }
  /// }
  /// ```
  ///
  /// Returns [key] itself if the key or the current locale is missing.
  /// When a key is missing, triggers missing key diagnostics if enabled.
  String translate(String key, {Map<String, Object?>? args}) {
    String value;
    bool keyMissing = false;

    // First try direct key lookup (backward compatibility)
    if (_translations.containsKey(key)) {
      final localeValue = _translations[key]?[_currentLocale];
      if (localeValue != null) {
        value = localeValue;
      } else {
        // Try fallback to default locale if current locale is missing
        final defaultValue = _translations[key]?['en'];
        if (defaultValue != null) {
          value = _formatDefaultValue(defaultValue, key);
        } else {
          value = _formatDefaultValue(key, key);
          keyMissing = true;
        }
      }
    } else {
      // Try nested key lookup for dotted keys
      final nestedValue = _getNestedValue(key, _currentLocale);
      if (nestedValue != null) {
        value = nestedValue;
      } else {
        // Try fallback to default locale for nested keys
        final defaultNestedValue = _getNestedValue(key, 'en');
        if (defaultNestedValue != null) {
          value = _formatDefaultValue(defaultNestedValue, key);
        } else {
          value = _formatDefaultValue(key, key);
          keyMissing = true;
        }
      }
    }

    // Handle missing key diagnostics
    if (keyMissing) {
      _handleMissingKey(key);
    }

    if (args == null || args.isEmpty) return value;

    // Replace placeholders of the form {name} with provided args.
    final regExp = RegExp(r'\{(\w+)\}');
    return value.replaceAllMapped(regExp, (match) {
      final argKey = match.group(1)!;
      final argVal = args[argKey];
      if (argVal == null) return match.group(0)!; // leave placeholder as-is
      return argVal.toString();
    });
  }

  /// Attempts to get a nested value from the translations using dotted key notation.
  ///
  /// For a key like 'user.profile.name', this will traverse the nested structure
  /// to find the translation value for the given locale.
  String? _getNestedValue(String key, String locale) {
    final keyParts = key.split('.');

    // Try to find nested structure in translations
    dynamic current = _translations;

    for (final part in keyParts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return null; // Path not found
      }
    }

    // At this point, current should be a Map<String, String> with locale keys
    if (current is Map<String, dynamic> && current.containsKey(locale)) {
      final value = current[locale];
      return value is String ? value : null;
    }

    return null;
  }

  /// Determines the text direction for a given locale.
  /// Returns TextDirection.rtl for RTL languages and TextDirection.ltr for others.
  TextDirection _getTextDirectionForLocale(String locale) {
    // List of RTL language codes
    const rtlLocales = {
      'ar', // Arabic
      'ur', // Urdu
      'fa', // Persian/Farsi
      'he', // Hebrew
      'ps', // Pashto
      'sd', // Sindhi
      'ku', // Kurdish
      'dv', // Divehi
      'yi', // Yiddish
    };

    // Extract language code from locale (e.g., 'ar_SA' -> 'ar')
    final languageCode = locale.split('_').first.split('-').first.toLowerCase();

    return rtlLocales.contains(languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  /// Formats the default value to maintain proper capitalization.
  /// If the key starts with lowercase and default value starts with uppercase,
  /// preserve the original formatting from the default value.
  String _formatDefaultValue(String defaultValue, String key) {
    // If we're showing the key itself and it's different from default value,
    // try to maintain proper capitalization
    if (defaultValue == key) {
      return key;
    }

    // If default value exists and has proper capitalization, use it
    return defaultValue;
  }

  /// Handles missing key diagnostics when a translation key is not found.
  void _handleMissingKey(String key) {
    // Add to missing keys set
    _missingKeys.add(key);

    // Missing key tracked for diagnostics
  }

  /// Clears the set of missing keys that have been tracked.
  void clearMissingKeys() {
    _missingKeys.clear();
  }

  final List<VoidCallback> _listeners = [];

  /// Read-only list of listeners that are notified when the locale changes.
  List<VoidCallback> get listeners => List.unmodifiable(_listeners);

  /// Registers a [listener] to be called after locale changes.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Unregisters a previously added [listener].
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  /// Disposes internal state: clears listeners and translations, and resets
  /// initialization so the manager can be re-initialized (useful for tests).
  void dispose() {
    reset();
  }
}
