import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

/// Demonstrates custom asset loading strategies.
class CustomAssetDemoScreen extends StatelessWidget {
  const CustomAssetDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Asset Loading Demo'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Custom Asset Loading Examples',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Demonstrating per-locale file loading and parameter interpolation',
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
              'Examples:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Card.outlined(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.language,
                        color: Colors.blue,
                        size: 32,
                      ),
                      title: Text(
                        'Per-Locale Files',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('customGreeting'.localize()),
                          Text('customFarewell'.localize()),
                          Text('customMessage'.localize()),
                        ],
                      ),
                      trailing: Icon(Icons.folder_open),
                    ),
                  ),
                  Card.outlined(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.code,
                        color: Colors.green,
                        size: 32,
                      ),
                      title: Text(
                        'Parameter Interpolation',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'parameterExample'.localizeArgs(
                              args: {
                                'name': 'Developer',
                                'app': 'Custom Asset Demo',
                              },
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.dynamic_form),
                    ),
                  ),
                  Card.outlined(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 32,
                      ),
                      title: Text(
                        'Asset Loading Strategy',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          const Text('PerLocaleAssetLoader loads from:'),
                          const Text('• assets/i18n/en.json'),
                          const Text('• assets/i18n/fr.json'),
                          const Text('• assets/i18n/es.json'),
                        ],
                      ),
                      trailing: Icon(Icons.settings),
                    ),
                  ),
                  Card.outlined(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.merge_type,
                        color: Colors.purple,
                        size: 32,
                      ),
                      title: Text(
                        'Composite Loading',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          const Text(
                            'Combines DefaultAssetLoader and PerLocaleAssetLoader for maximum flexibility',
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.layers),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}