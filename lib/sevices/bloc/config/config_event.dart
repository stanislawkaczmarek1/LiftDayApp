import 'package:flutter/foundation.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';
import 'package:liftday/sevices/crud/tables/training_day.dart';

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

class ConfigEventConfirmDaysCreation extends ConfigEvent {
  const ConfigEventConfirmDaysCreation();
}

class ConfigEventConfirmAllByHand extends ConfigEvent {
  const ConfigEventConfirmAllByHand();
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

class ConfigEventAddPlanFromMainView extends ConfigEvent {
  const ConfigEventAddPlanFromMainView();
}

class ConfigEventChangePlanFromMainView extends ConfigEvent {
  const ConfigEventChangePlanFromMainView();
}

class ConfigEventPushNextDayButton extends ConfigEvent {
  final TrainingDay trainingDay;
  const ConfigEventPushNextDayButton(this.trainingDay);
}

class ConfigEventPushDoneButton extends ConfigEvent {
  final TrainingDay trainingDay;
  const ConfigEventPushDoneButton(this.trainingDay);
}
