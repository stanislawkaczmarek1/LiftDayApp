import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';

@immutable
abstract class EditEvent extends AppEvent {
  const EditEvent();
}

class EditEventEditTrainingDayFromPlan extends EditEvent {
  final BuildContext context;
  final TrainingDayData trainingDay;
  const EditEventEditTrainingDayFromPlan(
    this.context,
    this.trainingDay,
  );
}

class EditEventEditOtherTrainingDay extends EditEvent {
  final BuildContext context;
  final TrainingDayData trainingDay;
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
  final TrainingDayData trainingDay;
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
  final TrainingDayData trainingDay;
  const EditEventDeleteTrainingDay(this.trainingDay);
}
