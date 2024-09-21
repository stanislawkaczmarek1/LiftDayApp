import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_event.dart';
import 'package:liftday/sevices/bloc/theme/theme_state.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    _loadThemePreference();
    on<ThemeEventChange>((event, emit) {
      final themeMode = event.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      emit(ThemeState(themeMode: themeMode));
      _saveThemePreference(event.isDarkMode);
    });
  }

  void _loadThemePreference() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();
    add(ThemeEventChange(isDarkMode: settingsService.isDarkModeFlag()));
  }

  void _saveThemePreference(bool isDarkMode) async {
    SettingsService settingsService = SettingsService();
    await settingsService.setIsDarkModeFlag(isDarkMode);
  }
}
