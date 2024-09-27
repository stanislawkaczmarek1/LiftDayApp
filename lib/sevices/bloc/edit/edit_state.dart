import 'package:flutter/foundation.dart';
import 'package:liftday/sevices/bloc/abstract/app_state.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';

@immutable
abstract class EditState extends AppState {
  const EditState();
}

class EditStateInit extends EditState {
  const EditStateInit();
}

class EditStateEditTrainingDayFromPlan extends EditState {
  final TrainingDayData trainingDay;
  const EditStateEditTrainingDayFromPlan(this.trainingDay);
}

class EditStateEditOtherTrainingDay extends EditState {
  final TrainingDayData trainingDay;
  const EditStateEditOtherTrainingDay(this.trainingDay);
}

class EditStateAddOtherTrainingDay extends EditState {
  const EditStateAddOtherTrainingDay();
}

class EditStateDayUpdated extends EditState {
  const EditStateDayUpdated();
}

class EditStatePlanDeleted extends EditState {
  const EditStatePlanDeleted();
}

class EditStateDayDeleted extends EditState {
  const EditStateDayDeleted();
}
