import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';

@immutable
abstract class SettingsEvent extends AppEvent {
  const SettingsEvent();
}

class SettingsEventChangeLanguage extends SettingsEvent {
  final Locale locale;
  const SettingsEventChangeLanguage(this.locale);
}

class SettingsEventChangeTheme extends SettingsEvent {
  final bool isDarkMode;
  const SettingsEventChangeTheme({required this.isDarkMode});
}

class SettingsEventChangeWeightUnit extends SettingsEvent {
  final String unit;
  const SettingsEventChangeWeightUnit(this.unit);
}

class SettingsEventShowCalendar extends SettingsEvent {
  final bool showCalendar;
  const SettingsEventShowCalendar({required this.showCalendar});
}
