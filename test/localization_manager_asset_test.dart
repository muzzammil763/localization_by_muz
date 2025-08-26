import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/src/asset_loader.dart';
import 'package:localization_by_muz/src/localization_manager.dart';

void main() {
  group('LocalizationManager Asset Loading Tests', () {
    setUp(() {
      LocalizationManager.instance.reset();
    });

    test('should use DefaultAssetLoader when no custom loader provided', () async {
      // This test verifies backward compatibility
      await LocalizationManager.instance.initialize(
        skipAssetLoading: true, // Skip actual file loading in tests
      );
      
      expect(LocalizationManager.instance.isInitialized, isTrue);
    });

    test('should use custom MemoryAssetLoader', () async {
      const translations = {
        'hello': {'en': 'Hello', 'fr': 'Bonjour'},
        'world': {'en': 'World', 'fr': 'Monde'},
      };
      
      const loader = MemoryAssetLoader(translations);
      
      await LocalizationManager.instance.initialize(
        assetLoader: loader,
      );
      
      expect(LocalizationManager.instance.isInitialized, isTrue);
      expect(LocalizationManager.instance.translate('hello'), 'Hello');
      
      LocalizationManager.instance.setLocale('fr');
      expect(LocalizationManager.instance.translate('hello'), 'Bonjour');
    });

    test('should handle CompositeAssetLoader with multiple sources', () async {
      const baseTranslations = {
        'common': {'en': 'Common', 'fr': 'Commun'},
      };
      
      const specificTranslations = {
        'hello': {'en': 'Hello', 'fr': 'Bonjour'},
        'common': {'en': 'Override', 'fr': 'Remplacer'}, // Should override
      };
      
      const loader1 = MemoryAssetLoader(baseTranslations);
      const loader2 = MemoryAssetLoader(specificTranslations);
      const composite = CompositeAssetLoader([loader1, loader2]);
      
      await LocalizationManager.instance.initialize(
        assetLoader: composite,
      );
      
      expect(LocalizationManager.instance.isInitialized, isTrue);
      expect(LocalizationManager.instance.translate('hello'), 'Hello');
      expect(LocalizationManager.instance.translate('common'), 'Override'); // Should be overridden
      
      LocalizationManager.instance.setLocale('fr');
      expect(LocalizationManager.instance.translate('hello'), 'Bonjour');
      expect(LocalizationManager.instance.translate('common'), 'Remplacer');
    });

    test('should handle empty translations gracefully', () async {
      const loader = MemoryAssetLoader({});
      
      await LocalizationManager.instance.initialize(
        assetLoader: loader,
      );
      
      expect(LocalizationManager.instance.isInitialized, isTrue);
      expect(LocalizationManager.instance.translate('nonexistent'), 'nonexistent');
    });

    test('should reset asset loader on reset', () async {
      const translations = {
        'test': {'en': 'Test'},
      };
      
      const loader = MemoryAssetLoader(translations);
      
      await LocalizationManager.instance.initialize(
        assetLoader: loader,
      );
      
      expect(LocalizationManager.instance.translate('test'), 'Test');
      
      LocalizationManager.instance.reset();
      expect(LocalizationManager.instance.isInitialized, isFalse);
      
      // After reset, should use default behavior
      await LocalizationManager.instance.initialize(
        skipAssetLoading: true,
      );
      
      expect(LocalizationManager.instance.translate('test'), 'test'); // Should return key
    });
  });
}