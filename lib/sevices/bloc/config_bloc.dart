import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final List<ConfigState> _stateHistory = [];
  final List<ConfigStateAddFirstWeekPlan> _firstWeekPlan = [];
  late int _currentDayOfPlanConfig;
  final List<TrainingDay> _exerciseDaysData = [];
  late final ExerciseService _exerciseService;
  late final SettingsService _settingsService;

  ConfigBloc() : super(const ConfigStateInit()) {
    //
    on<ConfigEventChceckAppConfigured>(
      (event, emit) async {
        _settingsService = SettingsService();
        await _settingsService.init();
        if (_settingsService.isAppConfiguredFlag()) {
          emit(const ConfigStateMainView());
        } else {
          emit(const ConfigStateStart());
        }
      },
    );

    on<ConfigEventStartButton>(
      (event, emit) {
        _stateHistory.add(const ConfigStateStart());
        emit(const ConfigStateCreatePlanOrSkip());
      },
    );

    on<ConfigEventGoBack>(
      (event, emit) {
        if (_stateHistory.isNotEmpty) {
          if (_stateHistory.last is ConfigStateChooseTrainingDays) {
            _firstWeekPlan.clear();
          } else if (_stateHistory.last is ConfigStateAddFirstWeekPlan) {
            _currentDayOfPlanConfig--;
            if (_exerciseDaysData.isNotEmpty) {
              _exerciseDaysData.removeLast();
              log("After removing: $_exerciseDaysData");
            }
          }

          emit(_stateHistory.removeLast());
        }
      },
    );

    on<ConfigEventConfirmWeekAutomation>(
      (event, emit) {
        _stateHistory.add(state);
        emit(const ConfigStateChooseTrainingDays());
      },
    );

    on<ConfigEventConfirmTrainingDays>(
      (event, emit) {
        _stateHistory.add(state);

        for (var i = 0; i < event.selectedDays.length; i++) {
          _firstWeekPlan.add(
              ConfigStateAddFirstWeekPlan(event.selectedDays.elementAt(i)));
        }

        _currentDayOfPlanConfig = 0;
        if (_firstWeekPlan.isNotEmpty) {
          emit(_firstWeekPlan.elementAt(_currentDayOfPlanConfig));
        }
        _currentDayOfPlanConfig++;
      },
    );

    on<ConfigEventConfirmExercisesInDay>(
      (event, emit) {
        _stateHistory.add(state);
        _exerciseDaysData.add(event.trainingDay);
        log("After adding: $_exerciseDaysData");
        if (_currentDayOfPlanConfig < _firstWeekPlan.length) {
          if (_firstWeekPlan.isNotEmpty) {
            emit(_firstWeekPlan.elementAt(_currentDayOfPlanConfig));
          }
        } else {
          emit(const ConfigStateChooseDurationOfPlan());
        }
        _currentDayOfPlanConfig++;
      },
    );

    on<ConfigEventConfirmPlanDuration>(
      (event, emit) async {
        _stateHistory.add(state);

        if (!_settingsService.isAppConfiguredFlag()) {
          _exerciseService = ExerciseService();
          final dates = await _exerciseService.createRangeOfDatesConfig(
            range: event.duration,
          );
          _exerciseService.createExercisesConfig(
            exerciseDays: _exerciseDaysData,
            dates: dates,
          );

          for (TrainingDay exerciseDay in _exerciseDaysData) {
            await _exerciseService.saveTrainingDay(exerciseDay);
          }
          _settingsService.setHasPlanFlag(true);
          _settingsService.setAppConfiguredFlag(true);
          emit(const ConfigStateMainView());
        }
      },
    );
  }
}
