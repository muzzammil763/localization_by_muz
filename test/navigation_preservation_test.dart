import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('Navigation Preservation Tests', () {
    setUp(() async {
      // Initialize LocalizationManager for testing
      await LocalizationManager.instance.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );
    });

    tearDown(() {
      LocalizationManager.instance.reset();
    });
    testWidgets('navigation stack is preserved when changing locale',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Home'.localize({
                      'en': 'Home',
                      'es': 'Inicio',
                    })),
                  ),
                  body: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Second Screen'.localize({
                                    'en': 'Second Screen',
                                    'es': 'Segunda Pantalla',
                                  })),
                                ),
                                body: Column(
                                  children: [
                                    Text('Welcome to second screen'.localize({
                                      'en': 'Welcome to second screen',
                                      'es': 'Bienvenido a la segunda pantalla',
                                    })),
                                    ElevatedButton(
                                      onPressed: () {
                                        LocalizationProvider.setLocale(
                                            context, 'es');
                                      },
                                      child: Text('Change Language'.localize({
                                        'en': 'Change Language',
                                        'es': 'Cambiar Idioma',
                                      })),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text('Go to Second Screen'.localize({
                          'en': 'Go to Second Screen',
                          'es': 'Ir a Segunda Pantalla',
                        })),
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

      // Navigate to second screen
      await tester.tap(find.text('Go to Second Screen'));
      await tester.pumpAndSettle();

      // Verify we're on the second screen (English)
      expect(find.text('Second Screen'), findsOneWidget);
      expect(find.text('Welcome to second screen'), findsOneWidget);

      // Change language to Spanish
      await tester.tap(find.text('Change Language'));
      await tester.pumpAndSettle();

      // Verify we're still on the second screen with Spanish text (navigation preserved)
      expect(find.text('Segunda Pantalla'), findsOneWidget);
      expect(find.text('Bienvenido a la segunda pantalla'), findsOneWidget);

      // Verify we can navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should be back on home screen with Spanish text
      expect(find.text('Inicio'), findsOneWidget);
    });

    testWidgets('deep navigation stack is preserved when changing locale',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Home'.localize({
                      'en': 'Home',
                      'es': 'Inicio',
                    })),
                  ),
                  body: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: Text('Second Screen'.localize({
                                    'en': 'Second Screen',
                                    'es': 'Segunda Pantalla',
                                  })),
                                ),
                                body: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              appBar: AppBar(
                                                title: Text('Third Screen'.localize({
                                                  'en': 'Third Screen',
                                                  'es': 'Tercera Pantalla',
                                                })),
                                              ),
                                              body: Column(
                                                children: [
                                                  Text('Deep navigation test'.localize({
                                                    'en': 'Deep navigation test',
                                                    'es': 'Prueba de navegación profunda',
                                                  })),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      LocalizationProvider.setLocale(
                                                          context, 'es');
                                                    },
                                                    child: Text('Change Language'.localize({
                                                      'en': 'Change Language',
                                                      'es': 'Cambiar Idioma',
                                                    })),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Go to Third Screen'.localize({
                                        'en': 'Go to Third Screen',
                                        'es': 'Ir a Tercera Pantalla',
                                      })),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text('Go to Second Screen'.localize({
                          'en': 'Go to Second Screen',
                          'es': 'Ir a Segunda Pantalla',
                        })),
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

      // Navigate to second screen
      await tester.tap(find.text('Go to Second Screen'));
      await tester.pumpAndSettle();

      // Navigate to third screen
      await tester.tap(find.text('Go to Third Screen'));
      await tester.pumpAndSettle();

      // Verify we're on the third screen (English)
      expect(find.text('Third Screen'), findsOneWidget);
      expect(find.text('Deep navigation test'), findsOneWidget);

      // Change language to Spanish
      await tester.tap(find.text('Change Language'));
      await tester.pumpAndSettle();

      // Should still be on third screen with Spanish text (navigation preserved)
      expect(find.text('Tercera Pantalla'), findsOneWidget);
      expect(find.text('Prueba de navegación profunda'), findsOneWidget);

      // Verify we can navigate back twice to reach home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Should be back on home screen with Spanish text
      expect(find.text('Inicio'), findsOneWidget);
    });
  });
}