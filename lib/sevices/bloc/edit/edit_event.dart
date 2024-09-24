import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';
import 'package:liftday/sevices/crud/tables/training_day.dart';

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

class EditEventDeleteTrainingDay extends EditEvent {
  final TrainingDay trainingDay;
  const EditEventDeleteTrainingDay(this.trainingDay);
}
