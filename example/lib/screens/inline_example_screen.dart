import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class InlineExampleScreen extends StatefulWidget {
  const InlineExampleScreen({super.key});

  @override
  State<InlineExampleScreen> createState() => _InlineExampleScreenState();
}

class _InlineExampleScreenState extends State<InlineExampleScreen> {
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
            title: Text(
              "Inline Localization Example".localize({
                "en": "Inline Localization Example",
                "fr": "Exemple de localisation en ligne",
                "es": "Ejemplo de localización en línea",
                "de": "Beispiel für Inline-Lokalisierung",
                "ar": "مثال على الترجمة المباشرة",
              }),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
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
                          "What is Inline Localization?".localize({
                            "en": "What is Inline Localization?",
                            "fr": "Qu'est-ce que la localisation en ligne?",
                            "es": "¿Qué es la localización en línea?",
                            "de": "Was ist Inline-Lokalisierung?",
                            "ar": "ما هي الترجمة المباشرة؟",
                          }),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Inline localization allows you to define translations directly in your code using the .localize() method with a map of language codes and translations.".localize({
                            "en":
                                "Inline localization allows you to define translations directly in your code using the .localize() method with a map of language codes and translations.",
                            "fr":
                                "La localisation en ligne vous permet de définir des traductions directement dans votre code en utilisant la méthode .localize() avec une carte de codes de langue et de traductions.",
                            "es":
                                "La localización en línea te permite definir traducciones directamente en tu código usando el método .localize() con un mapa de códigos de idioma y traducciones.",
                            "de":
                                "Inline-Lokalisierung ermöglicht es Ihnen, Übersetzungen direkt in Ihrem Code mit der .localize()-Methode und einer Karte von Sprachcodes und Übersetzungen zu definieren.",
                            "ar":
                                "تتيح لك الترجمة المباشرة تعريف الترجمات مباشرة في الكود باستخدام طريقة .localize() مع خريطة من رموز اللغات والترجمات.",
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
                          "Simple Greetings".localize({
                            "en": "Simple Greetings",
                            "fr": "Salutations simples",
                            "es": "Saludos simples",
                            "de": "Einfache Grüße",
                            "ar": "تحيات بسيطة",
                          }),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Good Morning!".localize({
                            "en": "Good Morning!",
                            "fr": "Bonjour!",
                            "es": "¡Buenos días!",
                            "de": "Guten Morgen!",
                            "ar": "صباح الخير!",
                          }),
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "How are you today?".localize({
                            "en": "How are you today?",
                            "fr": "Comment allez-vous aujourd'hui?",
                            "es": "¿Cómo estás hoy?",
                            "de": "Wie geht es dir heute?",
                            "ar": "كيف حالك اليوم؟",
                          }),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Have a wonderful day!".localize({
                            "en": "Have a wonderful day!",
                            "fr": "Passez une merveilleuse journée!",
                            "es": "¡Que tengas un día maravilloso!",
                            "de": "Haben Sie einen wunderbaren Tag!",
                            "ar": "أتمنى لك يوماً رائعاً!",
                          }),
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
                          "Interactive Counter".localize({
                            "en": "Interactive Counter",
                            "fr": "Compteur interactif",
                            "es": "Contador interactivo",
                            "de": "Interaktiver Zähler",
                            "ar": "عداد تفاعلي",
                          }),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Button pressed".localize({
                            "en": "Button pressed",
                            "fr": "Bouton appuyé",
                            "es": "Botón presionado",
                            "de": "Taste gedrückt",
                            "ar": "تم الضغط على الزر",
                          }),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
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
                        Text(
                          _counter == 1
                              ? "time".localize({
                                  "en": "time",
                                  "fr": "fois",
                                  "es": "vez",
                                  "de": "mal",
                                  "ar": "مرة",
                                })
                              : "times".localize({
                                  "en": "times",
                                  "fr": "fois",
                                  "es": "veces",
                                  "de": "mal",
                                  "ar": "مرات",
                                }),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      code: 'es',
                      currentLocale: locale,
                      label: Text(
                        'Spanish'.localize({
                          "en": "Spanish",
                          "fr": "Espagnol",
                          "es": "Español",
                          "de": "Spanisch",
                          "ar": "الإسبانية",
                        }),
                      ),
                    ),
                  ],
                ),
              ],
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
            tooltip: "Increment".localize({
              "en": "Increment",
              "fr": "Incrémenter",
              "es": "Incrementar",
              "de": "Erhöhen",
              "ar": "زيادة",
            }),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
