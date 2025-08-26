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
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Asset Loading Examples',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            
            // Per-locale file example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Per-Locale Files',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('customGreeting'.localize()),
                    Text('customFarewell'.localize()),
                    Text('customMessage'.localize()),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Parameter interpolation example
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Parameter Interpolation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
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
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Information card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Asset Loading Strategy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This demo uses PerLocaleAssetLoader to load translations from separate files:',
                    ),
                    const SizedBox(height: 4),
                    const Text('• assets/i18n/en.json'),
                    const Text('• assets/i18n/fr.json'),
                    const Text('• assets/i18n/es.json'),
                    const SizedBox(height: 8),
                    const Text(
                      'Each file contains locale-specific translations that are automatically merged by the asset loader.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}