import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localization_by_muz/src/localization_manager.dart';

void main() {
  group('Locale Persistence Tests', () {
    setUp(() {
      // Reset LocalizationManager before each test
      LocalizationManager.instance.reset();
    });

    tearDown(() {
      // Clean up after each test
      LocalizationManager.instance.reset();
    });

    testWidgets('should save locale to SharedPreferences when setLocale is called', (WidgetTester tester) async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize the manager
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Change locale
      LocalizationManager.instance.setLocale('fr');
      
      // Wait for async operations to complete
      await tester.pumpAndSettle();
      
      // Verify locale was saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('localization_by_muz_locale'), equals('fr'));
      expect(LocalizationManager.instance.currentLocale, equals('fr'));
    });

    testWidgets('should load saved locale from SharedPreferences on initialization', (WidgetTester tester) async {
      // Set up mock SharedPreferences with a saved locale
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'es',
      });
      
      // Initialize the manager (should load saved locale)
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Verify the saved locale was loaded
      expect(LocalizationManager.instance.currentLocale, equals('es'));
    });

    testWidgets('should use default locale when no saved locale exists', (WidgetTester tester) async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize the manager with default locale
      await LocalizationManager.instance.initialize(
        defaultLocale: 'de',
        skipAssetLoading: true,
      );
      
      // Verify default locale is used
      expect(LocalizationManager.instance.currentLocale, equals('de'));
    });

    testWidgets('should persist locale changes across multiple setLocale calls', (WidgetTester tester) async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize the manager
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Change locale multiple times
      LocalizationManager.instance.setLocale('fr');
      await tester.pumpAndSettle();
      
      LocalizationManager.instance.setLocale('ar');
      await tester.pumpAndSettle();
      
      LocalizationManager.instance.setLocale('ur');
      await tester.pumpAndSettle();
      
      // Verify final locale was saved
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('localization_by_muz_locale'), equals('ur'));
      expect(LocalizationManager.instance.currentLocale, equals('ur'));
    });

    testWidgets('should handle SharedPreferences errors gracefully', (WidgetTester tester) async {
      // This test simulates SharedPreferences being unavailable
      // The manager should still work with default locale
      
      // Initialize without mock (will use real SharedPreferences which might fail in tests)
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Should still work with default locale
      expect(LocalizationManager.instance.currentLocale, equals('en'));
      
      // setLocale should still work even if saving fails
      LocalizationManager.instance.setLocale('fr');
      expect(LocalizationManager.instance.currentLocale, equals('fr'));
    });

    testWidgets('should not save locale if it is the same as current', (WidgetTester tester) async {
      // Set up mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize the manager
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Set locale to the same value (should not trigger save)
      LocalizationManager.instance.setLocale('en');
      await tester.pumpAndSettle();
      
      // Verify no unnecessary save occurred (locale should still be null in prefs since it's the default)
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('localization_by_muz_locale'), isNull);
    });

    testWidgets('should clear text direction cache when locale changes with persistence', (WidgetTester tester) async {
      // Clear any existing preferences
      SharedPreferences.setMockInitialValues({});
      
      // Initialize the manager
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Get initial text direction (LTR for English)
      final initialDirection = LocalizationManager.instance.textDirection;
      expect(initialDirection.name, equals('ltr'));
      
      // Change to RTL locale
      LocalizationManager.instance.setLocale('ar');
      await tester.pumpAndSettle();
      
      // Verify text direction changed to RTL
      final newDirection = LocalizationManager.instance.textDirection;
      expect(newDirection.name, equals('rtl'));
      
      // Verify locale was persisted
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('localization_by_muz_locale'), equals('ar'));
    });

    testWidgets('should restore RTL locale and text direction from SharedPreferences', (WidgetTester tester) async {
      // Set up mock SharedPreferences with RTL locale
      SharedPreferences.setMockInitialValues({
        'localization_by_muz_locale': 'ur',
      });
      
      // Initialize the manager (should load saved RTL locale)
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
      
      // Verify RTL locale and direction were restored
      expect(LocalizationManager.instance.currentLocale, equals('ur'));
      expect(LocalizationManager.instance.textDirection.name, equals('rtl'));
    });
  });
}