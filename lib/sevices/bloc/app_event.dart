import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liftday/sevices/crud/training_day.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
abstract class ConfigEvent extends AppEvent {
  const ConfigEvent();
}

class ConfigEventChceckAppConfigured extends ConfigEvent {
  const ConfigEventChceckAppConfigured();
}

class ConfigEventStartButton extends ConfigEvent {
  const ConfigEventStartButton();
}

class ConfigEventGoBack extends ConfigEvent {
  const ConfigEventGoBack();
}

class ConfigEventConfirmWeekAutomation extends ConfigEvent {
  const ConfigEventConfirmWeekAutomation();
}

class ConfigEventConfirmTrainingDays extends ConfigEvent {
  final List<String> selectedDays;

  const ConfigEventConfirmTrainingDays(this.selectedDays);
}

class ConfigEventConfirmExercisesInDay extends ConfigEvent {
  final TrainingDay trainingDay;
  const ConfigEventConfirmExercisesInDay(this.trainingDay);
}

class ConfigEventConfirmPlanDuration extends ConfigEvent {
  final int duration;
  const ConfigEventConfirmPlanDuration(this.duration);
}

@immutable
abstract class EditEvent extends AppEvent {
  const EditEvent();
}

class EditEventPushEditIconOnPlansPage extends EditEvent {
  final BuildContext context;
  final TrainingDay trainingDay;
  const EditEventPushEditIconOnPlansPage(this.context, this.trainingDay);
}
