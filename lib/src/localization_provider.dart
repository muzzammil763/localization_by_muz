import 'package:flutter/widgets.dart';

import 'localization_manager.dart';

/// Provides localization state to the widget tree and initializes
/// [LocalizationManager].
///
/// Wrap your app with [LocalizationProvider] to enable string localization and
/// instant runtime language switching via [setLocale].
class LocalizationProvider extends StatefulWidget {
  /// The subtree that will have access to localization state.
  final Widget child;

  /// The initial locale code to use (e.g. `en`, `fr`).
  final String defaultLocale;

  const LocalizationProvider({
    super.key,
    required this.child,
    this.defaultLocale = 'en',
  });

  @override
  State<LocalizationProvider> createState() => _LocalizationProviderState();

  /// Returns the nearest [LocalizationInherited] above in the tree, or `null`
  /// if none is found.
  static LocalizationInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocalizationInherited>();
  }

  /// Changes the current locale for the entire app at runtime.
  ///
  /// Widgets that depend on localization will rebuild automatically.
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
    // Ensure the inherited widget exposes the requested default locale
    // immediately, even before async initialization completes.
    _currentLocale = widget.defaultLocale;
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
      child: KeyedSubtree(
        key: ValueKey<String>(_currentLocale),
        child: widget.child,
      ),
    );
  }
}

/// Inherited widget that exposes the current locale and initialization state to
/// descendants.
class LocalizationInherited extends InheritedWidget {
  /// The active locale code for the app.
  final String locale;

  /// Whether the localization manager has finished initialization.
  final bool isInitialized;

  const LocalizationInherited({
    super.key,
    required this.locale,
    required this.isInitialized,
    required super.child,
  });

  /// Notifies dependents when either the locale or initialization state changes.
  @override
  bool updateShouldNotify(LocalizationInherited oldWidget) {
    return locale != oldWidget.locale ||
        isInitialized != oldWidget.isInitialized;
  }
}
