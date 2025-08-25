import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

import 'about_screen.dart';
import 'inline_example_screen.dart';
import 'json_example_screen.dart';
import 'language_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizedBuilder(
      builder: (context, locale) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text("appTitle".localize()),
            actions: [
              IconButton(
                icon: Icon(CupertinoIcons.globe),
                tooltip: "languageSelection".localize(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguageSelectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "welcome".localize(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "homeScreenDescription".localize({
                            "en":
                                "This is the home screen showcasing localization features",
                            "fr":
                                "Ceci est l'écran d'accueil présentant les fonctionnalités de localisation",
                            "es":
                                "Esta es la pantalla de inicio que muestra las funciones de localización",
                            "de":
                                "Dies ist der Startbildschirm, der Lokalisierungsfunktionen zeigt",
                            "ar":
                                "هذه هي الشاشة الرئيسية التي تعرض ميزات التوطين",
                          }),
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Examples:".localize({
                    "en": "Examples",
                    "fr": "Exemples",
                    "es": "Ejemplos",
                    "de": "Beispiele",
                    "ar": "أمثلة",
                  }),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: [
                      _buildNavigationCard(
                        context,
                        title: "inlineExample".localize(),
                        subtitle: "inlineExampleDesc".localize({
                          "en": "Using inline translations",
                          "fr": "Utilisation de traductions en ligne",
                          "es": "Usando traducciones en línea",
                          "de": "Verwendung von Inline-Übersetzungen",
                          "ar": "استخدام الترجمات المباشرة",
                        }),
                        icon: Icons.code,
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InlineExampleScreen(),
                          ),
                        ),
                      ),
                      _buildNavigationCard(
                        context,
                        title: "jsonExample".localize(),
                        subtitle: "jsonExampleDesc".localize({
                          "en": "Using JSON file translations",
                          "fr": "Utilisation de traductions de fichier JSON",
                          "es": "Usando traducciones de archivo JSON",
                          "de": "Verwendung von JSON-Datei-Übersetzungen",
                          "ar": "استخدام ترجمات ملف JSON",
                        }),
                        icon: Icons.description_outlined,
                        color: Colors.green,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JsonExampleScreen(),
                          ),
                        ),
                      ),
                      _buildNavigationCard(
                        context,
                        title: "languageSelection".localize(),
                        subtitle: "languageSelectionDesc".localize({
                          "en": "Change app language",
                          "fr": "Changer la langue de l'application",
                          "es": "Cambiar idioma de la aplicación",
                          "de": "App-Sprache ändern",
                          "ar": "تغيير لغة التطبيق",
                        }),
                        icon: CupertinoIcons.globe,
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LanguageSelectionScreen(),
                          ),
                        ),
                      ),
                      _buildNavigationCard(
                        context,
                        title: "aboutApp".localize(),
                        subtitle: "aboutAppDesc".localize({
                          "en": "Learn about this package",
                          "fr": "En savoir plus sur ce package",
                          "es": "Aprende sobre este paquete",
                          "de": "Erfahren Sie mehr über dieses Paket",
                          "ar": "تعرف على هذه الحزمة",
                        }),
                        icon: Icons.info_outline,
                        color: Colors.purple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card.outlined(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
