part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final bool isDark;

  const ThemeState({required this.isDark});

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  @override
  List<Object?> get props => [isDark];
}
