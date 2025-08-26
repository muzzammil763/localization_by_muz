import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'asset_loader.dart';

/// Manages loading translations and resolving localized strings.
///
/// This is a simple singleton that reads a JSON file from
/// `lib/localization.json` and provides translation lookup for the current
/// locale. Use [initialize] once at app start (handled by
/// `LocalizationProvider`) and [setLocale] to switch languages at runtime.
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

  /// The currently selected locale code (e.g. `en`, `fr`).
  String get currentLocale => _currentLocale;

  /// Whether the manager has been initialized.
  bool get isInitialized => _isInitialized;

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
  Future<void> initialize({
    String defaultLocale = 'en',
    bool skipAssetLoading = false,
    AssetLoader? assetLoader,
  }) async {
    if (_isInitialized) return;

    _currentLocale = defaultLocale;
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
  String translate(String key, {Map<String, Object?>? args}) {
    String value;
    if (_translations.containsKey(key)) {
      value = _translations[key]?[_currentLocale] ?? key;
    } else {
      value = key;
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
