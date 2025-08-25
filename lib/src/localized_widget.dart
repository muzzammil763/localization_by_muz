import 'package:flutter/widgets.dart';

import 'localization_provider.dart';
import 'string_extension.dart';

class LocalizedText extends StatelessWidget {
  final String text;
  final Map<String, String>? translations;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const LocalizedText(
    this.text, {
    super.key,
    this.translations,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    // This will make the widget rebuild when locale changes
    final localizationData = LocalizationProvider.of(context);

    String localizedText;
    if (translations != null) {
      final currentLocale = localizationData?.locale ?? 'en';
      localizedText = translations![currentLocale] ?? text;
    } else {
      localizedText = text.localize();
    }

    return Text(
      localizedText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class LocalizedBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, String locale) builder;

  const LocalizedBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final localizationData = LocalizationProvider.of(context);
    final currentLocale = localizationData?.locale ?? 'en';

    return builder(context, currentLocale);
  }
}
