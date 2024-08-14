import 'package:flutter/foundation.dart';
import 'package:liftday/sevices/crud/exercise_day.dart';

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

class AppEventConfirmWeekAutomation extends AppEvent {
  const AppEventConfirmWeekAutomation();
}

class AppEventConfirmTrainingDays extends AppEvent {
  final List<String> selectedDays;

  const AppEventConfirmTrainingDays(this.selectedDays);
}

class AppEventConfirmExercisesInDay extends AppEvent {
  final ExerciseDay exerciseDay;
  const AppEventConfirmExercisesInDay(this.exerciseDay);
}

class AppEventConfirmPlanDuration extends AppEvent {
  final int duration;
  const AppEventConfirmPlanDuration(this.duration);
}
