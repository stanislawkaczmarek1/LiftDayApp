import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
import 'app_bar_event.dart';
import 'app_bar_state.dart';

class AppBarBloc extends Bloc<AppBarEvent, AppBarState> {
  bool _isDarkMode = false;
  AppBarBloc()
      : super(
            AppBarState(Image.asset('assets/liftday_logo.png', height: 25.0))) {
    _loadThemePreference();

    on<AppBarEventUpdateTitle>((event, emit) {
      emit(AppBarState(event.newTitle));
    });

    on<AppBarEventUpdateTitleBasedOnTheme>((event, emit) {
      Widget newTitle;
      if (event.themeMode == ThemeMode.dark) {
        _isDarkMode = true;
        newTitle = Image.asset('assets/liftday_logo_dark.png', height: 25.0);
      } else {
        _isDarkMode = false;
        newTitle = Image.asset('assets/liftday_logo.png', height: 25.0);
      }
      emit(AppBarState(newTitle));
    });

    on<AppBarEventSetDefaultTitle>(
      (event, emit) {
        Widget newTitle;
        if (_isDarkMode == true) {
          newTitle = Image.asset('assets/liftday_logo_dark.png', height: 25.0);
        } else {
          newTitle = Image.asset('assets/liftday_logo.png', height: 25.0);
        }
        emit(AppBarState(newTitle));
      },
    );
  }

  void _loadThemePreference() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();
    final isDark = settingsService.isDarkModeFlag();
    if (isDark) {
      add(const AppBarEventUpdateTitleBasedOnTheme(ThemeMode.dark));
    } else {
      add(const AppBarEventUpdateTitleBasedOnTheme(ThemeMode.light));
    }
  }
}
