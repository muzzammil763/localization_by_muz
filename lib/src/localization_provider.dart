import 'package:flutter/widgets.dart';

import 'localization_manager.dart';

class LocalizationProvider extends StatefulWidget {
  final Widget child;
  final String defaultLocale;

  const LocalizationProvider({
    super.key,
    required this.child,
    this.defaultLocale = 'en',
  });

  @override
  State<LocalizationProvider> createState() => _LocalizationProviderState();

  static LocalizationInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocalizationInherited>();
  }

  static void setLocale(BuildContext context, String locale) {
    LocalizationManager.instance.setLocale(locale);
  }
}

class _LocalizationProviderState extends State<LocalizationProvider> {
  String _currentLocale = 'en';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
    LocalizationManager.instance.addListener(_onLocaleChanged);
  }

  void _initialize() async {
    await LocalizationManager.instance.initialize(
      defaultLocale: widget.defaultLocale,
    );
    if (mounted) {
      setState(() {
        _currentLocale = LocalizationManager.instance.currentLocale;
        _isInitialized = true;
      });
    }
  }

  void _onLocaleChanged() {
    if (mounted) {
      setState(() {
        _currentLocale = LocalizationManager.instance.currentLocale;
      });
    }
  }

  @override
  void dispose() {
    LocalizationManager.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationInherited(
      locale: _currentLocale,
      isInitialized: _isInitialized,
      child: widget.child,
    );
  }
}

class LocalizationInherited extends InheritedWidget {
  final String locale;
  final bool isInitialized;

  const LocalizationInherited({
    super.key,
    required this.locale,
    required this.isInitialized,
    required super.child,
  });

  @override
  bool updateShouldNotify(LocalizationInherited oldWidget) {
    return locale != oldWidget.locale ||
        isInitialized != oldWidget.isInitialized;
  }
}
