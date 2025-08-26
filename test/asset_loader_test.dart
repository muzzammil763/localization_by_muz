import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/src/asset_loader.dart';

void main() {
  group('AssetLoader Tests', () {
    group('DefaultAssetLoader', () {
      test('should use default path lib/localization.json', () {
        const loader = DefaultAssetLoader();
        expect(loader.assetPath, 'lib/localization.json');
      });

      test('should use custom path when provided', () {
        const loader = DefaultAssetLoader(assetPath: 'assets/i18n/translations.json');
        expect(loader.assetPath, 'assets/i18n/translations.json');
      });
    });

    group('PerLocaleAssetLoader', () {
      test('should construct correct paths for locales', () {
        const loader = PerLocaleAssetLoader(
          basePath: 'assets/i18n',
          supportedLocales: ['en', 'fr', 'es'],
        );
        
        expect(loader.basePath, 'assets/i18n');
        expect(loader.supportedLocales, ['en', 'fr', 'es']);
      });

      test('should handle empty locales list', () {
        const loader = PerLocaleAssetLoader(
          basePath: 'assets/i18n',
          supportedLocales: [],
        );
        
        expect(loader.supportedLocales, isEmpty);
      });
    });

    group('CompositeAssetLoader', () {
      test('should accept multiple loaders', () {
        const loader1 = DefaultAssetLoader(assetPath: 'assets/common.json');
        const loader2 = PerLocaleAssetLoader(
          basePath: 'assets/i18n',
          supportedLocales: ['en', 'fr'],
        );
        
        const composite = CompositeAssetLoader([loader1, loader2]);
        
        expect(composite.loaders, hasLength(2));
        expect(composite.loaders[0], isA<DefaultAssetLoader>());
        expect(composite.loaders[1], isA<PerLocaleAssetLoader>());
      });

      test('should handle empty loaders list', () {
        const composite = CompositeAssetLoader([]);
        expect(composite.loaders, isEmpty);
      });
    });

    group('MemoryAssetLoader', () {
      test('should store provided translations', () {
        const translations = {
          'hello': {'en': 'Hello', 'fr': 'Bonjour'},
          'world': {'en': 'World', 'fr': 'Monde'},
        };
        
        const loader = MemoryAssetLoader(translations);
        expect(loader.translations, equals(translations));
      });

      test('should handle empty translations', () {
        const loader = MemoryAssetLoader({});
        expect(loader.translations, isEmpty);
      });

      test('should load translations synchronously', () async {
        const translations = {
          'hello': {'en': 'Hello', 'fr': 'Bonjour'},
        };
        
        const loader = MemoryAssetLoader(translations);
        final result = await loader.loadTranslations();
        
        expect(result, equals(translations));
      });
    });
  });
}