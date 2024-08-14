import 'package:flutter/foundation.dart';

@immutable
abstract class AppState {
  const AppState();
}

class AppStateStart extends AppState {
  const AppStateStart();
}

class AppStateCreatePlanOrSkip extends AppState {
  const AppStateCreatePlanOrSkip();
}

class AppStateChooseTrainingDays extends AppState {
  const AppStateChooseTrainingDays();
}

class AppStateAddFirstWeekPlan extends AppState {
  final String dayOfWeek;
  const AppStateAddFirstWeekPlan(this.dayOfWeek);
}

class AppStateChooseDurationOfPlan extends AppState {
  const AppStateChooseDurationOfPlan();
}

class AppStateMainView extends AppState {
  const AppStateMainView();
}
