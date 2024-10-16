import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_state.dart';

class SettingsState extends AppState {
  final Locale locale;
  final ThemeMode themeMode;
  final String unit;

  const SettingsState(
      {required this.locale, required this.themeMode, required this.unit});
}
