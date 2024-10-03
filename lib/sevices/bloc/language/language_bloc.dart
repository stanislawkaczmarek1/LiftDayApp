import 'dart:ui';
import 'package:bloc/bloc.dart';
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
  LanguageBloc() : super(LanguageState(_getDefaultLocale())) {
    _loadLanguagePreference();

    on<ChangeLanguage>((event, emit) {
      SettingsService settingsService = SettingsService();
      settingsService.setLanguage(event.locale.languageCode);
      emit(LanguageState(event.locale));
    });
  }

  static Locale _getDefaultLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    if (systemLocale.languageCode == 'pl') {
      return const Locale(
          'pl'); // Jeśli urządzenie ma język polski, ustaw polski
    }
    return const Locale('en'); // Domyślnie angielski
  }

  void _loadLanguagePreference() async {
    SettingsService settingsService = SettingsService();
    await settingsService.init();
    final language = settingsService.language();
    if (language != null) {
      add(ChangeLanguage(Locale(language)));
    }
  }
}
