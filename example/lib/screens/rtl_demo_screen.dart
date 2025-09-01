import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class RTLDemoScreen extends StatefulWidget {
  const RTLDemoScreen({super.key});

  @override
  State<RTLDemoScreen> createState() => _RTLDemoScreenState();
}

class _RTLDemoScreenState extends State<RTLDemoScreen> {
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      defaultLocale: _selectedLanguage,
      child: Builder(
        builder: (context) {
          // Get current text direction
          final textDirection = LocalizationProvider.getTextDirection(context);
          final currentLocale = LocalizationProvider.getCurrentLocale(context);
          
          return Scaffold(
            appBar: AppBar(
              title: Text('RTL Demo'.localize()),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Directionality(
              textDirection: textDirection,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language Selection Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'languageSelection'.localize(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              children: [
                                _buildLanguageChip('en', 'English'),
                                _buildLanguageChip('ar', 'العربية'),
                                _buildLanguageChip('ur', 'اردو'),
                                _buildLanguageChip('fr', 'Français'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Current Direction Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Direction Information',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text('Current Locale: $currentLocale'),
                            Text('Text Direction: ${textDirection == TextDirection.rtl ? "RTL" : "LTR"}'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: textDirection == TextDirection.rtl 
                                    ? Colors.orange.shade100 
                                    : Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    textDirection == TextDirection.rtl 
                                        ? Icons.format_textdirection_r_to_l 
                                        : Icons.format_textdirection_l_to_r,
                                    color: textDirection == TextDirection.rtl 
                                        ? Colors.orange.shade700 
                                        : Colors.blue.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    textDirection == TextDirection.rtl 
                                        ? 'Right-to-Left Layout' 
                                        : 'Left-to-Right Layout',
                                    style: TextStyle(
                                      color: textDirection == TextDirection.rtl 
                                          ? Colors.orange.shade700 
                                          : Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Animated Localized Text Examples Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Animated Localized Text Examples',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            
                            // Rotation Animation
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                border: Border.all(color: Colors.blue.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rotation Animation:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedLocalizedText(
                                    'welcome',
                                    style: Theme.of(context).textTheme.titleLarge,
                                    transitionType: AnimatedLocalizedTextTransition.rotation,
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Scale Animation
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border: Border.all(color: Colors.green.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Scale Animation:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedLocalizedText(
                                    'helloWorld',
                                    style: Theme.of(context).textTheme.titleMedium,
                                    transitionType: AnimatedLocalizedTextTransition.scale,
                                    duration: const Duration(milliseconds: 400),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // 3D Flip Animation
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                border: Border.all(color: Colors.purple.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '3D Flip Animation:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedLocalizedText(
                                    'goodbye',
                                    style: Theme.of(context).textTheme.titleMedium,
                                    transitionType: AnimatedLocalizedTextTransition.rotationY,
                                    duration: const Duration(milliseconds: 600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Slide Animation
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                border: Border.all(color: Colors.orange.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Slide Animation:',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedLocalizedText(
                                    'languageSelection',
                                    style: Theme.of(context).textTheme.titleMedium,
                                    transitionType: AnimatedLocalizedTextTransition.slide,
                                    duration: const Duration(milliseconds: 350),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Regular LocalizedText for comparison
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Regular Text (No Animation):',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LocalizedText(
                                    'welcome',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // AutoDirectionality Widget Demo
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AutoDirectionality Widget Demo',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            
                            AutoDirectionality(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  border: Border.all(color: Colors.green.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'This container automatically adapts its directionality!',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text('welcome'.localize()),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text('helloWorld'.localize())),
                                        const Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // DirectionalityBuilder Demo
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DirectionalityBuilder Demo',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            
                            DirectionalityBuilder(
                              builder: (context, locale, textDirection) {
                                return Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.shade50,
                                    border: Border.all(color: Colors.purple.shade200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Builder provides: locale="$locale", direction="${textDirection == TextDirection.rtl ? "RTL" : "LTR"}"',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'goodbye'.localize(),
                                        textDirection: textDirection,
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildLanguageChip(String locale, String label) {
    final isSelected = _selectedLanguage == locale;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedLanguage = locale;
          });
          LocalizationManager.instance.setLocale(locale);
        }
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.primary,
    );
  }
}