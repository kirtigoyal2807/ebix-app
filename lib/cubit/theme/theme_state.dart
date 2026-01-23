part of 'theme_cubit.dart';

class ThemeState {
  final ThemeMode themeMode;
  final bool isDarkMode;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeState &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode &&
          isDarkMode == other.isDarkMode;

  @override
  int get hashCode => themeMode.hashCode ^ isDarkMode.hashCode;
}
