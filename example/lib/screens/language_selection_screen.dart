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
          {'code': 'ur', 'name': 'Urdu', 'nativeName': 'اردو', 'flag': '🇵🇰'},
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
                          AnimatedLocalizedText(
                            "currentLanguage".localize(),
                            style: Theme.of(context).textTheme.titleMedium,
                            transitionType:
                                AnimatedLocalizedTextTransition.scale,
                          ),
                          const SizedBox(height: 8),
                          AnimatedLocalizedText(
                            transitionType:
                                AnimatedLocalizedTextTransition.scale,
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
                                  "languageChangedTo".localizeArgs(
                                    args: {'language': language['nativeName']!},
                                  ),
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
