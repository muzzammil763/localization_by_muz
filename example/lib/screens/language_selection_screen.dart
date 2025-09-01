import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizedBuilder(
      builder: (context, locale) {
        final currentLocale = LocalizationManager.instance.currentLocale;

        final languages = [
          {
            'code': 'en',
            'name': 'English',
            'nativeName': 'English',
            'flag': '🇺🇸',
          },
          {
            'code': 'fr',
            'name': 'French',
            'nativeName': 'Français',
            'flag': '🇫🇷',
          },
          {
            'code': 'es',
            'name': 'Spanish',
            'nativeName': 'Español',
            'flag': '🇪🇸',
          },
          {
            'code': 'de',
            'name': 'German',
            'nativeName': 'Deutsch',
            'flag': '🇩🇪',
          },
          {
            'code': 'ar',
            'name': 'Arabic',
            'nativeName': 'العربية',
            'flag': '🇸🇦',
          },
          {
            'code': 'ur',
            'name': 'Urdu',
            'nativeName': 'اردو',
            'flag': '🇵🇰',
          },
        ];

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text("languageSelection".localize()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "currentLanguage".localize(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            languages.firstWhere(
                              (lang) => lang['code'] == currentLocale,
                            )['nativeName']!,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  "selectLanguage".localize(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            CupertinoIcons.info,
                            color: Colors.black,
                            size: 45,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "instantLanguageChange".localize({
                              "en": "Language changes take effect immediately",
                              "fr":
                                  "Les changements de langue prennent effet immédiatement",
                              "es":
                                  "Los cambios de idioma surten efecto inmediatamente",
                              "de": "Sprachänderungen werden sofort wirksam",
                              "ar": "تغييرات اللغة تدخل حيز التنفيذ فوراً",
                              "ur": "زبان کی تبدیلیاں فوری طور پر مؤثر ہوتی ہیں",
                            }),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "noRestartRequired".localize({
                              "en": "No app restart required!",
                              "fr": "Aucun redémarrage d'application requis!",
                              "es":
                                  "¡No se requiere reinicio de la aplicación!",
                              "de": "Kein App-Neustart erforderlich!",
                              "ar": "لا حاجة لإعادة تشغيل التطبيق!",
                              "ur": "ایپ کو دوبارہ شروع کرنے کی ضرورت نہیں!",
                            }),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      final isSelected = language['code'] == currentLocale;

                      return Card.outlined(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isSelected ? Colors.black : null,
                        child: ListTile(
                          leading: Text(
                            language['flag']!,
                            style: const TextStyle(fontSize: 32),
                          ),
                          title: Text(
                            language['nativeName']!,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                          ),
                          subtitle: Text(
                            language['name']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                )
                              : const Icon(Icons.radio_button_unchecked),
                          onTap: () {
                            LocalizationProvider.setLocale(
                              context,
                              language['code']!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "languageChangedTo".localize({
                                    "en":
                                        "Language changed to ${language['nativeName']}",
                                    "fr":
                                        "Langue changée en ${language['nativeName']}",
                                    "es":
                                        "Idioma cambiado a ${language['nativeName']}",
                                    "de":
                                        "Sprache geändert zu ${language['nativeName']}",
                                    "ar":
                                        "تم تغيير اللغة إلى ${language['nativeName']}",
                                    "ur":
                                        "زبان ${language['nativeName']} میں تبدیل کر دی گئی",
                                  }),
                                ),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
