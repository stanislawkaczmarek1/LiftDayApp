import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/crud/exercise_day.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final List<AppState> _stateHistory = [];
  final List<AppStateAddFirstWeekPlan> _firstWeekPlan = [];
  late int _currentDayOfPlanConfig;
  final List<ExerciseDay> _exerciseDaysData = [];
  late final ExerciseService _exerciseService;
  late final SettingsService _settingsService;

  AppBloc() : super(const AppStateInit()) {
    //
    on<AppEventChceckAppConfigured>(
      (event, emit) async {
        _settingsService = SettingsService();
        await _settingsService.init();
        if (_settingsService.isAppConfiguredFlag()) {
          emit(const AppStateMainView());
        } else {
          emit(const AppStateStart());
        }
      },
    );

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

        _currentDayOfPlanConfig = 0;
        if (_firstWeekPlan.isNotEmpty) {
          emit(_firstWeekPlan.elementAt(_currentDayOfPlanConfig));
        }
        _currentDayOfPlanConfig++;
      },
    );

    on<AppEventConfirmExercisesInDay>(
      (event, emit) {
        _stateHistory.add(state);
        _exerciseDaysData.add(event.exerciseDay);
        log("After adding: $_exerciseDaysData");
        if (_currentDayOfPlanConfig < _firstWeekPlan.length) {
          if (_firstWeekPlan.isNotEmpty) {
            emit(_firstWeekPlan.elementAt(_currentDayOfPlanConfig));
          }
        } else {
          emit(const AppStateChooseDurationOfPlan());
        }
        _currentDayOfPlanConfig++;
      },
    );

    on<AppEventConfirmPlanDuration>(
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

          for (ExerciseDay exerciseDay in _exerciseDaysData) {
            await _exerciseService.saveTrainingDay(exerciseDay);
          }

          _settingsService.setAppConfiguredFlag(true);
          emit(const AppStateMainView());
        }
      },
    );
  }
}
