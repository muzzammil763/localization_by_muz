import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('AnimatedLocalizedText Animation Fix Tests', () {
    setUp(() {
      LocalizationManager.instance.reset();
    });

    testWidgets('AnimatedLocalizedText animates on locale change', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      AnimatedLocalizedText(
                        'welcome',
                        translations: const {
                          'en': 'Welcome',
                          'fr': 'Bienvenue',
                          'es': 'Bienvenido',
                        },
                        transitionType: AnimatedLocalizedTextTransition.rotation,
                        duration: const Duration(milliseconds: 300),
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                        child: const Text('Switch to French'),
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'es'),
                        child: const Text('Switch to Spanish'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Wait for initial setup
      await tester.pumpAndSettle();

      // Verify initial text
      expect(find.text('Welcome'), findsOneWidget);

      // Change to French
      await tester.tap(find.text('Switch to French'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 150)); // Mid animation
      await tester.pumpAndSettle(); // Complete animation

      // Verify French text appears
      expect(find.text('Bienvenue'), findsOneWidget);
      expect(find.text('Welcome'), findsNothing);

      // Change to Spanish
      await tester.tap(find.text('Switch to Spanish'));
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 150)); // Mid animation
      await tester.pumpAndSettle(); // Complete animation

      // Verify Spanish text appears
      expect(find.text('Bienvenido'), findsOneWidget);
      expect(find.text('Bienvenue'), findsNothing);
    });

    testWidgets('AnimatedLocalizedText with different transition types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      AnimatedLocalizedText(
                        'hello',
                        translations: const {
                          'en': 'Hello',
                          'fr': 'Bonjour',
                        },
                        transitionType: AnimatedLocalizedTextTransition.scale,
                        duration: const Duration(milliseconds: 200),
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                        child: const Text('Change Language'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Hello'), findsOneWidget);

      await tester.tap(find.text('Change Language'));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Bonjour'), findsOneWidget);
      expect(find.text('Hello'), findsNothing);
    });

    testWidgets('AnimatedLocalizedText key changes on locale change', (WidgetTester tester) async {
      Key? firstKey;
      Key? secondKey;

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      AnimatedLocalizedText(
                        'test',
                        translations: const {
                          'en': 'Test',
                          'fr': 'Test', // Same text content
                        },
                        transitionType: AnimatedLocalizedTextTransition.fade,
                      ),
                      ElevatedButton(
                        onPressed: () => LocalizationProvider.setLocale(context, 'fr'),
                        child: const Text('Change'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // Get the key of the first Text widget
      final firstTextFinder = find.byType(Text).first;
      final firstTextWidget = tester.widget<Text>(firstTextFinder);
      firstKey = firstTextWidget.key;

      // Change locale
      await tester.tap(find.text('Change'));
      await tester.pump();
      await tester.pumpAndSettle();

      // Get the key of the Text widget after locale change
      final secondTextFinder = find.byType(Text).first;
      final secondTextWidget = tester.widget<Text>(secondTextFinder);
      secondKey = secondTextWidget.key;

      // Keys should be different even if text content is the same
      expect(firstKey, isNotNull);
      expect(secondKey, isNotNull);
      expect(firstKey, isNot(equals(secondKey)));
    });
  });
}