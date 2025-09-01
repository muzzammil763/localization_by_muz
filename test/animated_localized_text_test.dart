import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

void main() {
  group('AnimatedLocalizedText Tests', () {
    late LocalizationManager manager;

    setUp(() {
      manager = LocalizationManager.instance;
    });

    tearDown(() {
      manager.dispose();
    });

    testWidgets('AnimatedLocalizedText renders with default rotation transition',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {
        'en': 'Hello',
        'fr': 'Bonjour',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'hello',
                translations: translations,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.byType(RotationTransition), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText animates on locale change',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {
        'en': 'Hello World',
        'fr': 'Bonjour le Monde',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'greeting',
                translations: translations,
                duration: Duration(milliseconds: 100),
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Hello World'), findsOneWidget);

      // Change locale
      manager.setLocale('fr');
      await tester.pump();

      // During animation, both texts might be present
      await tester.pump(const Duration(milliseconds: 50));
      
      // After animation completes
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Bonjour le Monde'), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText with scale transition',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {'en': 'Test'};

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'test',
                translations: translations,
                transitionType: AnimatedLocalizedTextTransition.scale,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(ScaleTransition), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText with fade transition',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {'en': 'Fade Text'};

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'fade',
                translations: translations,
                transitionType: AnimatedLocalizedTextTransition.fade,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Fade Text'), findsOneWidget);
      expect(find.byType(FadeTransition), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText with slide transition',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {'en': 'Slide Text'};

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'slide',
                translations: translations,
                transitionType: AnimatedLocalizedTextTransition.slide,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Slide Text'), findsOneWidget);
      expect(find.byType(SlideTransition), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText with 3D rotation transition',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {'en': 'Rotate Text'};

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'rotate',
                translations: translations,
                transitionType: AnimatedLocalizedTextTransition.rotationY,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Rotate Text'), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsOneWidget);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText respects text direction for RTL',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'ar',
        skipAssetLoading: true,
      );

      const translations = {'ar': 'مرحبا'};

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'ar',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'rtl_text',
                translations: translations,
              ),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('مرحبا'));
      expect(textWidget.textDirection, TextDirection.rtl);
    });

    testWidgets('AnimatedLocalizedText with custom style and properties',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {'en': 'Styled Text'};
      const textStyle = TextStyle(fontSize: 24, color: Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'styled',
                translations: translations,
                style: textStyle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Styled Text'));
      expect(textWidget.style, textStyle);
      expect(textWidget.textAlign, TextAlign.center);
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });

    testWidgets('AnimatedLocalizedText with inline translations',
        (WidgetTester tester) async {
      await manager.initialize(defaultLocale: 'en');

      const inlineTranslations = {
        'en': 'Inline English',
        'fr': 'Inline French',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'fallback',
                translations: inlineTranslations,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Inline English'), findsOneWidget);

      // Change locale
      manager.setLocale('fr');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Inline French'), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText with arguments interpolation',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {'en': 'Hello {name}!'};

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'greeting_with_name',
                translations: translations,
                args: {'name': 'John'},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hello John!'), findsOneWidget);
    });

    testWidgets('AnimatedLocalizedText key changes on locale change',
        (WidgetTester tester) async {
      await manager.initialize(
        defaultLocale: 'en',
        skipAssetLoading: true,
      );

      const translations = {
        'en': 'English',
        'fr': 'French',
      };

      await tester.pumpWidget(
        MaterialApp(
          home: LocalizationProvider(
            defaultLocale: 'en',
            child: const Scaffold(
              body: AnimatedLocalizedText(
                'key_test',
                translations: translations,
              ),
            ),
          ),
        ),
      );

      // Get initial key
      final initialText = tester.widget<Text>(find.text('English'));
      final initialKey = initialText.key as ValueKey<String>;
      expect(initialKey.value, 'en_English');

      // Change locale
      manager.setLocale('fr');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Get new key
      final newText = tester.widget<Text>(find.text('French'));
      final newKey = newText.key as ValueKey<String>;
      expect(newKey.value, 'fr_French');
      expect(newKey.value, isNot(equals(initialKey.value)));
    });
  });

  group('AnimatedLocalizedTextTransition Enum Tests', () {
    test('enum has all expected values', () {
      expect(AnimatedLocalizedTextTransition.values.length, 5);
      expect(AnimatedLocalizedTextTransition.values, contains(AnimatedLocalizedTextTransition.rotation));
      expect(AnimatedLocalizedTextTransition.values, contains(AnimatedLocalizedTextTransition.scale));
      expect(AnimatedLocalizedTextTransition.values, contains(AnimatedLocalizedTextTransition.fade));
      expect(AnimatedLocalizedTextTransition.values, contains(AnimatedLocalizedTextTransition.slide));
      expect(AnimatedLocalizedTextTransition.values, contains(AnimatedLocalizedTextTransition.rotationY));
    });
  });
}