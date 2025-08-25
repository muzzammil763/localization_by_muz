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
