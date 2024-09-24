import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

abstract class LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;
  ChangeLanguage(this.locale);
}

class LanguageState {
  final Locale locale;
  LanguageState(this.locale);
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('en'))) {
    _loadThemePreference();

    on<ChangeLanguage>((event, emit) {
      SettingsService settingsService = SettingsService();
      if (event.locale == const Locale('pl')) {
        settingsService.setLanguage('pl');
      } else {
        settingsService.setLanguage('en');
      }
      emit(LanguageState(event.locale));
    });
  }

  void _loadThemePreference() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();
    final language = settingsService.language();
    if (language == "pl") {
      add(ChangeLanguage(const Locale("pl")));
    } else {
      add(ChangeLanguage(const Locale("en")));
    }
  }
}
