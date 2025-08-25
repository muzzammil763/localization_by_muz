import 'localization_manager.dart';

extension LocalizationExtension on String {
  String localize([Map<String, String>? translations]) {
    if (translations != null) {
      final currentLocale = LocalizationManager.instance.currentLocale;
      return translations[currentLocale] ?? this;
    }

    return LocalizationManager.instance.translate(this);
  }
}
