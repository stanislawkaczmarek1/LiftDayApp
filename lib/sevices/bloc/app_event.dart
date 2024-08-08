import 'package:flutter/foundation.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

class AppEventStartButton extends AppEvent {
  const AppEventStartButton();
}

class AppEventGoBack extends AppEvent {
  const AppEventGoBack();
}

class AppEventChoseWeekAutomation extends AppEvent {
  const AppEventChoseWeekAutomation();
}

class AppEventConfirmTrainingDays extends AppEvent {
  final List<String> selectedDays;

  const AppEventConfirmTrainingDays(this.selectedDays);
}

class AppEventConfirmExercisesInDay extends AppEvent {
  final String data;
  const AppEventConfirmExercisesInDay(this.data);
}
