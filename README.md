# Pilates App

A Flutter application for pilates workouts with multi-language support and theme management.

## Configuration

The app uses Cubit for state management with the following configuration:
- State management: Flutter Bloc/Cubit
- Navigation: GoRouter
- Localization: Flutter i18n with ARB files
- Theme: Material Design 3 with persistent storage
- Storage: SharedPreferences for user preferences

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
├── main.dart                 # App entry point
├── cubit/                    # State management
│   ├── app/                  # Language state
│   └── theme/                # Theme state
├── config/                   # App configuration
│   ├── routes/               # Navigation routes
│   └── theme/                # Theme configuration
├── l10n/                     # Localization files
├── pages/                    # App screens
│   ├── home/                 # Home page
│   └── settings/             # Settings page
├── models/                   # Data models
├── widgets/                  # Reusable widgets
└── utils/                    # Utility functions
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
