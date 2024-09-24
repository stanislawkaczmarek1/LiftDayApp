import 'package:flutter/foundation.dart';
import 'package:liftday/sevices/bloc/abstract/app_state.dart';

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

class ConfigStateAddTrainingDays extends ConfigState {
  final int numberOfDays;
  final bool maximumOfDays;
  const ConfigStateAddTrainingDays(this.numberOfDays, this.maximumOfDays);
}
