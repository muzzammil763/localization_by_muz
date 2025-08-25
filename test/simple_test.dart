import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('Simple Functionality Tests', () {
    test('String extension with inline translations works', () {
      final translations = {
        'en': 'Hello World',
        'fr': 'Bonjour Le Monde',
        'es': 'Hola Mundo',
      };

      LocalizationManager.instance.setLocale('en');
      expect('test'.localize(translations), 'Hello World');

      LocalizationManager.instance.setLocale('fr');
      expect('test'.localize(translations), 'Bonjour Le Monde');

      LocalizationManager.instance.setLocale('es');
      expect('test'.localize(translations), 'Hola Mundo');
    });

    test('LocalizationManager singleton works', () {
      final manager1 = LocalizationManager.instance;
      final manager2 = LocalizationManager.instance;
      expect(manager1, same(manager2));
    });

    test('setLocale changes current locale', () {
      final manager = LocalizationManager.instance;
      
      manager.setLocale('fr');
      expect(manager.currentLocale, 'fr');
      
      manager.setLocale('en');
      expect(manager.currentLocale, 'en');
    });

    test('translate returns key when no translation found', () {
      final manager = LocalizationManager.instance;
      final result = manager.translate('nonExistentKey');
      expect(result, 'nonExistentKey');
    });

    test('listeners are notified when locale changes', () {
      final manager = LocalizationManager.instance;
      var notified = false;
      
      void listener() {
        notified = true;
      }

      manager.addListener(listener);
      manager.setLocale('test-locale');
      
      expect(notified, true);
      
      manager.removeListener(listener);
    });
  });
}