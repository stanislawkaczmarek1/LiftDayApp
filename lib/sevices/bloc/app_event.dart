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

@immutable
abstract class EditEvent extends AppEvent {
  const EditEvent();
}

class EditEventEditTrainingDayFromPlan extends EditEvent {
  final BuildContext context;
  final TrainingDay trainingDay;
  const EditEventEditTrainingDayFromPlan(
    this.context,
    this.trainingDay,
  );
}

class EditEventEditOtherTrainingDay extends EditEvent {
  final BuildContext context;
  final TrainingDay trainingDay;
  const EditEventEditOtherTrainingDay(
    this.context,
    this.trainingDay,
  );
}

class EditEventAddOtherTrainingDay extends EditEvent {
  final BuildContext context;
  const EditEventAddOtherTrainingDay(
    this.context,
  );
}

class EditEventPushSaveButton extends EditEvent {
  final BuildContext context;
  final TrainingDay trainingDay;
  final String currentName;
  const EditEventPushSaveButton(
      this.context, this.trainingDay, this.currentName);
}

class EditEventEndedEdition extends EditEvent {
  const EditEventEndedEdition();
}

class EditEventPushDeletePlanButton extends EditEvent {
  const EditEventPushDeletePlanButton();
}

class ConfigEventAddPlanFromMainView extends ConfigEvent {
  const ConfigEventAddPlanFromMainView();
}

class ConfigEventChangePlanFromMainView extends ConfigEvent {
  const ConfigEventChangePlanFromMainView();
}

class EditEventDeleteTrainingDay extends EditEvent {
  final TrainingDay trainingDay;
  const EditEventDeleteTrainingDay(this.trainingDay);
}

class ConfigEventPushNextDayButton extends ConfigEvent {
  final TrainingDay trainingDay;
  const ConfigEventPushNextDayButton(this.trainingDay);
}

class ConfigEventPushDoneButton extends ConfigEvent {
  final TrainingDay trainingDay;
  const ConfigEventPushDoneButton(this.trainingDay);
}
