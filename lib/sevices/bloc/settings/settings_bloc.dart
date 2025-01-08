import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_event.dart';
import 'package:liftday/sevices/bloc/settings/settings_state.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(SettingsState(
          locale: _getDefaultLocale(),
          themeMode: ThemeMode.dark,
          unit: 'kg',
          showCalendar: true,
        )) {
    _loadUserSettings();

    on<SettingsEventChangeLanguage>((event, emit) async {
      SettingsService settingsService = SettingsService();
      await settingsService.setLanguage(event.locale.languageCode);

      emit(SettingsState(
        locale: event.locale,
        themeMode: state.themeMode,
        unit: state.unit,
        showCalendar: state.showCalendar,
      ));
    });

    on<SettingsEventChangeTheme>((event, emit) async {
      final themeMode = event.isDarkMode ? ThemeMode.dark : ThemeMode.light;
      SettingsService settingsService = SettingsService();
      await settingsService.setIsDarkModeFlag(event.isDarkMode);

      emit(SettingsState(
        locale: state.locale,
        themeMode: themeMode,
        unit: state.unit,
        showCalendar: state.showCalendar,
      ));
    });

    on<SettingsEventChangeWeightUnit>((event, emit) async {
      SettingsService settingsService = SettingsService();
      if (event.unit == "lbs") {
        await settingsService.setWeightUnit('lbs');
      } else {
        await settingsService.setWeightUnit('kg');
      }

      emit(SettingsState(
        locale: state.locale,
        themeMode: state.themeMode,
        unit: event.unit,
        showCalendar: state.showCalendar,
      ));
    });

    on<SettingsEventShowCalendar>(
      (event, emit) async {
        SettingsService settingsService = SettingsService();
        await settingsService.setShowCalendarFlag(event.showCalendar);
        emit(SettingsState(
          locale: state.locale,
          themeMode: state.themeMode,
          unit: state.unit,
          showCalendar: event.showCalendar,
        ));
      },
    );
  }

  static Locale _getDefaultLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    if (systemLocale.languageCode == 'pl') {
      return const Locale('pl');
    }
    return const Locale('en');
  }

  void _loadUserSettings() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();

    final language = settingsService.language();
    if (language != null) {
      add(SettingsEventChangeLanguage(Locale(language)));
    } else {
      add(SettingsEventChangeLanguage(_getDefaultLocale()));
    }

    add(SettingsEventChangeTheme(isDarkMode: settingsService.isDarkModeFlag()));

    final unit = settingsService.weightUnit();
    if (unit == "lbs") {
      add(const SettingsEventChangeWeightUnit("lbs"));
    } else {
      add(const SettingsEventChangeWeightUnit("kg"));
    }

    add(SettingsEventShowCalendar(
        showCalendar: settingsService.showCalendar()));
  }
}
