import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';

@immutable
abstract class ThemeEvent extends AppEvent {
  const ThemeEvent();
}

class ThemeEventChange extends ThemeEvent {
  final bool isDarkMode;

  const ThemeEventChange({required this.isDarkMode});
}
