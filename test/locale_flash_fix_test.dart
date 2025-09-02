import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('Locale Flash Fix Tests', () {
    setUp(() {
      LocalizationManager.instance.reset();
    });

    test('getSavedLocaleSync returns correct locale after preloading', () async {
      // Set up a saved locale in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'es',
      });

      // Preload SharedPreferences
      await LocalizationProvider.preloadSharedPreferences();

      // Verify that getSavedLocaleSync works after preloading
      expect(LocalizationManager.instance.getSavedLocaleSync(), equals('es'));
    });

    test('getSavedLocaleSync returns null when no saved locale exists', () async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});

      // Preload SharedPreferences
      await LocalizationProvider.preloadSharedPreferences();

      // Verify that getSavedLocaleSync returns null
      expect(LocalizationManager.instance.getSavedLocaleSync(), isNull);
    });

    test('preloadSharedPreferences caches SharedPreferences instance', () async {
      // Set up some preferences
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'fr',
        'other_key': 'other_value',
      });

      // Preload SharedPreferences
      await LocalizationProvider.preloadSharedPreferences();

      // Verify that the locale can be retrieved synchronously
      expect(LocalizationManager.instance.getSavedLocaleSync(), equals('fr'));
    });

    testWidgets('LocalizationProvider uses FutureBuilder for initial locale loading', (WidgetTester tester) async {
      // Set up a saved locale
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'de',
      });

      bool widgetBuilt = false;

      // Create a test app
      await tester.pumpWidget(
        LocalizationProvider(
          defaultLocale: 'en',
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final inherited = LocalizationProvider.of(context);
                  if (inherited == null || !inherited.isInitialized) {
                    return const SizedBox.shrink();
                  }
                  
                  widgetBuilt = true;
                  return const Text('App Content');
                },
              ),
            ),
          ),
        ),
      );

      // Initially, the widget should not be built (waiting for locale loading)
      expect(widgetBuilt, isFalse);
      expect(find.text('App Content'), findsNothing);

      // Wait for the locale to load
      await tester.pumpAndSettle();

      // Now the widget should be built
      expect(widgetBuilt, isTrue);
      expect(find.text('App Content'), findsOneWidget);
      
      // Verify the current locale is German
      expect(LocalizationManager.instance.currentLocale, equals('de'));
    });

    testWidgets('LocalizationProvider shows empty widget while loading locale', (WidgetTester tester) async {
      // Set up a saved locale
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'it',
      });

      // Create a test app
      await tester.pumpWidget(
        LocalizationProvider(
          defaultLocale: 'en',
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final inherited = LocalizationProvider.of(context);
                  if (inherited == null || !inherited.isInitialized) {
                    return const SizedBox.shrink();
                  }
                  
                  return const Text('Loaded Content');
                },
              ),
            ),
          ),
        ),
      );

      // Initially, should show empty widget (SizedBox.shrink)
      expect(find.text('Loaded Content'), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);

      // Wait for the locale to load
      await tester.pumpAndSettle();

      // Now should show the actual content
      expect(find.text('Loaded Content'), findsOneWidget);
      expect(LocalizationManager.instance.currentLocale, equals('it'));
    });
  });
}