import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';
import 'package:localization_example/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Create a composite asset loader that combines default and per-locale loading
    const assetLoader = CompositeAssetLoader([
      DefaultAssetLoader(),

      /// Load from lib/localization.json (backward compatibility)
      PerLocaleAssetLoader(
        basePath: 'assets/i18n',
        supportedLocales: ['en', 'fr', 'es'],
      ),

      /// Load from per-locale files
    ]);

    return LocalizationProvider(
      defaultLocale: 'en',
      assetLoader: assetLoader,
      enableMissingKeyLogging: true,
      showDebugOverlay: true,
      onMissingKey: (key, locale) {
        debugPrint('🔍 Missing translation: "$key" for locale: $locale');
      },
      child: LocalizedBuilder(
        builder: (context, locale) {
          return MaterialApp(
            title: "appTitle".localize(),
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
