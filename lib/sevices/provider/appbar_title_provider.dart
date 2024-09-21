import 'package:flutter/material.dart';

class AppBarTitleProvider extends ChangeNotifier {
  Widget _title = Image.asset('assets/liftday_logo.png', height: 25.0);

  Widget get title => _title;

  void updateTitle(Widget newTitle) async {
    _title = newTitle;
    notifyListeners();
  }

  void setDefaultTitle() async {
    _title = Image.asset('assets/liftday_logo.png', height: 25.0);
    notifyListeners();
  }

  void updateTitleBasedOnTheme(ThemeMode mode) {
    if (mode == ThemeMode.dark) {
      _title = Image.asset('assets/liftday_logo_dark.png', height: 25.0);
    } else {
      _title = Image.asset('assets/liftday_logo.png', height: 25.0);
    }
    notifyListeners();
  }
}
