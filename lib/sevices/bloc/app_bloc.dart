import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/crud/exercise_day.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final List<AppState> _stateHistory = [];
  final List<AppStateAddFirstWeekPlan> _firstWeekPlan = [];
  final List<ExerciseDay> _exerciseDaysData = [];
  late int durationOfPlan;
  late int currentDayOfPlanConfig;

  AppBloc() : super(const AppStateStart()) {
    //
    on<AppEventStartButton>(
      (event, emit) {
        _stateHistory.add(const AppStateStart());
        emit(const AppStateCreatePlanOrSkip());
      },
    );

    on<AppEventGoBack>(
      (event, emit) {
        if (_stateHistory.isNotEmpty) {
          if (_stateHistory.last is AppStateChooseTrainingDays) {
            _firstWeekPlan.clear();
          } else if (_stateHistory.last is AppStateAddFirstWeekPlan) {
            currentDayOfPlanConfig--;
            if (_exerciseDaysData.isNotEmpty) {
              _exerciseDaysData.removeLast();
              log("After removing: $_exerciseDaysData");
            }
          }

          emit(_stateHistory.removeLast());
        }
      },
    );

    on<AppEventConfirmWeekAutomation>(
      (event, emit) {
        _stateHistory.add(state);
        emit(const AppStateChooseTrainingDays());
      },
    );

    on<AppEventConfirmTrainingDays>(
      (event, emit) {
        _stateHistory.add(state);

        for (var i = 0; i < event.selectedDays.length; i++) {
          _firstWeekPlan
              .add(AppStateAddFirstWeekPlan(event.selectedDays.elementAt(i)));
        }

        currentDayOfPlanConfig = 0;
        if (_firstWeekPlan.isNotEmpty) {
          emit(_firstWeekPlan.elementAt(currentDayOfPlanConfig));
        }
        currentDayOfPlanConfig++;
      },
    );

    on<AppEventConfirmExercisesInDay>(
      (event, emit) {
        _stateHistory.add(state);
        _exerciseDaysData.add(event.exerciseDay);
        log("After adding: $_exerciseDaysData");
        if (currentDayOfPlanConfig < _firstWeekPlan.length) {
          if (_firstWeekPlan.isNotEmpty) {
            emit(_firstWeekPlan.elementAt(currentDayOfPlanConfig));
          }
        } else {
          emit(const AppStateChooseDurationOfPlan());
        }
        currentDayOfPlanConfig++;
      },
    );

    on<AppEventConfirmPlanDuration>(
      (event, emit) {
        _stateHistory.add(state);
        durationOfPlan = event.duration;
        emit(const AppStateMainView());
      },
    );
  }
}
