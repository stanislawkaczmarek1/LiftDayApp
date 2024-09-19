import 'package:flutter/foundation.dart';
import 'package:liftday/sevices/crud/training_day.dart';

@immutable
abstract class AppState {
  const AppState();
}

@immutable
abstract class ConfigState extends AppState {
  const ConfigState();
}

class ConfigStateInit extends ConfigState {
  const ConfigStateInit();
}

class ConfigStateStart extends ConfigState {
  const ConfigStateStart();
}

class ConfigStateCreatePlanOrSkip extends ConfigState {
  const ConfigStateCreatePlanOrSkip();
}

class ConfigStateChooseTrainingDays extends ConfigState {
  const ConfigStateChooseTrainingDays();
}

class ConfigStateAddFirstWeekPlan extends ConfigState {
  final String dayOfWeek;
  const ConfigStateAddFirstWeekPlan(this.dayOfWeek);
}

class ConfigStateChooseDurationOfPlan extends ConfigState {
  const ConfigStateChooseDurationOfPlan();
}

class ConfigStateMainView extends ConfigState {
  const ConfigStateMainView();
}

@immutable
abstract class EditState extends AppState {
  const EditState();
}

class EditStateInit extends EditState {
  const EditStateInit();
}

class EditStateTrainingDayAddOrEdit extends EditState {
  final TrainingDay trainingDay;
  const EditStateTrainingDayAddOrEdit(this.trainingDay);
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
