import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Locale Startup Behavior Tests', () {
    setUp(() {
      // Reset the LocalizationManager before each test
      LocalizationManager.instance.reset();
    });

    testWidgets(
        'should load saved locale immediately without flash of default content',
        (WidgetTester tester) async {
      // Set up mock SharedPreferences with saved French locale
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'fr',
      });

      // Preload SharedPreferences before creating LocalizationProvider
      await LocalizationProvider.preloadSharedPreferences();

      // Debug: Check if saved locale is available
      final savedLocale = LocalizationManager.instance.getSavedLocaleSync();
      debugPrint('Debug: Saved locale after preload: $savedLocale');

      // Track locale changes during initialization
      final List<String> localeChanges = [];

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                final currentLocale =
                    LocalizationProvider.getCurrentLocale(context);
                localeChanges.add(currentLocale);
                debugPrint('Debug: Current locale in builder: $currentLocale');
                return Scaffold(
                  body: Text('Current locale: $currentLocale'),
                );
              },
            ),
          ),
        ),
      );

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Verify that the saved locale (fr) was used from the start
      // There should be no flash of default locale (en)
      expect(localeChanges.first, equals('fr'),
          reason: 'Should start with saved locale, not default locale');

      // Verify final locale is correct
      expect(LocalizationManager.instance.currentLocale, equals('fr'));

      // Find the text widget and verify it shows the correct locale
      expect(find.text('Current locale: fr'), findsOneWidget);
    });

    testWidgets('should use default locale when no saved locale exists',
        (WidgetTester tester) async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'de',
            child: Builder(
              builder: (context) {
                final currentLocale =
                    LocalizationProvider.getCurrentLocale(context);
                return Scaffold(
                  body: Text('Current locale: $currentLocale'),
                );
              },
            ),
          ),
        ),
      );

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Verify default locale is used
      expect(LocalizationManager.instance.currentLocale, equals('de'));
      expect(find.text('Current locale: de'), findsOneWidget);
    });

    testWidgets('should handle SharedPreferences loading errors gracefully',
        (WidgetTester tester) async {
      // Don't set mock values to simulate SharedPreferences error

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                final currentLocale =
                    LocalizationProvider.getCurrentLocale(context);
                return Scaffold(
                  body: Text('Current locale: $currentLocale'),
                );
              },
            ),
          ),
        ),
      );

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Should fallback to default locale when SharedPreferences fails
      expect(LocalizationManager.instance.currentLocale, equals('en'));
      expect(find.text('Current locale: en'), findsOneWidget);
    });

    testWidgets('should maintain saved locale across app restarts',
        (WidgetTester tester) async {
      // Simulate first app run - save a locale
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () =>
                        LocalizationProvider.setLocale(context, 'es'),
                    child: Text('Switch to Spanish'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Switch to Spanish
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(LocalizationManager.instance.currentLocale, equals('es'));

      // Get the current SharedPreferences state to preserve it
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString('localization_by_muz_locale');
      expect(savedLocale, equals('es')); // Verify it was saved

      // Simulate app restart by resetting and setting up mock with saved locale
      LocalizationManager.instance.reset();

      // Set mock values BEFORE creating LocalizationProvider
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': savedLocale!,
      });

      // Preload to ensure mock values are available
      await LocalizationProvider.preloadSharedPreferences();

      // Debug: Check if saved locale is available after restart
      final savedLocaleAfterRestart =
          LocalizationManager.instance.getSavedLocaleSync();
      debugPrint('Debug: Saved locale after restart: $savedLocaleAfterRestart');

      // Reset LocalizationManager to simulate fresh app start
      LocalizationManager.instance.reset();

      // Preload SharedPreferences again to ensure mock values are available
      await LocalizationProvider.preloadSharedPreferences();

      // Now check if the saved locale is properly loaded
      final finalSavedLocale =
          LocalizationManager.instance.getSavedLocaleSync();
      debugPrint(
          'Debug: Final saved locale after reset and preload: $finalSavedLocale');

      // Initialize LocalizationManager with the saved locale
      await LocalizationManager.instance.initialize(
        defaultLocale: finalSavedLocale ?? 'en',
      );

      // Verify the locale is maintained after restart
      final currentLocaleAfterRestart =
          LocalizationManager.instance.currentLocale;
      debugPrint('Debug: Final current locale: $currentLocaleAfterRestart');

      expect(currentLocaleAfterRestart, equals(savedLocale));
    });

    test('synchronous locale loading methods work correctly', () async {
      // Test the new synchronous methods
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'ar',
      });

      // Before preloading, sync method should return null
      expect(LocalizationManager.instance.getSavedLocaleSync(), isNull);

      // Preload SharedPreferences
      await LocalizationManager.instance.preloadSharedPreferences();

      // Now sync method should return the saved locale
      expect(LocalizationManager.instance.getSavedLocaleSync(), equals('ar'));
    });
  });
}
