import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'localization_manager.dart';
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

  /// Optional arguments used to replace placeholders like `{name}` in the
  /// resolved string.
  final Map<String, Object?>? args;

  const LocalizedText(
    this.text, {
    super.key,
    this.translations,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.args,
  });

  @override
  Widget build(BuildContext context) {
    // This call establishes a dependency so the widget rebuilds on locale changes.
    LocalizationProvider.of(context);

    String localizedText;
    if (translations != null) {
      localizedText = text.localizeArgs(
        translations: translations,
        args: args,
      );
    } else {
      localizedText = text.localizeArgs(args: args);
    }

    return Text(
      localizedText,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: LocalizationManager.instance.textDirection,
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

/// Builder that exposes the current locale and text direction to descendants.
///
/// Useful when you need custom widgets that depend on both locale and directionality.
class DirectionalityBuilder extends StatelessWidget {
  /// Called with the current [BuildContext], locale code, and text direction.
  final Widget Function(
      BuildContext context, String locale, TextDirection textDirection) builder;

  const DirectionalityBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final localizationData = LocalizationProvider.of(context);
    final currentLocale = localizationData?.locale ?? 'en';
    final textDirection = LocalizationManager.instance.textDirection;

    return builder(context, currentLocale, textDirection);
  }
}

/// A widget that automatically wraps its child with the correct Directionality
/// based on the current locale.
///
/// This is useful for ensuring that RTL languages like Arabic and Urdu
/// are displayed with the correct text direction.
class AutoDirectionality extends StatelessWidget {
  /// The child widget to wrap with directionality.
  final Widget child;

  const AutoDirectionality({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // This call establishes a dependency so the widget rebuilds on locale changes.
    LocalizationProvider.of(context);

    final textDirection = LocalizationManager.instance.textDirection;

    return Directionality(
      textDirection: textDirection,
      child: child,
    );
  }
}

/// A [Text] widget that renders a localized string with smooth animated transitions
/// when the locale changes.
///
/// This widget uses [AnimatedSwitcher] with rotation transitions to provide
/// a smooth visual effect when switching between different localized texts.
class AnimatedLocalizedText extends StatelessWidget {
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

  /// Optional arguments used to replace placeholders like `{name}` in the
  /// resolved string.
  final Map<String, Object?>? args;

  /// The duration of the transition animation.
  final Duration duration;

  /// The type of transition to use when switching text.
  final AnimatedLocalizedTextTransition transitionType;

  const AnimatedLocalizedText(
    this.text, {
    super.key,
    this.translations,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.args,
    this.duration = const Duration(milliseconds: 300),
    this.transitionType = AnimatedLocalizedTextTransition.rotation,
  });

  @override
  Widget build(BuildContext context) {
    // This call establishes a dependency so the widget rebuilds on locale changes.
    final localizationData = LocalizationProvider.of(context);
    final currentLocale = localizationData?.locale ?? 'en';

    String localizedText;
    if (translations != null) {
      localizedText = text.localizeArgs(
        translations: translations,
        args: args,
      );
    } else {
      localizedText = text.localizeArgs(args: args);
    }

    final textDirection = LocalizationManager.instance.textDirection;

    // Create a unique key that changes whenever locale changes
    // This ensures AnimatedSwitcher always detects a change
    final uniqueKey = ValueKey(
        '${text}_${currentLocale}_${translations.hashCode}_${args.hashCode}');

    return AnimatedSwitcher(
      duration: duration,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return _buildTransition(child, animation);
      },
      child: Text(
        localizedText,
        key: uniqueKey,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        textDirection: textDirection,
      ),
    );
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    switch (transitionType) {
      case AnimatedLocalizedTextTransition.rotation:
        return RotationTransition(
          turns: animation,
          child: child,
        );
      case AnimatedLocalizedTextTransition.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      case AnimatedLocalizedTextTransition.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case AnimatedLocalizedTextTransition.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case AnimatedLocalizedTextTransition.rotationY:
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final isShowingFrontSide = animation.value < 0.5;
            if (isShowingFrontSide) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(animation.value * math.pi),
                child: child,
              );
            } else {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY((1 - animation.value) * math.pi),
                child: child,
              );
            }
          },
          child: child,
        );
    }
  }
}

/// Enum defining the types of transitions available for [AnimatedLocalizedText].
enum AnimatedLocalizedTextTransition {
  /// Rotates the text around its center.
  rotation,

  /// Scales the text in and out.
  scale,

  /// Fades the text in and out.
  fade,

  /// Slides the text horizontally.
  slide,

  /// Rotates the text around the Y-axis (3D flip effect).
  rotationY,
}
