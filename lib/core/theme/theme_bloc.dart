import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;
  static const _themeKey = 'is_dark_mode';

  ThemeBloc({required this.sharedPreferences})
      : super(ThemeState(
          isDark: sharedPreferences.getBool('is_dark_mode') ?? true,
        )) {
    on<ThemeToggled>(_onThemeToggled);
  }

  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) async {
    final newIsDark = !state.isDark;
    await sharedPreferences.setBool(_themeKey, newIsDark);
    emit(ThemeState(isDark: newIsDark));
  }
}
