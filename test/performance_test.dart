import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('Performance Tests', () {
    late LocalizationManager manager;

    setUp(() {
      manager = LocalizationManager.instance;
    });

    tearDown(() {
      manager.dispose();
    });

    test('rapid locale changes perform well', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        manager.setLocale('en');
        manager.setLocale('fr');
        manager.setLocale('es');
        manager.setLocale('de');
        manager.setLocale('ar');
      }

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('large number of translations perform well', () {
      final largeTranslations = <String, String>{};
      for (int i = 0; i < 10000; i++) {
        largeTranslations['lang$i'] = 'Translation $i';
      }

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        'test'.localize(largeTranslations);
      }

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    test('multiple listeners perform well', () {
      final listeners = <VoidCallback>[];

      for (int i = 0; i < 100; i++) {
        listener() {}
        listeners.add(listener);
        manager.addListener(listener);
      }

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        manager.setLocale('en');
        manager.setLocale('fr');
      }

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500));

      for (final listener in listeners) {
        manager.removeListener(listener);
      }
    });

    test('string localization with large maps performs well', () {
      final largeMap = <String, String>{};
      for (int i = 0; i < 1000; i++) {
        largeMap['lang$i'] = 'Value $i';
      }

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        'test'.localize(largeMap);
      }

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });

    testWidgets('UI updates perform well with many localized widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: ListView.builder(
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          'Item $index'.localize({
                            'en': 'Item $index',
                            'fr': 'Élément $index',
                            'es': 'Elemento $index',
                          }),
                        ),
                        subtitle: Text(
                          'Description'.localize({
                            'en': 'Description',
                            'fr': 'Description',
                            'es': 'Descripción',
                          }),
                        ),
                      );
                    },
                  ),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () =>
                        LocalizationProvider.setLocale(context, 'fr'),
                    child: const Icon(Icons.language),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final stopwatch = Stopwatch()..start();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      expect(find.textContaining('Élément'), findsWidgets);
    });

    test('memory usage remains stable with repeated operations', () {
      final initialListenerCount = manager.listeners.length;

      for (int i = 0; i < 1000; i++) {
        listener() {}
        manager.addListener(listener);
        manager.removeListener(listener);
      }

      expect(manager.listeners.length, equals(initialListenerCount));

      for (int i = 0; i < 1000; i++) {
        manager.setLocale('en');
        manager.setLocale('fr');
        'test$i'.localize({'en': 'test', 'fr': 'test'});
      }
    });

    testWidgets('rapid widget rebuilds handle localization efficiently', (
      WidgetTester tester,
    ) async {
      var rebuildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: StatefulBuilder(
              builder: (context, setState) {
                rebuildCount++;
                return Scaffold(
                  body: Column(
                    children: [
                      Text('Hello'.localize({'en': 'Hello', 'fr': 'Bonjour'})),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: const Text('Rebuild'),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            LocalizationProvider.setLocale(context, 'fr'),
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

      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text('Rebuild'));
        await tester.pump();
      }

      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500));
      expect(rebuildCount, greaterThan(10));
    });
  });
}
