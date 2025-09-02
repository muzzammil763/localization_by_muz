## 1.0.6

- Fix navigation stack reset issue when changing locale by removing KeyedSubtree from LocalizationProvider
- Improve AnimatedLocalizedText property naming for better consistency
- Enhance navigation preservation during locale changes for better user experience
- Update test coverage for navigation preservation scenarios
- Maintain backward compatibility with existing localization functionality

## 1.0.5

- Add `AnimatedLocalizedText` widget with smooth transition animations for locale changes
- Add `AnimatedLocalizedTextTransition` enum with 5 animation types: rotation, scale, fade, slide, and 3D Y-axis rotation
- Add locale persistence using `SharedPreferences` to maintain selected locale across app restarts
- Add comprehensive test coverage for animated widgets and locale persistence
- Update RTL demo screen to showcase animated locale switching functionality
- Maintain backward compatibility with existing `LocalizedText` widget
- Enhanced user experience with instant animated feedback on locale changes

## 1.0.4

- Add number and date formatting helpers with optional `intl` integration
- Add namespaces and dotted keys support for nested JSON structures
- Add new `FormattingHelpers` class with methods for numbers, currency, percentages, dates, and times
- Add support for accessing nested keys using dot notation (e.g., `user.profile.name`)
- Add enhanced example app with formatting demo screen
- Fix `MissingKeyDebugOverlay` Directionality widget error
- Update documentation with comprehensive examples for new features
- Maintain backward compatibility with existing flat key structures

## 1.0.3

- Add missing key diagnostics with configurable logging and debug overlay
- Implement hot-reload translations in debug mode for faster development
- Add `enableMissingKeyLogging` and `onMissingKey` callback to LocalizationProvider
- Add `showDebugOverlay` option to display missing keys visually
- Add `enableHotReload` option for automatic translation reloading in debug mode
- Comprehensive test coverage for new diagnostic and hot-reload features
- Update documentation and example app to demonstrate new features

## 1.0.2

- Bump package version to 1.0.2
- README: update dependency example to ^1.0.2
- Example: update About screen version text to v1.0.2

## 1.0.1

- Bump package version to 1.0.1
- README: add SVG banner, author section (GitHub: @muzzammil763), and closing tagline
- Docs: clarify JSON asset path and setup for `lib/localization.json`
- Example: update About screen version text to `v1.0.1`

## 1.0.0

- Initial stable release
- Inline localization via `String.localize([Map<String, String>? translations])`
- JSON-based localization read from `lib/localization.json`
- Widgets: `LocalizationProvider`, `LocalizedText`, `LocalizedBuilder`
- Instant language switching with `LocalizationProvider.setLocale(context, locale)`
- Fallback behavior when translation key/locale is missing
- Example app and comprehensive tests
