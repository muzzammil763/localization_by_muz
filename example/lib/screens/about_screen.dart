import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizedBuilder(
      builder: (context, locale) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text("aboutApp".localize()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.globe,
                            size: 64,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "localization_by_muz",
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "v1.0.4",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "description".localize(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.justify,
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
                            "features".localize(),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "feature1".localize(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "feature2".localize(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "feature3".localize(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Usage Examples:".localize({
                              "en": "Usage Examples:",
                              "fr": "Exemples d'utilisation:",
                              "es": "Ejemplos de uso:",
                              "de": "Verwendungsbeispiele:",
                              "ar": "أمثلة الاستخدام:",
                            }),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Inline method:".localize({
                                    "en": "Inline method:",
                                    "fr": "Méthode en ligne:",
                                    "es": "Método en línea:",
                                    "de": "Inline-Methode:",
                                    "ar": "الطريقة المباشرة:",
                                  }),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '"Hello".localize({\n  "en": "Hello",\n  "fr": "Bonjour"\n})',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily: 'monospace',
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "JSON method:".localize({
                                    "en": "JSON method:",
                                    "fr": "Méthode JSON:",
                                    "es": "Método JSON:",
                                    "de": "JSON-Methode:",
                                    "ar": "طريقة JSON:",
                                  }),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '"helloWorld".localize()',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontFamily: 'monospace',
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SizedBox(
            width: 200,
            child: FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(
                "Back to Home".localize({
                  "en": "Back to Home",
                  "fr": "Retour à l'accueil",
                  "es": "Volver al inicio",
                  "de": "Zurück zur Startseite",
                  "ar": "العودة للرئيسية",
                }),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
