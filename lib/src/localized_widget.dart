import 'package:flutter/widgets.dart';

import 'localization_provider.dart';
import 'string_extension.dart';

/// A [Text] widget that renders a localized string.
///
/// You can provide inline [translations], or omit it to treat [text] as a
/// translation key resolved via `lib/localization.json`.
class LocalizedText extends StatelessWidget {
  /// The raw text (default) or the translation key when [translations] is
  /// omitted.
  final String text;
  /// Optional per-locale overrides (e.g. `{ 'en': 'Hello', 'fr': 'Bonjour' }`).
  final Map<String, String>? translations;
  /// The style to use for the text.
  final TextStyle? style;
  /// The alignment of the text.
  final TextAlign? textAlign;
  /// The maximum number of lines to display.
  final int? maxLines;
  /// How to handle text that overflows the available space.
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

/// Builder that exposes the current locale to descendants.
///
/// Useful when you need custom widgets that depend on the active locale.
class LocalizedBuilder extends StatelessWidget {
  /// Called with the current [BuildContext] and the active locale code.
  final Widget Function(BuildContext context, String locale) builder;

  const LocalizedBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final localizationData = LocalizationProvider.of(context);
    final currentLocale = localizationData?.locale ?? 'en';

    return builder(context, currentLocale);
  }
}
