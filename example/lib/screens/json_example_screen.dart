import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class JsonExampleScreen extends StatefulWidget {
  const JsonExampleScreen({super.key});

  @override
  State<JsonExampleScreen> createState() => _JsonExampleScreenState();
}

class _JsonExampleScreenState extends State<JsonExampleScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget _localeButton({
    required String code,
    required String currentLocale,
    required Widget label,
  }) {
    final bool selected = currentLocale == code;
    if (selected) {
      return Expanded(
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: () => LocalizationProvider.setLocale(context, code),
          child: label,
        ),
      );
    } else {
      return Expanded(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black),
            padding: EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: () => LocalizationProvider.setLocale(context, code),
          child: label,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LocalizedBuilder(
      builder: (context, locale) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text("jsonExample".localize()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "What is JSON Localization?".localize({
                              "en": "What is JSON Localization?",
                              "fr": "Qu'est-ce que la localisation JSON?",
                              "es": "¿Qué es la localización JSON?",
                              "de": "Was ist JSON-Lokalisierung?",
                              "ar": "ما هي ترجمة JSON؟",
                            }),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "JSON localization uses a localization.json file in your lib/ directory to store all translations. Simply use .localize() on a key string.".localize({
                              "en":
                                  "JSON localization uses a localization.json file in your lib/ directory to store all translations. Simply use .localize() on a key string.",
                              "fr":
                                  "La localisation JSON utilise un fichier localization.json dans votre répertoire lib/ pour stocker toutes les traductions. Utilisez simplement .localize() sur une chaîne de clé.",
                              "es":
                                  "La localización JSON usa un archivo localization.json en tu directorio lib/ para almacenar todas las traducciones. Simplemente usa .localize() en una cadena clave.",
                              "de":
                                  "JSON-Lokalisierung verwendet eine localization.json-Datei in Ihrem lib/-Verzeichnis, um alle Übersetzungen zu speichern. Verwenden Sie einfach .localize() auf einem Schlüssel-String.",
                              "ar":
                                  "تستخدم ترجمة JSON ملف localization.json في دليل lib/ لتخزين جميع الترجمات. ما عليك سوى استخدام .localize() على سلسلة مفتاح.",
                            }),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "Basic JSON Examples".localize({
                              "en": "Basic JSON Examples",
                              "fr": "Exemples JSON de base",
                              "es": "Ejemplos básicos de JSON",
                              "de": "Grundlegende JSON-Beispiele",
                              "ar": "أمثلة JSON الأساسية",
                            }),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "helloWorld".localize(),
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "welcome".localize(),
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "goodbye".localize(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "counter".localize(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "counterValue".localize(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_counter',
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontSize: 50,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Code Example:".localize({
                              "en": "Code Example:",
                              "fr": "Exemple de code:",
                              "es": "Ejemplo de código:",
                              "de": "Code-Beispiel:",
                              "ar": "مثال الكود:",
                            }),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Text("helloWorld".localize())',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'monospace',
                                    color: Colors.blue[800],
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,

                    children: [
                      _localeButton(
                        code: 'en',
                        currentLocale: locale,
                        label: Text(
                          'English'.localize({
                            "en": "English",
                            "fr": "Anglais",
                            "es": "Inglés",
                            "de": "Englisch",
                            "ar": "الإنجليزية",
                          }),
                        ),
                      ),
                      _localeButton(
                        code: 'fr',
                        currentLocale: locale,
                        label: Text(
                          'French'.localize({
                            "en": "French",
                            "fr": "Français",
                            "es": "Francés",
                            "de": "Französisch",
                            "ar": "الفرنسية",
                          }),
                        ),
                      ),
                      _localeButton(
                        code: 'de',
                        currentLocale: locale,
                        label: Text(
                          'German'.localize({
                            "en": "German",
                            "fr": "Allemand",
                            "es": "Alemán",
                            "de": "Deutsch",
                            "ar": "الألمانية",
                          }),
                        ),
                      ),
                      _localeButton(
                        code: 'ar',
                        currentLocale: locale,
                        label: Text(
                          'Arabic'.localize({
                            "en": "Arabic",
                            "fr": "Arabe",
                            "es": "Árabe",
                            "de": "Arabisch",
                            "ar": "العربية",
                          }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: _incrementCounter,
            tooltip: "increment".localize(),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
