part of 'theme_app_cubit.dart';

sealed class ThemeAppState extends Equatable {
  const ThemeAppState();

  @override
  List<Object> get props => [];
}

final class ThemeAppInitial extends ThemeAppState {}

final class ThemeAppLight extends ThemeAppState {}

final class ThemeAppDark extends ThemeAppState {}
