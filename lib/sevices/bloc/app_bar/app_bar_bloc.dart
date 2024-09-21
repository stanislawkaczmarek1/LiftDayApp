import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_bar_event.dart';
import 'app_bar_state.dart';

class AppBarBloc extends Bloc<AppBarEvent, AppBarState> {
  AppBarBloc()
      : super(
            AppBarState(Image.asset('assets/liftday_logo.png', height: 25.0)));

  Stream<AppBarState> mapEventToState(AppBarEvent event) async* {
    if (event is AppBarEventUpdateTitle) {
      yield AppBarState(event.newTitle);
    } else if (event is AppBarEventUpdateTitleBasedOnTheme) {
      Widget newTitle;
      if (event.themeMode == ThemeMode.dark) {
        newTitle = Image.asset('assets/liftday_logo_dark.png', height: 25.0);
      } else {
        newTitle = Image.asset('assets/liftday_logo.png', height: 25.0);
      }
      yield AppBarState(newTitle);
    }
  }
}
