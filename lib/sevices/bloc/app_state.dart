import 'package:flutter/foundation.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final String? loadingText;

  const AppState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AppStateStart extends AppState {
  const AppStateStart({required super.isLoading});
}

class AppStateCreatePlanOrSkip extends AppState {
  const AppStateCreatePlanOrSkip({
    required super.isLoading,
  });
}

class AppStateChooseTrainingDays extends AppState {
  const AppStateChooseTrainingDays({required super.isLoading});
}

class AppStateAddFirstWeekPlan extends AppState {
  const AppStateAddFirstWeekPlan({required super.isLoading});
}
