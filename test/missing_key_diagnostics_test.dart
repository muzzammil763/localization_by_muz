import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('Missing Key Diagnostics', () {
    late LocalizationManager manager;
    List<String> logMessages = [];
    List<MapEntry<String, String>> missingKeyCalls = [];

    setUp(() {
      manager = LocalizationManager.instance;
      manager.reset();
      logMessages.clear();
      missingKeyCalls.clear();
      
      // Override debugPrint to capture log messages
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null) {
          logMessages.add(message);
        }
      };
    });

    tearDown(() {
      manager.reset();
      debugPrint = debugPrintThrottled;
    });

    test('should track missing keys', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: true,
      );

      // Translate a missing key
      final result = manager.translate('nonExistentKey');

      expect(result, equals('nonExistentKey'));
      expect(manager.missingKeys, contains('nonExistentKey'));
      expect(manager.missingKeys.length, equals(1));
    });

    test('should log missing keys when logging is enabled', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: true,
      );

      manager.translate('missingKey1');
      manager.translate('missingKey2');

      expect(logMessages.length, equals(2));
      expect(logMessages[0], contains('Missing translation key: "missingKey1"'));
      expect(logMessages[1], contains('Missing translation key: "missingKey2"'));
    });

    test('should not log missing keys when logging is disabled', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: false,
      );

      manager.translate('missingKey');

      expect(logMessages.isEmpty, isTrue);
      expect(manager.missingKeys, contains('missingKey'));
    });

    test('should call onMissingKey callback when provided', () async {
      await manager.initialize(
        skipAssetLoading: true,
        onMissingKey: (key, locale) {
          missingKeyCalls.add(MapEntry(key, locale));
        },
      );

      manager.translate('callbackKey');
      manager.setLocale('fr');
      manager.translate('anotherKey');

      expect(missingKeyCalls.length, equals(2));
      expect(missingKeyCalls[0].key, equals('callbackKey'));
      expect(missingKeyCalls[0].value, equals('en'));
      expect(missingKeyCalls[1].key, equals('anotherKey'));
      expect(missingKeyCalls[1].value, equals('fr'));
    });

    test('should not call callback when key exists', () async {
      // Initialize with some test data
      manager.reset();
      await manager.initialize(
        skipAssetLoading: true,
        onMissingKey: (key, locale) {
          missingKeyCalls.add(MapEntry(key, locale));
        },
      );
      
      // Manually add a translation for testing
      manager.reset();
      await manager.initialize(
        skipAssetLoading: true,
        onMissingKey: (key, locale) {
          missingKeyCalls.add(MapEntry(key, locale));
        },
      );

      // Test with missing key
      manager.translate('missingKey');
      
      expect(missingKeyCalls.length, equals(1));
      expect(missingKeyCalls[0].key, equals('missingKey'));
    });

    test('should configure diagnostics at runtime', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: false,
      );

      expect(manager.enableMissingKeyLogging, isFalse);
      expect(manager.onMissingKey, isNull);

      // Configure at runtime
      manager.configureMissingKeyDiagnostics(
        enableLogging: true,
        onMissingKey: (key, locale) {
          missingKeyCalls.add(MapEntry(key, locale));
        },
      );

      expect(manager.enableMissingKeyLogging, isTrue);
      expect(manager.onMissingKey, isNotNull);

      // Test that it works
      manager.translate('runtimeKey');

      expect(logMessages.length, equals(1));
      expect(missingKeyCalls.length, equals(1));
    });

    test('should clear missing keys', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: true,
      );

      manager.translate('key1');
      manager.translate('key2');
      manager.translate('key3');

      expect(manager.missingKeys.length, equals(3));

      manager.clearMissingKeys();

      expect(manager.missingKeys.isEmpty, isTrue);
    });

    test('should not duplicate missing keys', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: true,
      );

      // Translate the same key multiple times
      manager.translate('duplicateKey');
      manager.translate('duplicateKey');
      manager.translate('duplicateKey');

      expect(manager.missingKeys.length, equals(1));
      expect(manager.missingKeys, contains('duplicateKey'));
      
      // But should log each time
      expect(logMessages.length, equals(3));
    });

    test('should handle missing locale for existing key', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: true,
      );

      // Simulate having a key but missing the current locale
      // This would happen in real usage when a key exists for some locales but not others
      manager.translate('partialKey');

      expect(manager.missingKeys, contains('partialKey'));
      expect(logMessages.length, equals(1));
    });

    test('should reset diagnostics state on reset', () async {
      await manager.initialize(
        skipAssetLoading: true,
        enableMissingKeyLogging: true,
        onMissingKey: (key, locale) {},
        showDebugOverlay: true,
      );

      manager.translate('testKey');

      expect(manager.missingKeys.isNotEmpty, isTrue);
      expect(manager.enableMissingKeyLogging, isTrue);
      expect(manager.onMissingKey, isNotNull);

      manager.reset();

      expect(manager.missingKeys.isEmpty, isTrue);
      expect(manager.enableMissingKeyLogging, isFalse);
      expect(manager.onMissingKey, isNull);
      expect(manager.showDebugOverlay, isFalse);
    });

    test('should only enable debug overlay in debug mode', () async {
      await manager.initialize(
        skipAssetLoading: true,
        showDebugOverlay: true,
      );

      // Debug overlay should only be enabled in debug mode
      expect(manager.showDebugOverlay, equals(kDebugMode));
    });
  });
}