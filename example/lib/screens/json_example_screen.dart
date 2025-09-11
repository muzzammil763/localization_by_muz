import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class JsonExampleScreen extends StatefulWidget {
  const JsonExampleScreen({super.key});

  @override
  State<JsonExampleScreen> createState() => _JsonExampleScreenState();
}

class _JsonExampleScreenState extends State<JsonExampleScreen> {
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
    final locale = LocalizationManager.instance.currentLocale;
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
                        "whatIsJsonLocalization".localize(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "jsonLocalizationDescription".localize(),
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
                        "basicJsonExamples".localize(),
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
                        '123',
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
                        "codeExample".localize(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Text("helloWorld".localize())',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontFamily: 'monospace',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  _localeButton(
                    code: 'en',
                    currentLocale: locale,
                    label: Text("english".localize()),
                  ),
                  _localeButton(
                    code: 'fr',
                    currentLocale: locale,
                    label: Text("french".localize()),
                  ),
                  _localeButton(
                    code: 'de',
                    currentLocale: locale,
                    label: Text("german".localize()),
                  ),
                  _localeButton(
                    code: 'ar',
                    currentLocale: locale,
                    label: Text("arabic".localize()),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
