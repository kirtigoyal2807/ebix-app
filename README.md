# Pilates App

A Flutter application for pilates workouts with multi-language support and theme management.

## Configuration

The app uses Cubit for state management with the following configuration:
- State management: Flutter Bloc / Cubit (feature-level cubits)
- Navigation: `MaterialApp` and `Navigator` (auth flow via `AuthRootView`; modal routes where needed)
- Localization: `intl` + `flutter_localizations` with ARB files under `lib/core/localization/arb`
- Theme: Material with centralized `AppTheme` / `AppColors` (light & dark), driven by `AuthCubit` with persistent preferences
- Storage: `SharedPreferences` via `TokenStorage` and related persistence

## Installation

1. **Prerequisites**
   - Flutter SDK 3.10.7+
   - Dart SDK 3.10.7+

2. **Setup**
   ```bash
   flutter pub get
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                 # App entry, DI (Dio, repositories), `PilatesApp`
├── config/                   # App configuration
│   └── theme/                # `AppTheme`, colors, typography, spacing
├── core/                     # Shared infrastructure
│   ├── constants/            # API and app constants
│   ├── localization/arb/    # `app_en.arb`, `app_ar.arb`, generated l10n
│   ├── network/              # Dio client, repositories base layer
│   ├── storage/              # Token and preference storage
│   ├── utils/                # Helpers
│   ├── validation/           # Shared validation
│   └── connectivity/         # Connectivity checks for bootstrap
├── features/                 # Feature modules (auth, home, booking, account, …)
│   ├── auth/                 # Onboarding, sign-in/up, auth cubit
│   ├── connectivity/         # Offline gate and no-internet UI
│   ├── home/
│   ├── account/
│   ├── booking/
│   ├── explore/
│   ├── checkout/
│   └── …                     # Other domains (subscriptions, loyalty, etc.)
├── widgets/                  # Shared UI (`AppScaffold`, `AppTextField`, …)
└── …
```

## Localization Languages

The app supports the following languages:
- **English (en)** - Left-to-right layout
- **Arabic (ar)** - Right-to-left layout with RTL support

## Theme Modes

The app includes three theme modes:
- **Light Mode** - Light theme with bright colors
- **Dark Mode** - Dark theme with darker colors
- **System Mode** - Follows device system theme settings
