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
    return LocalizationProvider(
      defaultLocale: 'en',
      assetLoader: const DefaultAssetLoader(),
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
