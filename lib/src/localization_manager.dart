import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

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
  Map<String, Map<String, String>> _translations = {};
  bool _isInitialized = false;
  AssetLoader? _assetLoader;
  
  // Missing key diagnostics
  bool _enableMissingKeyLogging = false;
  OnMissingKeyCallback? _onMissingKey;
  final Set<String> _missingKeys = <String>{};
  bool _showDebugOverlay = false;
  
  // Hot-reload functionality
  bool _enableHotReload = false;
  Timer? _hotReloadTimer;
  Map<String, Map<String, String>> _lastTranslations = {};

  /// The currently selected locale code (e.g. `en`, `fr`).
  String get currentLocale => _currentLocale;

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

    _currentLocale = defaultLocale;
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
  void setLocale(String locale) {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      _notifyListeners();
    }
  }

  /// Looks up a localized value for a translation [key].
  ///
  /// Supports simple parameter interpolation using `{param}` placeholders via
  /// [args]. If an argument is missing, the placeholder is left unchanged.
  ///
  /// Returns [key] itself if the key or the current locale is missing.
  /// When a key is missing, triggers missing key diagnostics if enabled.
  String translate(String key, {Map<String, Object?>? args}) {
    String value;
    bool keyMissing = false;
    
    if (_translations.containsKey(key)) {
      final localeValue = _translations[key]?[_currentLocale];
      if (localeValue != null) {
        value = localeValue;
      } else {
        value = key;
        keyMissing = true;
      }
    } else {
      value = key;
      keyMissing = true;
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
  
  /// Handles missing key diagnostics when a translation key is not found.
  void _handleMissingKey(String key) {
    // Add to missing keys set
    _missingKeys.add(key);
    
    // Log if enabled
    if (_enableMissingKeyLogging) {
      debugPrint('Missing translation key: "$key" for locale "$_currentLocale"');
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
    
    debugPrint('🔥 Hot-reload enabled for translations (checking every 2 seconds)');
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
  bool _translationsEqual(Map<String, Map<String, String>> a, Map<String, Map<String, String>> b) {
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
