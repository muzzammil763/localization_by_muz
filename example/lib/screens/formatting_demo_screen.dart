import 'package:flutter/material.dart';
import 'package:localization_by_muz/localization_by_muz.dart';

class FormattingDemoScreen extends StatefulWidget {
  const FormattingDemoScreen({super.key});

  @override
  State<FormattingDemoScreen> createState() => _FormattingDemoScreenState();
}

class _FormattingDemoScreenState extends State<FormattingDemoScreen> {
  double numberValue = 1234567.89;
  double currencyValue = 99.99;
  double percentageValue = 0.75;
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return LocalizedBuilder(
      builder: (context, locale) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text("formatting.title".localize()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nested Keys Demo Section
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "nested.title".localize(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "nested.description".localize(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          _buildNestedKeyExample("user.profile.name"),
                          _buildNestedKeyExample("user.profile.email"),
                          _buildNestedKeyExample("user.settings.theme"),
                          _buildNestedKeyExample("user.settings.language"),
                          const SizedBox(height: 8),
                          Text(
                            "user.profile.welcome".localize({
                              "username": "John Doe",
                            }),
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Formatting Helpers Demo Section
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "formatting.title".localize(),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),

                          // Number Formatting
                          _buildFormattingExample(
                            "formatting.numbers".localize(),
                            FormattingHelpers.formatNumber(numberValue, locale),
                            Icons.numbers,
                          ),

                          // Currency Formatting
                          _buildFormattingExample(
                            "formatting.currency".localize(),
                            FormattingHelpers.formatCurrency(
                              currencyValue,
                              locale,
                              'USD',
                            ),
                            Icons.attach_money,
                          ),

                          // Percentage Formatting
                          _buildFormattingExample(
                            "formatting.percentage".localize(),
                            FormattingHelpers.formatPercentage(
                              percentageValue,
                              locale,
                            ),
                            Icons.percent,
                          ),

                          // Date Formatting
                          _buildFormattingExample(
                            "formatting.date".localize(),
                            FormattingHelpers.formatDate(currentDate, locale),
                            Icons.calendar_today,
                          ),

                          // Time Formatting
                          _buildFormattingExample(
                            "formatting.time".localize(),
                            FormattingHelpers.formatTime(currentDate, locale),
                            Icons.access_time,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Interactive Controls
                  Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Interactive Demo".localize({
                              "en": "Interactive Demo",
                              "fr": "Démo interactive",
                              "es": "Demo interactivo",
                              "de": "Interaktive Demo",
                              "ar": "عرض تفاعلي",
                            }),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 16),

                          // Number Slider
                          Text(
                            "Number Value: ${FormattingHelpers.formatNumber(numberValue, locale)}",
                          ),
                          Slider(
                            activeColor: Colors.black,
                            value: numberValue,
                            min: 0,
                            max: 10000000,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                numberValue = value;
                              });
                            },
                          ),

                          // Currency Slider
                          Text(
                            "Currency Value: ${FormattingHelpers.formatCurrency(currencyValue, locale, 'USD')}",
                          ),
                          Slider(
                            activeColor: Colors.black,
                            value: currencyValue,
                            min: 0,
                            max: 1000,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                currencyValue = value;
                              });
                            },
                          ),

                          // Percentage Slider
                          Text(
                            "Percentage Value: ${FormattingHelpers.formatPercentage(percentageValue, locale)}",
                          ),
                          Slider(
                            activeColor: Colors.black,
                            value: percentageValue,
                            min: 0,
                            max: 1,
                            divisions: 100,
                            onChanged: (value) {
                              setState(() {
                                percentageValue = value;
                              });
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
    );
  }

  Widget _buildNestedKeyExample(String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          const Text(" → "),
          Expanded(
            flex: 3,
            child: Text(
              key.localize(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattingExample(
    String label,
    String formattedValue,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  formattedValue,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
