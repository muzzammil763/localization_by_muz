# Features Roadmap

A prioritized checklist of potential enhancements for `localization_by_muz`. Tick the items you want to implement next.

## High-impact
- [x] Parameter interpolation in strings (e.g., "Hello {name}") via args map for both inline and JSON keys
- [ ] Pluralization and gender/select rules (ICU-like), with a lightweight parser or optional `intl` integration
- [ ] Fallback locale cascade (e.g., `en-US` -> `en` -> `fallbackLocale` -> key)
- [ ] Locale persistence (e.g., `SharedPreferences`) and system-locale detection on first run
- [ ] MaterialApp integration (expose `locale`, `supportedLocales`) and RTL text-direction handling; optional `LocalizationMaterialApp` wrapper

## Medium-impact, low effort
- [x] Configurable asset strategy: custom paths and per-locale files (e.g., `assets/i18n/en.json`, `fr.json`) with merge
- [x] Pluggable loaders: `AssetLoader`, `MemoryLoader`, `HttpLoader` with simple cache; inject via `initialize()`
- [ ] Locale type support: accept/return `Locale` while keeping current String-based API for backward compatibility
- [ ] BuildContext helpers: `context.t('key', args: {...})`, `context.locale`, `context.setLocale(Locale)`
- [ ] Dev/CI CLI: validate JSON, detect missing/extra keys, generate language skeletons, sort keys
- [ ] Widgets: `LocaleDropdown` (simple switcher), `LocalizedRichText` / `LocalizedTextSpan`

## Nice-to-have
- [x] Missing key diagnostics: toggleable logs, `onMissingKey(key, locale)` callback, optional debug overlay
- [ ] Hot-reload translations in debug (auto re-read assets)
- [ ] Number/date formatting helpers (optional `intl` behind a feature flag)
- [ ] Namespaces/dotted keys (nested JSON) support

## API proposals (backward compatible)
- [ ] `LocalizationProvider` props: `supportedLocales`, `fallbackLocale`, `useSystemLocale`, `persistKey`, `assetPaths`/`loader`
- [ ] `LocalizationManager`: `initialize({defaultLocale, loader, fallbackLocale})`, `setLocale(Locale)`, `translate(key, {args})`
- [ ] Extensions: named-args version `"key".localize(args: {...})` and `context.t('key', args)`

## Testing coverage to add
- [ ] Interpolation, plural/gender/select
- [ ] Fallback cascade behavior
- [ ] Persistence + system-locale initialization
- [ ] Loader implementations (asset/memory/http)
- [ ] MaterialApp sync and RTL directionality
