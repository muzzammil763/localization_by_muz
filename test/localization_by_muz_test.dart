import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  // Ensure the singleton is reset after each test to avoid state leakage
  tearDown(() {
    LocalizationManager.instance.dispose();
  });

  group('String Extension Tests', () {
    test('inline localization with translations map', () {
      final translations = {
        'en': 'Hello World',
        'fr': 'Bonjour Le Monde',
        'es': 'Hola Mundo',
      };

      expect('test'.localize(translations), 'Hello World');
    });

    test('inline localization returns original string when locale not found', () {
      final translations = {
        'fr': 'Bonjour Le Monde',
        'es': 'Hola Mundo',
      };

      expect('Hello World'.localize(translations), 'Hello World');
    });

    test('inline localization without translations map uses LocalizationManager', () {
      expect('someKey'.localize(), 'someKey');
    });

    test('localizeArgs supports multiple placeholders (inline)', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {
        'en': 'Hi {first} {last}',
      };

      expect(
        'fullName'.localizeArgs(
          translations: translations,
          args: {'first': 'Muzamil', 'last': 'Ghafoor'},
        ),
        'Hi Muzamil Ghafoor',
      );
    });

    test('localizeArgs supports repeated placeholders (inline)', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {'en': '{name} {name}'};

      expect(
        'repeat'.localizeArgs(translations: translations, args: {'name': 'Alex'}),
        'Alex Alex',
      );
    });

    test('localizeArgs stringifies non-string args (inline)', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {'en': 'You have {count} items'};

      expect(
        'items'.localizeArgs(translations: translations, args: {'count': 3}),
        'You have 3 items',
      );
    });

    test('localizeArgs leaves unknown placeholders unchanged (inline)', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {'en': 'Hi {name} {unknown}'};

      expect(
        'unknown'.localizeArgs(translations: translations, args: {'name': 'A'}),
        'Hi A {unknown}',
      );
    });
  });

  group('LocalizationManager Tests', () {
    late LocalizationManager manager;

    setUp(() {
      manager = LocalizationManager.instance;
    });

    test('singleton instance', () {
      final manager1 = LocalizationManager.instance;
      final manager2 = LocalizationManager.instance;
      expect(manager1, same(manager2));
    });

    test('default locale is set correctly', () {
      expect(manager.currentLocale, 'en');
    });

    test('setLocale changes current locale', () {
      manager.setLocale('fr');
      expect(manager.currentLocale, 'fr');
      
      manager.setLocale('en');
      expect(manager.currentLocale, 'en');
    });

    test('translate returns key when no translation found', () {
      final result = manager.translate('nonExistentKey');
      expect(result, 'nonExistentKey');
    });

    test('listeners are notified when locale changes', () {
      var notified = false;
      void listener() {
        notified = true;
      }

      manager.addListener(listener);
      manager.setLocale('fr');
      
      expect(notified, true);
      
      manager.removeListener(listener);
    });

    test('same locale does not trigger notification', () {
      var notificationCount = 0;
      void listener() {
        notificationCount++;
      }

      manager.addListener(listener);
      final currentLocale = manager.currentLocale;
      manager.setLocale(currentLocale);
      
      expect(notificationCount, 0);
      
      manager.removeListener(listener);
    });

    test('removeListener works correctly', () {
      var notified = false;
      void listener() {
        notified = true;
      }

      manager.addListener(listener);
      manager.removeListener(listener);
      manager.setLocale('es');
      
      expect(notified, false);
    });

    test('dispose clears all listeners', () {
      var notified = false;
      void listener() {
        notified = true;
      }

      manager.addListener(listener);
      manager.dispose();
      manager.setLocale('de');
      
      expect(notified, false);
    });
  });

  group('LocalizationProvider Widget Tests', () {
    testWidgets('LocalizationProvider renders child correctly', (WidgetTester tester) async {
      const testWidget = Text('Test Child');
      
      await tester.pumpWidget(
        const MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: testWidget,
          ),
        ),
      );

      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('LocalizationProvider.of returns correct instance', (WidgetTester tester) async {
      dynamic provider;
      
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'fr',
            child: Builder(
              builder: (context) {
                provider = LocalizationProvider.of(context);
                return const Text('Test');
              },
            ),
          ),
        ),
      );

      // Wait for async initialization inside LocalizationProvider
      await tester.pumpAndSettle();

      expect(provider, isNotNull);
      expect(provider!.locale, 'fr');
    });

    testWidgets('setLocale updates LocalizationManager', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                  child: const Text('Change Language'),
                );
              },
            ),
          ),
        ),
      );

      expect(LocalizationManager.instance.currentLocale, 'en');
      
      await tester.tap(find.text('Change Language'));
      await tester.pump();
      
      expect(LocalizationManager.instance.currentLocale, 'fr');
    });
  });

  group('Integration Tests', () {
    testWidgets('complete localization flow with inline translations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text(
                        'Hello World'.localize({
                          'en': 'Hello World',
                          'fr': 'Bonjour Le Monde',
                          'es': 'Hola Mundo',
                        }),
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                        child: const Text('Change to French'),
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'es'),
                        child: const Text('Change to Spanish'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);

      await tester.tap(find.text('Change to French'));
      await tester.pump();

      expect(find.text('Bonjour Le Monde'), findsOneWidget);
      expect(find.text('Hello World'), findsNothing);

      await tester.tap(find.text('Change to Spanish'));
      await tester.pump();

      expect(find.text('Hola Mundo'), findsOneWidget);
      expect(find.text('Bonjour Le Monde'), findsNothing);
    });

    testWidgets('multiple widgets update simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text(
                        'Welcome'.localize({
                          'en': 'Welcome',
                          'fr': 'Bienvenue',
                        }),
                      ),
                      Text(
                        'Goodbye'.localize({
                          'en': 'Goodbye',
                          'fr': 'Au revoir',
                        }),
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                        child: const Text('Switch Language'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Goodbye'), findsOneWidget);

      await tester.tap(find.text('Switch Language'));
      await tester.pump();

      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.text('Au revoir'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);
      expect(find.text('Goodbye'), findsNothing);
    });

    testWidgets('nested LocalizationProvider maintains state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: LocalizationProvider(
              defaultLocale: 'fr',
              child: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Text(
                      'Test'.localize({
                        'en': 'English Test',
                        'fr': 'Test Français',
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.textContaining('Test'), findsOneWidget);
    });
  });

  group('Edge Cases and Error Handling', () {
    test('empty translations map returns original string', () {
      const translations = <String, String>{};
      expect('test'.localize(translations), 'test');
    });

    test('null values in translations map are handled gracefully', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {
        'en': 'English',
        'fr': 'French',
      };
      expect('test'.localize(translations), 'English');
    });

    test('special characters in translations work correctly', () {
      const translations = {
        'en': 'Hello! @#\$%^&*()',
        'fr': 'Bonjour! éàçù',
        'ar': 'مرحبا بالعالم',
      };
      
      LocalizationManager.instance.setLocale('ar');
      expect('test'.localize(translations), 'مرحبا بالعالم');
      
      LocalizationManager.instance.setLocale('fr');
      expect('test'.localize(translations), 'Bonjour! éàçù');
    });

    test('very long strings are handled correctly', () {
      final longString = 'a' * 1000;
      final translations = {
        'en': longString,
        'fr': 'Short',
      };
      
      LocalizationManager.instance.setLocale('en');
      expect('test'.localize(translations), longString);
    });

    testWidgets('rapid locale changes are handled correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text(
                        'Test'.localize({
                          'en': 'English',
                          'fr': 'French',
                          'es': 'Spanish',
                        }),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          LocalizationProvider.setLocale(context, 'fr');
                          LocalizationProvider.setLocale(context, 'es');
                          LocalizationProvider.setLocale(context, 'en');
                        },
                        child: const Text('Rapid Change'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Rapid Change'));
      await tester.pump();

      expect(find.text('English'), findsOneWidget);
    });
  });

  group('Interpolation Tests (Inline)', () {
    test('localizeArgs replaces placeholders with args (inline)', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {
        'en': 'Hello {name}',
        'fr': 'Bonjour {name}',
      };

      expect('greet'.localizeArgs(translations: translations, args: {'name': 'Muz'}),
          'Hello Muz');

      LocalizationManager.instance.setLocale('fr');
      expect('greet'.localizeArgs(translations: translations, args: {'name': 'Muz'}),
          'Bonjour Muz');
    });

    test('localizeArgs leaves missing placeholders unchanged (inline)', () {
      LocalizationManager.instance.setLocale('en');
      const translations = {'en': 'Welcome, {name}!'};

      expect('welcome'.localizeArgs(translations: translations), 'Welcome, {name}!');
    });

    testWidgets('LocalizedText supports args and updates across locales (inline)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      LocalizedText(
                        'greet',
                        translations: const {
                          'en': 'Hello {name}',
                          'fr': 'Bonjour {name}',
                        },
                        args: const {'name': 'Alex'},
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                        child: const Text('FR'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Hello Alex'), findsOneWidget);

      await tester.tap(find.text('FR'));
      await tester.pump();

      expect(find.text('Bonjour Alex'), findsOneWidget);
    });
  });
}