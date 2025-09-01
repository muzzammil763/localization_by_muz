import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  // Ensure the singleton is reset after each test to avoid state leakage
  tearDown(() {
    LocalizationManager.instance.dispose();
  });

  group('Directionality Support Tests', () {
    test('textDirection returns LTR for English locale', () {
      LocalizationManager.instance.setLocale('en');
      expect(LocalizationManager.instance.textDirection, TextDirection.ltr);
    });

    test('textDirection returns RTL for Arabic locale', () {
      LocalizationManager.instance.setLocale('ar');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
    });

    test('textDirection returns RTL for Urdu locale', () {
      LocalizationManager.instance.setLocale('ur');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
    });

    test('textDirection returns RTL for Persian locale', () {
      LocalizationManager.instance.setLocale('fa');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
    });

    test('textDirection returns RTL for Hebrew locale', () {
      LocalizationManager.instance.setLocale('he');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
    });

    test('textDirection returns LTR for French locale', () {
      LocalizationManager.instance.setLocale('fr');
      expect(LocalizationManager.instance.textDirection, TextDirection.ltr);
    });

    test('textDirection returns LTR for Spanish locale', () {
      LocalizationManager.instance.setLocale('es');
      expect(LocalizationManager.instance.textDirection, TextDirection.ltr);
    });

    test('textDirection handles locale with country code (ar_SA)', () {
      LocalizationManager.instance.setLocale('ar_SA');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
    });

    test('textDirection handles locale with dash separator (ar-SA)', () {
      LocalizationManager.instance.setLocale('ar-SA');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
    });

    test('textDirection caches result and updates on locale change', () {
      LocalizationManager.instance.setLocale('en');
      expect(LocalizationManager.instance.textDirection, TextDirection.ltr);
      
      LocalizationManager.instance.setLocale('ar');
      expect(LocalizationManager.instance.textDirection, TextDirection.rtl);
      
      LocalizationManager.instance.setLocale('fr');
      expect(LocalizationManager.instance.textDirection, TextDirection.ltr);
    });

    test('textDirection returns LTR for unknown locale', () {
      LocalizationManager.instance.setLocale('unknown');
      expect(LocalizationManager.instance.textDirection, TextDirection.ltr);
    });

    test('all RTL locales are properly detected', () {
      const rtlLocales = ['ar', 'ur', 'fa', 'he', 'ps', 'sd', 'ku', 'dv', 'yi'];
      
      for (final locale in rtlLocales) {
        LocalizationManager.instance.setLocale(locale);
        expect(
          LocalizationManager.instance.textDirection, 
          TextDirection.rtl,
          reason: 'Locale $locale should be RTL'
        );
      }
    });
  });

  group('String Extension Directionality Tests', () {
    test('textDirection getter returns current locale direction', () {
      LocalizationManager.instance.setLocale('ar');
      expect('test'.textDirection, TextDirection.rtl);
      
      LocalizationManager.instance.setLocale('en');
      expect('test'.textDirection, TextDirection.ltr);
    });

    test('localizeWithDirection returns text and direction', () {
      LocalizationManager.instance.setLocale('ar');
      
      final result = 'hello'.localizeWithDirection({
        'ar': 'مرحبا',
        'en': 'Hello',
      });
      
      expect(result.text, 'مرحبا');
      expect(result.direction, TextDirection.rtl);
    });

    test('localizeWithDirection works with args', () {
      LocalizationManager.instance.setLocale('ar');
      
      final result = 'greeting'.localizeWithDirection(
        {
          'ar': 'مرحبا {name}',
          'en': 'Hello {name}',
        },
        {'name': 'أحمد'},
      );
      
      expect(result.text, 'مرحبا أحمد');
      expect(result.direction, TextDirection.rtl);
    });

    test('localizeWithDirection works without translations map', () {
      LocalizationManager.instance.setLocale('ur');
      
      final result = 'someKey'.localizeWithDirection();
      
      expect(result.text, 'someKey'); // Falls back to key
      expect(result.direction, TextDirection.rtl);
    });
  });

  group('Capitalization Fix Tests', () {
    test('translate with string extension preserves capitalization', () {
      LocalizationManager.instance.setLocale('en');
      
      // Test with inline translations
      final result1 = 'welcome'.localize({
        'en': 'Welcome',
        'fr': 'Bienvenue',
      });
      expect(result1, 'Welcome');
      
      final result2 = 'goodbye'.localize({
        'en': 'Goodbye',
        'fr': 'Au revoir',
      });
      expect(result2, 'Goodbye');
    });

    test('translate falls back to default locale when current locale missing', () {
      LocalizationManager.instance.setLocale('es');
      
      final result = 'welcome'.localize({
        'en': 'Welcome',
        'fr': 'Bienvenue',
        // No 'es' translation
      });
      
      expect(result, 'Welcome'); // Should fallback to English
    });

    test('translate returns formatted key when no translation exists', () {
      LocalizationManager.instance.setLocale('en');
      
      final result = 'nonExistentKey'.localize();
      expect(result, 'NonExistentKey'); // Should be formatted
    });

    test('translate handles nested keys with fallback', () {
      LocalizationManager.instance.setLocale('es');
      
      final result = 'user.profile.name'.localize({
        'en': 'Name',
        'fr': 'Nom',
      });
      
      expect(result, 'Name'); // Should fallback to English
    });

    test('translate preserves original casing from translations', () {
      LocalizationManager.instance.setLocale('en');
      
      // Test lowercase
      final result1 = 'button'.localize({
        'en': 'click here',
        'fr': 'cliquez ici',
      });
      expect(result1, 'click here');
      
      // Test uppercase
      final result2 = 'title'.localize({
        'en': 'MAIN TITLE',
        'fr': 'TITRE PRINCIPAL',
      });
      expect(result2, 'MAIN TITLE');
      
      // Test mixed case
      final result3 = 'brand'.localize({
        'en': 'MyBrand',
        'fr': 'MaMarque',
      });
      expect(result3, 'MyBrand');
    });
  });

  group('LocalizationProvider Directionality Tests', () {
    testWidgets('getTextDirection returns correct direction', (WidgetTester tester) async {
      LocalizationManager.instance.setLocale('ar');
      
      await tester.pumpWidget(
        LocalizationProvider(
          defaultLocale: 'ar',
          child: Builder(
            builder: (context) {
              final direction = LocalizationProvider.getTextDirection(context);
              expect(direction, TextDirection.rtl);
              return Container();
            },
          ),
        ),
      );
    });

    testWidgets('getCurrentLocale returns correct locale', (WidgetTester tester) async {
      await tester.pumpWidget(
        LocalizationProvider(
          defaultLocale: 'ur',
          child: Builder(
            builder: (context) {
              final locale = LocalizationProvider.getCurrentLocale(context);
              expect(locale, 'ur');
              return Container();
            },
          ),
        ),
      );
    });
  });
}