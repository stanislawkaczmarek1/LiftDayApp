import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';

@immutable
abstract class AppBarEvent extends AppEvent {
  const AppBarEvent();
}

class AppBarEventUpdateTitle extends AppBarEvent {
  final Widget newTitle;

  const AppBarEventUpdateTitle(this.newTitle);
}

class AppBarEventSetDefaultTitle extends AppBarEvent {
  final bool isDarkMode;
  const AppBarEventSetDefaultTitle(this.isDarkMode);
}
