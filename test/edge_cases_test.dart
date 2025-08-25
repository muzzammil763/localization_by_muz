import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('Edge Cases and Error Handling Tests', () {
    late LocalizationManager manager;

    setUp(() {
      manager = LocalizationManager.instance;
    });

    tearDown(() {
      manager.dispose();
    });

    group('String Edge Cases', () {
      test('empty string localization', () {
        expect(''.localize({'en': 'Not Empty', 'fr': 'Pas Vide'}), 'Not Empty');
        expect(''.localize(), '');
      });

      test('null-like strings', () {
        expect(
          'null'.localize({'en': 'Null Value', 'fr': 'Valeur Nulle'}),
          'Null Value',
        );
        expect(
          'undefined'.localize({'en': 'Undefined', 'fr': 'Indéfini'}),
          'Undefined',
        );
      });

      test('very long strings', () {
        final longKey = 'a' * 10000;
        final longValue = 'b' * 10000;

        expect(longKey.localize({'en': longValue}), longValue);
        expect(longKey.localize(), longKey);
      });

      test('strings with newlines and special characters', () {
        const multilineText = 'Line 1\nLine 2\r\nLine 3\tTabbed';
        const translations = {
          'en': multilineText,
          'fr': 'Ligne 1\nLigne 2\r\nLigne 3\tTabulé',
        };

        manager.setLocale('en');
        expect('multiline'.localize(translations), multilineText);

        manager.setLocale('fr');
        expect(
          'multiline'.localize(translations),
          'Ligne 1\nLigne 2\r\nLigne 3\tTabulé',
        );
      });

      test('strings with quotes and escape characters', () {
        const translations = {
          'en': 'He said "Hello" and she said \'Hi\'',
          'fr': 'Il a dit "Bonjour" et elle a dit \'Salut\'',
        };

        expect(
          'quotes'.localize(translations),
          'He said "Hello" and she said \'Hi\'',
        );
      });
    });

    group('Locale Edge Cases', () {
      test('invalid locale codes', () {
        manager.setLocale('');
        expect(manager.currentLocale, '');

        manager.setLocale('invalid-locale-123');
        expect(manager.currentLocale, 'invalid-locale-123');

        manager.setLocale('🇺🇸');
        expect(manager.currentLocale, '🇺🇸');
      });

      test('case sensitivity in locale codes', () {
        const translations = {
          'en': 'English',
          'EN': 'ENGLISH',
          'En': 'English Mixed',
        };

        manager.setLocale('en');
        expect('test'.localize(translations), 'English');

        manager.setLocale('EN');
        expect('test'.localize(translations), 'ENGLISH');

        manager.setLocale('En');
        expect('test'.localize(translations), 'English Mixed');
      });

      test('locale codes with special characters', () {
        const translations = {
          'en-US': 'American English',
          'en_GB': 'British English',
          'zh-Hans': 'Simplified Chinese',
        };

        manager.setLocale('en-US');
        expect('test'.localize(translations), 'American English');

        manager.setLocale('en_GB');
        expect('test'.localize(translations), 'British English');

        manager.setLocale('zh-Hans');
        expect('test'.localize(translations), 'Simplified Chinese');
      });
    });

    group('Translation Map Edge Cases', () {
      test('maps with null values', () {
        final translations = <String, String?>{'en': null, 'fr': 'French'};

        manager.setLocale('en');
        expect('test'.localize(translations.cast<String, String>()), 'test');

        manager.setLocale('fr');
        expect('test'.localize(translations.cast<String, String>()), 'French');
      });

      test('maps with duplicate keys different casing', () {
        const translations = {'en': 'lowercase', 'EN': 'UPPERCASE'};

        expect(translations.length, 2);

        manager.setLocale('en');
        expect('test'.localize(translations), 'lowercase');

        manager.setLocale('EN');
        expect('test'.localize(translations), 'UPPERCASE');
      });

      test('extremely large translation maps', () {
        final largeMap = <String, String>{};
        for (int i = 0; i < 100000; i++) {
          largeMap['locale$i'] = 'Translation $i';
        }

        manager.setLocale('locale50000');
        expect('test'.localize(largeMap), 'Translation 50000');

        manager.setLocale('nonexistent');
        expect('test'.localize(largeMap), 'test');
      });
    });

    group('Widget Edge Cases', () {
      testWidgets('LocalizationProvider with null child', (
        WidgetTester tester,
      ) async {
        expect(
          () => LocalizationProvider(defaultLocale: 'en', child: Container()),
          isA<LocalizationProvider>(),
        );
      });

      testWidgets('Multiple LocalizationProviders in widget tree', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: LocalizationProvider(
              defaultLocale: 'en',
              child: LocalizationProvider(
                defaultLocale: 'fr',
                child: LocalizationProvider(
                  defaultLocale: 'es',
                  child: Builder(
                    builder: (context) {
                      return Scaffold(
                        body: Text(
                          'Test'.localize({
                            'en': 'English',
                            'fr': 'French',
                            'es': 'Spanish',
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.textContaining('Test'), findsOneWidget);
      });

      testWidgets('LocalizationProvider.setLocale without context', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: ElevatedButton(
                    onPressed: () {
                      LocalizationProvider.setLocale(context, 'fr');
                    },
                    child: const Text('No Provider'),
                  ),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('No Provider'));
        await tester.pump();

        expect(manager.currentLocale, 'fr');
      });

      testWidgets('Widget disposal during locale change', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: LocalizationProvider(
              defaultLocale: 'en',
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Scaffold(
                    body: Column(
                      children: [
                        Text(
                          'Hello'.localize({'en': 'Hello', 'fr': 'Bonjour'}),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            LocalizationProvider.setLocale(context, 'fr');
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Scaffold(body: Text('New Page')),
                              ),
                            );
                          },
                          child: const Text('Change and Navigate'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Change and Navigate'));
        await tester.pumpAndSettle();

        expect(find.text('New Page'), findsOneWidget);
        expect(manager.currentLocale, 'fr');
      });
    });

    group('Concurrent Access Tests', () {
      test('concurrent locale changes', () {
        final futures = <Future<void>>[];

        for (int i = 0; i < 100; i++) {
          futures.add(
            Future.microtask(() {
              manager.setLocale('locale$i');
            }),
          );
        }

        expect(() => Future.wait(futures), returnsNormally);
      });

      test('concurrent listener modifications', () {
        final listeners = <VoidCallback>[];

        for (int i = 0; i < 50; i++) {
          listener() {}
          listeners.add(listener);
          Future.microtask(() => manager.addListener(listener));
        }

        for (int i = 0; i < 50; i++) {
          final index = i;
          Future.microtask(() {
            if (index < listeners.length) {
              manager.removeListener(listeners[index]);
            }
          });
        }

        expect(() => manager.setLocale('test'), returnsNormally);
      });
    });

    group('Memory and Resource Tests', () {
      test('repeated initialization does not leak memory', () async {
        manager.setLocale('en');

        for (int i = 0; i < 100; i++) {
          await manager.initialize(defaultLocale: 'en');
        }

        expect(manager.currentLocale, 'en');
      });

      test('massive listener churn', () {
        for (int i = 0; i < 10000; i++) {
          listener() {}
          manager.addListener(listener);
          manager.removeListener(listener);
        }

        expect(manager.listeners.length, 0);
      });
    });
  });
}
