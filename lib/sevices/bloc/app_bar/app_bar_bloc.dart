import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
import 'app_bar_event.dart';
import 'app_bar_state.dart';

class AppBarBloc extends Bloc<AppBarEvent, AppBarState> {
  AppBarBloc()
      : super(AppBarState(
            Image.asset('assets/liftday_logo_cal_dm.png', height: 25.0))) {
    _loadThemePreference();

    on<AppBarEventUpdateTitle>((event, emit) {
      emit(AppBarState(event.newTitle));
    });

    on<AppBarEventSetDefaultTitle>(
      (event, emit) {
        Widget newTitle;
        if (event.isDarkMode == true) {
          newTitle =
              Image.asset('assets/liftday_logo_cal_dm.png', height: 25.0);
        } else {
          newTitle =
              Image.asset('assets/liftday_logo_cal_lm.png', height: 25.0);
        }
        emit(AppBarState(newTitle));
      },
    );
  }

  void _loadThemePreference() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();
    final isDark = settingsService.isDarkModeFlag();

    add(AppBarEventSetDefaultTitle(isDark));
  }
}
