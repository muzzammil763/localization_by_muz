import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'asset_loader.dart';

/// Callback function type for handling missing translation keys.
typedef OnMissingKeyCallback = void Function(String key, String locale);

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

  // Missing key diagnostics
  bool _enableMissingKeyLogging = false;
  OnMissingKeyCallback? _onMissingKey;
  final Set<String> _missingKeys = <String>{};
  bool _showDebugOverlay = false;

  // Hot-reload functionality
  bool _enableHotReload = false;
  Timer? _hotReloadTimer;
  Map<String, dynamic> _lastTranslations = {};

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

  /// Whether missing key logging is enabled.
  bool get enableMissingKeyLogging => _enableMissingKeyLogging;

  /// Whether debug overlay for missing keys is enabled.
  bool get showDebugOverlay => _showDebugOverlay;

  /// Whether hot-reload for translations is enabled.
  bool get enableHotReload => _enableHotReload;

  /// Set of missing translation keys that have been encountered.
  Set<String> get missingKeys => Set.unmodifiable(_missingKeys);

  /// Current missing key callback function.
  OnMissingKeyCallback? get onMissingKey => _onMissingKey;

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
  /// Missing key diagnostics options:
  /// - [enableMissingKeyLogging]: Enable console logging for missing keys
  /// - [onMissingKey]: Callback function called when a key is missing
  /// - [showDebugOverlay]: Show debug overlay for missing keys (development only)
  /// - [enableHotReload]: Enable automatic reloading of translations in debug mode
  Future<void> initialize({
    String defaultLocale = 'en',
    bool skipAssetLoading = false,
    AssetLoader? assetLoader,
    bool enableMissingKeyLogging = false,
    OnMissingKeyCallback? onMissingKey,
    bool showDebugOverlay = false,
    bool enableHotReload = false,
  }) async {
    if (_isInitialized) return;

    // Load saved locale from SharedPreferences, fallback to defaultLocale
    _currentLocale = await _loadSavedLocale() ?? defaultLocale;
    _assetLoader = assetLoader ?? const DefaultAssetLoader();

    // Set missing key diagnostics options
    _enableMissingKeyLogging = enableMissingKeyLogging;
    _onMissingKey = onMissingKey;
    _showDebugOverlay = showDebugOverlay && kDebugMode;

    // Set hot-reload option (only works in debug mode)
    _enableHotReload = enableHotReload && kDebugMode;

    if (!skipAssetLoading) {
      await _loadTranslations();
      _lastTranslations = Map.from(_translations);

      // Start hot-reload timer if enabled
      if (_enableHotReload) {
        _startHotReloadTimer();
      }
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

    // Reset missing key diagnostics
    _enableMissingKeyLogging = false;
    _onMissingKey = null;
    _missingKeys.clear();
    _showDebugOverlay = false;

    // Reset hot-reload
    _enableHotReload = false;
    _hotReloadTimer?.cancel();
    _hotReloadTimer = null;
    _lastTranslations.clear();
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
      return prefs.getString(_localeKey);
    } catch (e) {
      debugPrint('Warning: Could not load saved locale: $e');
      return null;
    }
  }

  /// Saves the current locale to SharedPreferences.
  Future<void> _saveLocale(String locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
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

    // Log if enabled
    if (_enableMissingKeyLogging) {
      debugPrint(
          'Missing translation key: "$key" for locale "$_currentLocale"');
    }

    ///// Call callback if provided
    _onMissingKey?.call(key, _currentLocale);
  }

  /// Configures missing key diagnostics at runtime.
  void configureMissingKeyDiagnostics({
    bool? enableLogging,
    OnMissingKeyCallback? onMissingKey,
    bool? showDebugOverlay,
  }) {
    if (enableLogging != null) {
      _enableMissingKeyLogging = enableLogging;
    }
    if (onMissingKey != null) {
      _onMissingKey = onMissingKey;
    }
    if (showDebugOverlay != null) {
      _showDebugOverlay = showDebugOverlay && kDebugMode;
    }
  }

  /// Clears the set of missing keys that have been tracked.
  void clearMissingKeys() {
    _missingKeys.clear();
  }

  /// Starts the hot-reload timer to periodically check for translation changes.
  void _startHotReloadTimer() {
    if (!kDebugMode || !_enableHotReload) return;

    _hotReloadTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkForTranslationChanges();
    });

    debugPrint(
        '🔥 Hot-reload enabled for translations (checking every 2 seconds)');
  }

  /// Checks if translations have changed and reloads them if necessary.
  Future<void> _checkForTranslationChanges() async {
    if (!_enableHotReload || _assetLoader == null) return;

    try {
      final newTranslations = await _assetLoader!.loadTranslations();

      // Compare with last known translations
      if (!_translationsEqual(_lastTranslations, newTranslations)) {
        debugPrint('🔄 Translation changes detected, reloading...');
        _translations = newTranslations;
        _lastTranslations = Map.from(newTranslations);
        _notifyListeners();
        debugPrint('✅ Translations reloaded successfully');
      }
    } catch (e) {
      debugPrint('⚠️ Hot-reload failed: $e');
    }
  }

  /// Compares two translation maps for equality.
  bool _translationsEqual(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) return false;

    for (final key in a.keys) {
      if (!b.containsKey(key)) return false;

      final mapA = a[key]!;
      final mapB = b[key]!;

      if (mapA.length != mapB.length) return false;

      for (final subKey in mapA.keys) {
        if (mapA[subKey] != mapB[subKey]) return false;
      }
    }

    return true;
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
