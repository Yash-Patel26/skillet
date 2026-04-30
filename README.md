# Skillet — Context-Aware Recipe Discovery

A production-grade Flutter app submitted for the **IVTEX Solutions** Mobile
App Developer assignment. Skillet recommends recipes by **time of day**,
**device location**, and **what's in your pantry** — and stays useful
without an internet connection.

> Built with **Flutter 3.35.6**, **Riverpod**, and an offline-first cache layer.
> Release APKs are produced automatically by GitHub Actions and attached to
> [GitHub Releases](../../releases).

---

## How this maps to the assignment

| Assignment requirement | Where it lives |
|---|---|
| **A1.** TheMealDB integration | `lib/data/api/meal_db_client.dart` |
| **A2.** Time-based suggestions (Breakfast/Lunch/Dinner) | `core/utils/context_helper.dart` + `dayPartFeedProvider` |
| **A3.** Location-based regional cuisine | `data/repositories/region_repository.dart` (reverse-geocode → ISO country → MealDB area via `core/utils/region_helper.dart`) — drives the **"Trending in <country>"** rail |
| **A4.** Search with debouncing | `features/search/presentation/search_page.dart` — `Timer(350ms)` debounce |
| **B1.** Favorite for offline viewing | `data/local/favorites_db.dart` (sqflite, table `favorites`) |
| **B2.** Caching of recipe data + images | `recipe_cache` and `feed_cache` tables in sqflite + `cached_network_image` for image disk cache |
| **B3.** Network-failure resilience | `RecipeRepository` catches `Failure` and falls back to cached feeds; global `OfflineBanner` shown app-wide |
| **C1.** Scheduled meal-time notifications | `data/local/notifications_service.dart` — schedules 8 AM / 2 PM / 8 PM with a real recipe name in the body |
| **C2.** Permission handling (location + notifications) | `region_repository.dart` falls back to last-known coords if denied; `notifications_service.requestPermission()` is non-blocking — denied users still get the rest of the app |
| **2.** Riverpod state management | All `*_providers.dart` files; no global `setState` |
| **2.** Shimmer loaders | `shared/widgets/loading_grid.dart` + `RecipeCard` thumbnails |
| **2.** Animated favorite + Hero transitions | `shared/widgets/animated_favorite_button.dart` (scale + AnimatedSwitcher); `Hero(tag: 'recipe-{id}')` between list and detail |
| **2.** Global error UI | `shared/widgets/offline_banner.dart` driven by `connectivity_plus`; cached fallback inside repos |
| **3.** CI/CD with auto-release | [`.github/workflows/main.yml`](.github/workflows/main.yml) |
| **Bonus.** Multi-language UI (EN / HI / ES / FR / AR + RTL) | `lib/l10n/*.arb` via Flutter gen-l10n; `LanguagePicker` in onboarding + Profile bottom sheet |

---

## Architectural choices

```
┌──────────────────────── presentation ────────────────────────┐
│  features/<area>/presentation   (Widgets — ConsumerWidget)   │
│  features/<area>/providers      (Riverpod state per feature) │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────── domain ────────────────────────────┐
│  data/repositories                                           │
│    RecipeRepository      — network + cache fallback          │
│    FavoritesRepository   — sqflite favorites                 │
│    RegionRepository      — geolocation + reverse geocoding   │
│    WeatherRepository     — Open-Meteo (bonus signal)         │
└──────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────── data sources ────────────────────────┐
│  data/api          MealDbClient (Dio), WeatherClient         │
│  data/local        FavoritesDb (sqflite), PrefsStore         │
│                    NotificationsService                      │
└──────────────────────────────────────────────────────────────┘
```

**Why this shape**

- **Repository pattern**: every UI-facing async call goes through a
  repository, so the offline-cache fallback (`try { fetch } on Failure {
  cache }`) is centralized in one place rather than scattered through
  providers. Adding a new data source means one new repository, not a global
  refactor.
- **Riverpod over Bloc**: lighter ceremony for this size of app. `FutureProvider.family`
  cleanly handles per-recipe loading, and `StateNotifier` covers user prefs.
- **Feed cache keyed by query**: rather than caching individual recipes in
  every list response, we store the *result of each feed call* under a key
  like `cat:Breakfast` or `area:Indian`. Reopening the home tab while
  offline shows the same rails as the last online session.
- **Context as parallel signals**: time, location, and pantry are
  independent `FutureProvider`s — a slow weather/region call never blocks
  the time-of-day rail from rendering.

**Module breakdown**

```
lib/
├── main.dart                  # ProviderScope + SharedPreferences override
├── app/
│   ├── app.dart               # MaterialApp.router + theme wiring
│   ├── router.dart            # GoRouter (ShellRoute for tabs)
│   ├── providers.dart         # Root-level repository / store providers
│   └── connectivity_providers.dart
├── core/
│   ├── constants/             # AppConstants (URLs, prefs keys)
│   ├── theme/                 # AppTheme (Material 3, warm orange)
│   ├── errors/                # Sealed Failure hierarchy
│   └── utils/                 # ContextHelper (day-part), RegionHelper (ISO→area)
├── data/
│   ├── api/                   # MealDbClient, WeatherClient (Dio)
│   ├── local/                 # FavoritesDb (sqflite v2 — favorites + cache + feeds), PrefsStore, NotificationsService
│   ├── models/                # Recipe, Ingredient, Weather, UserPrefs
│   └── repositories/          # Recipe / Favorites / Region / Weather
├── features/
│   ├── onboarding/            # 3-slide intro
│   ├── preferences/           # Diet, allergies, cuisines, skill, pantry
│   ├── home/                  # Context-aware discovery (4 rails + featured)
│   ├── search/                # Debounced search + category chips
│   ├── recipe_detail/         # Hero image, ingredient checklist, steps
│   ├── cook_mode/             # Full-screen step-by-step + wakelock
│   ├── favorites/             # sqflite-backed saved list (offline)
│   └── profile/               # Theme toggle + edit prefs
└── shared/widgets/            # RecipeCard, SectionHeader, LoadingGrid,
                                 AnimatedFavoriteButton, OfflineBanner
```

---

## CI/CD

The workflow at [`.github/workflows/main.yml`](.github/workflows/main.yml)
runs on every push and pull request to `main`, plus manual dispatch.

### What it does

1. Checks out the repo and sets up Java 17 + Flutter 3.35.6.
2. `flutter pub get` → `flutter analyze` → `flutter test`.
3. `flutter build apk --release`.
4. Uploads the APK as a build artifact (always).
5. **On `push` to `main` only:** publishes the APK to **GitHub Releases**
   under tag `build-<short-sha>-<run-number>` using
   `softprops/action-gh-release@v2`.

### How to trigger it

| Event | Result |
|---|---|
| `git push` to `main` | Full pipeline + auto-publish to Releases |
| Open a PR targeting `main` | Analyze + test + APK artifact (no Release) |
| GitHub UI → Actions → "CI" → **Run workflow** | Manual run on any branch |

The workflow uses the built-in `GITHUB_TOKEN` — no manual secret setup is
required. Release permissions are declared inline (`permissions: contents:
write`).

---

## Running locally

```bash
flutter pub get
flutter run                  # debug build
flutter analyze && flutter test
flutter build apk --release  # → build/app/outputs/flutter-apk/app-release.apk
```

### No API keys required

- **TheMealDB** uses the public test key `1` (already wired into
  `AppConstants.mealDbBaseUrl`).
- **Open-Meteo** has no key.
- **Reverse geocoding** uses the platform's `geocoding` package (Android's
  built-in `Geocoder`).

### Permissions

| Permission | Purpose | Fallback if denied |
|---|---|---|
| `INTERNET` | TheMealDB + Open-Meteo + reverse-geocode | n/a |
| `ACCESS_*_LOCATION` | Region + weather | App keeps running; region/weather rails are silently hidden |
| `POST_NOTIFICATIONS` | Daily meal reminders | App keeps running; reminders are skipped |
| `WAKE_LOCK` | Keep screen on in cook mode | n/a |
| `RECEIVE_BOOT_COMPLETED` | Re-arm reminders after reboot | n/a |

---

## Tech stack

- **Flutter** 3.35.6 / **Dart** 3.9.2
- **flutter_riverpod** — state
- **dio** — HTTP
- **sqflite** — favorites + recipe cache + feed cache (3 tables, schema v2)
- **shared_preferences** — user prefs, theme mode, last-known location
- **go_router** — declarative navigation with a `ShellRoute` for bottom-nav
- **geolocator** + **geocoding** — coordinates → ISO country code
- **connectivity_plus** — drives the global offline banner
- **flutter_local_notifications** + **timezone** — scheduled meal reminders
- **wakelock_plus** — screen-on in cook mode
- **cached_network_image** + **shimmer** — image disk cache + skeleton loaders
- **google_fonts** (Inter) — typography
- **flutter_localizations** + **intl** — 5-language UI (gen-l10n)

---

## Submission checklist

- [x] Repo pushed to GitHub (private or public link in the email reply)
- [x] `.github/workflows/main.yml` builds & publishes APK on `main`
- [x] Latest APK auto-attached to **GitHub Releases**
- [x] README documents architecture + CI/CD trigger
- [x] `flutter analyze` passes (0 issues)
- [x] Verified by `flutter build apk --release` locally before push
