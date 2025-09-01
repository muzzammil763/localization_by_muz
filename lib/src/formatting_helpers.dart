import 'package:flutter/foundation.dart';

/// Feature flag to enable intl-based formatting.
/// Set this to true to use intl package for number and date formatting.
/// When false, uses basic Dart formatting.
const bool kUseIntlFormatting = false;

/// A utility class that provides number and date formatting helpers
/// with optional intl integration behind a feature flag.
///
/// When [kUseIntlFormatting] is true, it uses the intl package for
/// advanced formatting. When false, it uses basic Dart formatting.
class FormattingHelpers {
  FormattingHelpers._();

  /// Formats a number according to the current locale.
  ///
  /// [number] - The number to format
  /// [locale] - The locale code (e.g., 'en', 'fr', 'de')
  /// [decimalPlaces] - Number of decimal places (optional)
  /// [useGrouping] - Whether to use thousands separators (default: true)
  ///
  /// Examples:
  /// ```dart
  /// FormattingHelpers.formatNumber(1234.56, 'en'); // "1,234.56"
  /// FormattingHelpers.formatNumber(1234.56, 'de'); // "1.234,56"
  /// FormattingHelpers.formatNumber(1234.56, 'fr'); // "1 234,56"
  /// ```
  static String formatNumber(
    num number,
    String locale, {
    int? decimalPlaces,
    bool useGrouping = true,
  }) {
    if (kUseIntlFormatting) {
      return _formatNumberWithIntl(number, locale,
          decimalPlaces: decimalPlaces, useGrouping: useGrouping);
    } else {
      return _formatNumberBasic(number, locale,
          decimalPlaces: decimalPlaces, useGrouping: useGrouping);
    }
  }

  /// Formats a currency value according to the current locale.
  ///
  /// [amount] - The amount to format
  /// [locale] - The locale code (e.g., 'en', 'fr', 'de')
  /// [currencyCode] - The currency code (e.g., 'USD', 'EUR', 'GBP')
  /// [currencySymbol] - Custom currency symbol (optional)
  ///
  /// Examples:
  /// ```dart
  /// FormattingHelpers.formatCurrency(1234.56, 'en', 'USD'); // "$1,234.56"
  /// FormattingHelpers.formatCurrency(1234.56, 'de', 'EUR'); // "1.234,56 €"
  /// ```
  static String formatCurrency(
    num amount,
    String locale,
    String currencyCode, {
    String? currencySymbol,
  }) {
    if (kUseIntlFormatting) {
      return _formatCurrencyWithIntl(amount, locale, currencyCode,
          currencySymbol: currencySymbol);
    } else {
      return _formatCurrencyBasic(amount, locale, currencyCode,
          currencySymbol: currencySymbol);
    }
  }

  /// Formats a percentage value according to the current locale.
  ///
  /// [value] - The value to format (0.1 = 10%)
  /// [locale] - The locale code (e.g., 'en', 'fr', 'de')
  /// [decimalPlaces] - Number of decimal places (default: 1)
  ///
  /// Examples:
  /// ```dart
  /// FormattingHelpers.formatPercentage(0.1234, 'en'); // "12.3%"
  /// FormattingHelpers.formatPercentage(0.1234, 'de'); // "12,3 %"
  /// ```
  static String formatPercentage(
    num value,
    String locale, {
    int decimalPlaces = 1,
  }) {
    if (kUseIntlFormatting) {
      return _formatPercentageWithIntl(value, locale,
          decimalPlaces: decimalPlaces);
    } else {
      return _formatPercentageBasic(value, locale,
          decimalPlaces: decimalPlaces);
    }
  }

  /// Formats a date according to the current locale.
  ///
  /// [date] - The date to format
  /// [locale] - The locale code (e.g., 'en', 'fr', 'de')
  /// [pattern] - The date pattern (optional, uses locale default if not provided)
  ///
  /// Examples:
  /// ```dart
  /// FormattingHelpers.formatDate(DateTime.now(), 'en'); // "12/25/2023"
  /// FormattingHelpers.formatDate(DateTime.now(), 'de'); // "25.12.2023"
  /// FormattingHelpers.formatDate(DateTime.now(), 'en', 'yyyy-MM-dd'); // "2023-12-25"
  /// ```
  static String formatDate(
    DateTime date,
    String locale, {
    String? pattern,
  }) {
    if (kUseIntlFormatting) {
      return _formatDateWithIntl(date, locale, pattern: pattern);
    } else {
      return _formatDateBasic(date, locale, pattern: pattern);
    }
  }

  /// Formats a time according to the current locale.
  ///
  /// [time] - The time to format
  /// [locale] - The locale code (e.g., 'en', 'fr', 'de')
  /// [use24Hour] - Whether to use 24-hour format (default: depends on locale)
  ///
  /// Examples:
  /// ```dart
  /// FormattingHelpers.formatTime(DateTime.now(), 'en'); // "3:30 PM"
  /// FormattingHelpers.formatTime(DateTime.now(), 'de'); // "15:30"
  /// ```
  static String formatTime(
    DateTime time,
    String locale, {
    bool? use24Hour,
  }) {
    if (kUseIntlFormatting) {
      return _formatTimeWithIntl(time, locale, use24Hour: use24Hour);
    } else {
      return _formatTimeBasic(time, locale, use24Hour: use24Hour);
    }
  }

  // Basic formatting implementations (without intl)
  static String _formatNumberBasic(
    num number,
    String locale, {
    int? decimalPlaces,
    bool useGrouping = true,
  }) {
    String result = decimalPlaces != null
        ? number.toStringAsFixed(decimalPlaces)
        : number.toString();

    if (!useGrouping) return result;

    // Basic grouping for common locales
    final parts = result.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    String groupedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        groupedInteger += _getThousandsSeparator(locale);
      }
      groupedInteger += integerPart[i];
    }

    if (decimalPart.isNotEmpty) {
      return '$groupedInteger${_getDecimalSeparator(locale)}$decimalPart';
    }
    return groupedInteger;
  }

  static String _formatCurrencyBasic(
    num amount,
    String locale,
    String currencyCode, {
    String? currencySymbol,
  }) {
    final symbol = currencySymbol ?? _getCurrencySymbol(currencyCode);
    final formattedAmount =
        _formatNumberBasic(amount, locale, decimalPlaces: 2);

    // Basic currency formatting based on locale
    switch (locale) {
      case 'de':
      case 'fr':
        return '$formattedAmount $symbol';
      default:
        return '$symbol$formattedAmount';
    }
  }

  static String _formatPercentageBasic(
    num value,
    String locale, {
    int decimalPlaces = 1,
  }) {
    final percentage = value * 100;
    final formatted = _formatNumberBasic(percentage, locale,
        decimalPlaces: decimalPlaces, useGrouping: false);

    switch (locale) {
      case 'de':
      case 'fr':
        return '$formatted %';
      default:
        return '$formatted%';
    }
  }

  static String _formatDateBasic(
    DateTime date,
    String locale, {
    String? pattern,
  }) {
    if (pattern != null) {
      return _applyDatePattern(date, pattern);
    }

    // Basic date formatting based on locale
    switch (locale) {
      case 'de':
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
      case 'fr':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      default:
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  static String _formatTimeBasic(
    DateTime time,
    String locale, {
    bool? use24Hour,
  }) {
    final use24 = use24Hour ?? _shouldUse24Hour(locale);

    if (use24) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      final hour = time.hour == 0
          ? 12
          : time.hour > 12
              ? time.hour - 12
              : time.hour;
      final period = time.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  // Intl-based formatting implementations (when feature flag is enabled)
  static String _formatNumberWithIntl(
    num number,
    String locale, {
    int? decimalPlaces,
    bool useGrouping = true,
  }) {
    // This would use intl package when available
    // For now, fallback to basic implementation
    if (kDebugMode) {
      debugPrint('Intl formatting not available, using basic formatting');
    }
    return _formatNumberBasic(number, locale,
        decimalPlaces: decimalPlaces, useGrouping: useGrouping);
  }

  static String _formatCurrencyWithIntl(
    num amount,
    String locale,
    String currencyCode, {
    String? currencySymbol,
  }) {
    // This would use intl package when available
    // For now, fallback to basic implementation
    if (kDebugMode) {
      debugPrint('Intl formatting not available, using basic formatting');
    }
    return _formatCurrencyBasic(amount, locale, currencyCode,
        currencySymbol: currencySymbol);
  }

  static String _formatPercentageWithIntl(
    num value,
    String locale, {
    int decimalPlaces = 1,
  }) {
    // This would use intl package when available
    // For now, fallback to basic implementation
    if (kDebugMode) {
      debugPrint('Intl formatting not available, using basic formatting');
    }
    return _formatPercentageBasic(value, locale, decimalPlaces: decimalPlaces);
  }

  static String _formatDateWithIntl(
    DateTime date,
    String locale, {
    String? pattern,
  }) {
    // This would use intl package when available
    // For now, fallback to basic implementation
    if (kDebugMode) {
      debugPrint('Intl formatting not available, using basic formatting');
    }
    return _formatDateBasic(date, locale, pattern: pattern);
  }

  static String _formatTimeWithIntl(
    DateTime time,
    String locale, {
    bool? use24Hour,
  }) {
    // This would use intl package when available
    // For now, fallback to basic implementation
    if (kDebugMode) {
      debugPrint('Intl formatting not available, using basic formatting');
    }
    return _formatTimeBasic(time, locale, use24Hour: use24Hour);
  }

  // Helper methods
  static String _getThousandsSeparator(String locale) {
    switch (locale) {
      case 'de':
        return '.';
      case 'fr':
        return ' ';
      default:
        return ',';
    }
  }

  static String _getDecimalSeparator(String locale) {
    switch (locale) {
      case 'de':
      case 'fr':
        return ',';
      default:
        return '.';
    }
  }

  static String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return r'$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return currencyCode;
    }
  }

  static bool _shouldUse24Hour(String locale) {
    switch (locale) {
      case 'de':
      case 'fr':
        return true;
      default:
        return false;
    }
  }

  static String _applyDatePattern(DateTime date, String pattern) {
    return pattern
        .replaceAll('yyyy', date.year.toString())
        .replaceAll('MM', date.month.toString().padLeft(2, '0'))
        .replaceAll('dd', date.day.toString().padLeft(2, '0'))
        .replaceAll('HH', date.hour.toString().padLeft(2, '0'))
        .replaceAll('mm', date.minute.toString().padLeft(2, '0'))
        .replaceAll('ss', date.second.toString().padLeft(2, '0'));
  }
}
