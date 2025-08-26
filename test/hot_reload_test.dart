import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/src/asset_loader.dart';
import 'package:localization_by_muz/src/localization_manager.dart';

/// Mock asset loader that allows changing translations dynamically
class MockAssetLoader implements AssetLoader {
  Map<String, Map<String, String>> _translations = {
    'en': {'hello': 'Hello', 'world': 'World'},
    'es': {'hello': 'Hola', 'world': 'Mundo'},
  };

  @override
  Future<Map<String, Map<String, String>>> loadTranslations() async {
    // Simulate async loading
    await Future.delayed(const Duration(milliseconds: 10));
    return Map.from(_translations);
  }

  /// Update translations to simulate file changes
  void updateTranslations(Map<String, Map<String, String>> newTranslations) {
    _translations = newTranslations;
  }
}

void main() {
  group('Hot-reload Tests', () {
    late LocalizationManager manager;
    late MockAssetLoader mockLoader;

    setUp(() {
      manager = LocalizationManager.instance;
      mockLoader = MockAssetLoader();
    });

    tearDown(() {
      manager.dispose();
    });

    testWidgets('Hot-reload is enabled only in debug mode', (tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: mockLoader,
        enableHotReload: true,
      );

      // Hot-reload should be enabled in debug mode
      expect(manager.enableHotReload, kDebugMode);
    });

    testWidgets('Hot-reload is disabled when flag is false', (tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: mockLoader,
        enableHotReload: false,
      );

      expect(manager.enableHotReload, false);
    });

    testWidgets('Hot-reload detects translation changes', (tester) async {
      if (!kDebugMode) {
        // Skip this test in release mode
        return;
      }

      bool listenerCalled = false;
      manager.addListener(() {
        listenerCalled = true;
      });

      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: mockLoader,
        enableHotReload: true,
      );

      // Initial translation
      expect(manager.translate('hello'), 'Hello');
      expect(listenerCalled, false);

      // Update translations
      mockLoader.updateTranslations({
        'en': {'hello': 'Hello Updated', 'world': 'World'},
        'es': {'hello': 'Hola', 'world': 'Mundo'},
      });

      // Wait for hot-reload timer to trigger (2+ seconds)
      await tester.pump(const Duration(seconds: 3));

      // Check if translations were updated
      expect(manager.translate('hello'), 'Hello Updated');
      expect(listenerCalled, true);
    });

    testWidgets('Hot-reload handles asset loading errors gracefully', (tester) async {
      if (!kDebugMode) {
        return;
      }

      // Create a loader that will fail
      final failingLoader = FailingAssetLoader();

      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: failingLoader,
        enableHotReload: true,
      );

      // Wait for hot-reload timer to trigger
      await tester.pump(const Duration(seconds: 3));

      // Manager should still be functional despite loading errors
      expect(manager.currentLocale, 'en');
    });

    testWidgets('Hot-reload does not trigger for identical translations', (tester) async {
      if (!kDebugMode) {
        return;
      }

      int listenerCallCount = 0;
      manager.addListener(() {
        listenerCallCount++;
      });

      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: mockLoader,
        enableHotReload: true,
      );

      // Set the same translations again
      mockLoader.updateTranslations({
        'en': {'hello': 'Hello', 'world': 'World'},
        'es': {'hello': 'Hola', 'world': 'Mundo'},
      });

      // Wait for hot-reload timer
      await tester.pump(const Duration(seconds: 3));

      // Listener should not be called for identical translations
      expect(listenerCallCount, 0);
    });

    testWidgets('Hot-reload detects new language additions', (tester) async {
      if (!kDebugMode) {
        return;
      }

      bool listenerCalled = false;
      manager.addListener(() {
        listenerCalled = true;
      });

      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: mockLoader,
        enableHotReload: true,
      );

      // Add a new language
      mockLoader.updateTranslations({
        'en': {'hello': 'Hello', 'world': 'World'},
        'es': {'hello': 'Hola', 'world': 'Mundo'},
        'fr': {'hello': 'Bonjour', 'world': 'Monde'},
      });

      // Wait for hot-reload timer
      await tester.pump(const Duration(seconds: 3));

      // Check if new language was detected
      expect(listenerCalled, true);
      
      // Switch to new language and verify
      manager.setLocale('fr');
      expect(manager.translate('hello'), 'Bonjour');
    });

    testWidgets('Hot-reload detects key removals', (tester) async {
      if (!kDebugMode) {
        return;
      }

      bool listenerCalled = false;
      manager.addListener(() {
        listenerCalled = true;
      });

      await manager.initialize(
        defaultLocale: 'en',
        assetLoader: mockLoader,
        enableHotReload: true,
      );

      // Remove a key
      mockLoader.updateTranslations({
        'en': {'hello': 'Hello'}, // 'world' key removed
        'es': {'hello': 'Hola'},
      });

      // Wait for hot-reload timer
      await tester.pump(const Duration(seconds: 3));

      // Check if change was detected
      expect(listenerCalled, true);
      
      // Verify removed key returns the key itself
      expect(manager.translate('world'), 'world');
    });
  });
}

/// Asset loader that always fails for testing error handling
class FailingAssetLoader implements AssetLoader {
  @override
  Future<Map<String, Map<String, String>>> loadTranslations() async {
    throw Exception('Simulated loading failure');
  }
}