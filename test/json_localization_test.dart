import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('JSON Localization Tests', () {
    late LocalizationManager manager;

    setUp(() {
      manager = LocalizationManager.instance;
    });

    tearDown(() {
      manager.dispose();
    });

    group('JSON Loading Tests', () {
      testWidgets('loads JSON translations correctly', (WidgetTester tester) async {
        const mockTranslations = {
          "greeting": {
            "en": "Hello",
            "fr": "Bonjour",
            "es": "Hola"
          },
          "farewell": {
            "en": "Goodbye",
            "fr": "Au revoir",
            "es": "Adiós"
          }
        };

        // Use MemoryAssetLoader for testing instead of mocking file system
        await manager.initialize(
          defaultLocale: 'en',
          assetLoader: MemoryAssetLoader(mockTranslations),
        );

        expect(manager.translate('greeting'), 'Hello');
        expect(manager.translate('farewell'), 'Goodbye');

        manager.setLocale('fr');
        expect(manager.translate('greeting'), 'Bonjour');
        expect(manager.translate('farewell'), 'Au revoir');

        manager.setLocale('es');
        expect(manager.translate('greeting'), 'Hola');
        expect(manager.translate('farewell'), 'Adiós');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      testWidgets('handles missing JSON file gracefully', (WidgetTester tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              throw Exception('File not found');
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect(manager.translate('nonExistentKey'), 'nonExistentKey');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      testWidgets('handles malformed JSON gracefully', (WidgetTester tester) async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return 'invalid json content {{{';
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect(manager.translate('anyKey'), 'anyKey');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      testWidgets('handles nested objects in JSON', (WidgetTester tester) async {
        const mockJsonData = {
          "validKey": {
            "en": "Valid Translation",
            "fr": "Traduction Valide"
          },
          "invalidKey": "This should be an object but is a string",
          "partialKey": {
            "en": "Only English",
          }
        };

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return json.encode(mockJsonData);
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect(manager.translate('validKey'), 'Valid Translation');
        expect(manager.translate('invalidKey'), 'invalidKey');
        expect(manager.translate('partialKey'), 'Only English');

        manager.setLocale('fr');
        expect(manager.translate('validKey'), 'Traduction Valide');
        expect(manager.translate('partialKey'), 'partialKey');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });
    });

    group('JSON Localization with String Extension', () {
      testWidgets('String.localize() works with JSON data', (WidgetTester tester) async {
        const mockJsonData = {
          "testKey": {
            "en": "Test Value",
            "fr": "Valeur de Test",
            "es": "Valor de Prueba"
          }
        };

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return json.encode(mockJsonData);
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect('testKey'.localize(), 'Test Value');

        manager.setLocale('fr');
        expect('testKey'.localize(), 'Valeur de Test');

        manager.setLocale('es');
        expect('testKey'.localize(), 'Valor de Prueba');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      test('String.localize() with inline translations overrides JSON', () {
        manager.setLocale('en');

        final inlineTranslations = {
          'en': 'Inline English',
          'fr': 'Inline French',
        };

        expect('testKey'.localize(inlineTranslations), 'Inline English');

        manager.setLocale('fr');
        expect('testKey'.localize(inlineTranslations), 'Inline French');
      });

      testWidgets('String.localizeArgs() replaces placeholders with args (JSON)',
          (WidgetTester tester) async {
        const mockJsonData = {
          "greetName": {
            "en": "Hello {name}",
            "fr": "Bonjour {name}"
          }
        };

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return json.encode(mockJsonData);
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect('greetName'.localizeArgs(args: {'name': 'Muz'}), 'Hello Muz');

        manager.setLocale('fr');
        expect('greetName'.localizeArgs(args: {'name': 'Muz'}), 'Bonjour Muz');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      testWidgets('LocalizedText uses args with JSON keys', (WidgetTester tester) async {
        const mockJsonData = {
          "welcomeName": {
            "en": "Welcome, {name}!",
            "fr": "Bienvenue, {name}!"
          }
        };

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return json.encode(mockJsonData);
            }
            return null;
          },
        );

        await tester.pumpWidget(
          MaterialApp(
            home: LocalizationProvider(
              defaultLocale: 'en',
              child: Builder(
                builder: (context) {
                  return Scaffold(
                    body: Column(
                      children: const [
                        LocalizedText('welcomeName', args: {'name': 'Alex'}),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('Welcome, Alex!'), findsOneWidget);

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });
    });

    group('Complex JSON Scenarios', () {
      testWidgets('handles large JSON files efficiently', (WidgetTester tester) async {
        final largeJsonData = <String, dynamic>{};
        
        for (int i = 0; i < 1000; i++) {
          largeJsonData['key$i'] = {
            'en': 'English Value $i',
            'fr': 'Valeur Française $i',
            'es': 'Valor Español $i',
          };
        }

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return json.encode(largeJsonData);
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect(manager.translate('key0'), 'English Value 0');
        expect(manager.translate('key500'), 'English Value 500');
        expect(manager.translate('key999'), 'English Value 999');

        manager.setLocale('fr');
        expect(manager.translate('key0'), 'Valeur Française 0');
        expect(manager.translate('key500'), 'Valeur Française 500');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });

      testWidgets('handles unicode and special characters in JSON', (WidgetTester tester) async {
        const mockJsonData = {
          "unicode": {
            "en": "Hello 🌍",
            "fr": "Bonjour 🌍",
            "ar": "مرحبا 🌍",
            "zh": "你好 🌍",
            "ja": "こんにちは 🌍"
          },
          "special": {
            "en": "Test @#\$%^&*()_+-={}|[]\\:;<>?,./",
            "fr": "Test éàçùë",
          }
        };

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'loadString' &&
                methodCall.arguments == 'lib/localization.json') {
              return json.encode(mockJsonData);
            }
            return null;
          },
        );

        await manager.initialize(defaultLocale: 'en');

        expect(manager.translate('unicode'), 'Hello 🌍');
        expect(manager.translate('special'), 'Test @#\$%^&*()_+-={}|[]\\:;<>?,./');

        manager.setLocale('ar');
        expect(manager.translate('unicode'), 'مرحبا 🌍');

        manager.setLocale('fr');
        expect(manager.translate('special'), 'Test éàçùë');

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('flutter/assets'),
          null,
        );
      });
    });
  });
}