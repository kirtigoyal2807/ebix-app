part of 'app_cubit.dart';

class AppState {
  final Locale locale;
  final bool isLoading;

  const AppState({
    required this.locale,
    required this.isLoading,
  });

  AppState copyWith({
    Locale? locale,
    bool? isLoading,
  }) {
    return AppState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          locale == other.locale &&
          isLoading == other.isLoading;

  @override
  int get hashCode => locale.hashCode ^ isLoading.hashCode;
}
