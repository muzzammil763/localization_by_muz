import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();
  static LocalizationManager get instance => _instance;

  LocalizationManager._internal();

  String _currentLocale = 'en';
  Map<String, Map<String, String>> _translations = {};
  bool _isInitialized = false;

  String get currentLocale => _currentLocale;

  Future<void> initialize({String defaultLocale = 'en'}) async {
    if (_isInitialized) return;

    _currentLocale = defaultLocale;
    await _loadTranslations();
    _isInitialized = true;
  }

  void reset() {
    _isInitialized = false;
    _translations.clear();
    _listeners.clear();
  }

  Future<void> _loadTranslations() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/localization.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      _translations.clear();
      jsonMap.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          _translations[key] = Map<String, String>.from(value);
        }
      });
    } catch (e) {
      debugPrint('Warning: Could Not Load localization.json File: $e');
      _translations = {};
    }
  }

  void setLocale(String locale) {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      _notifyListeners();
    }
  }

  String translate(String key) {
    if (_translations.containsKey(key)) {
      return _translations[key]?[_currentLocale] ?? key;
    }
    return key;
  }

  final List<VoidCallback> _listeners = [];

  List<VoidCallback> get listeners => List.unmodifiable(_listeners);

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void dispose() {
    _listeners.clear();
  }
}
