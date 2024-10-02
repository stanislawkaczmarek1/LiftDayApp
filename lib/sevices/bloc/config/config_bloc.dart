import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/sevices/bloc/config/config_state.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final List<ConfigState> _stateHistory = [];
  final List<ConfigStateAddFirstWeekPlan> _firstWeekPlan = [];
  int _currentDayOfPlanConfig = 0;
  final List<TrainingDayData> _exerciseDaysData = [];
  late final SettingsService _settingsService;
  bool isThatReplacementOfPlans = false;

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
        _stateHistory.add(state);
        emit(const ConfigStateCreatePlanOrSkip());
      },
    );

    on<ConfigEventGoBack>(
      (event, emit) {
        if (_stateHistory.isNotEmpty) {
          if (_stateHistory.last is ConfigStateChooseTrainingDays) {
            _currentDayOfPlanConfig = 0;
            _firstWeekPlan.clear();
          } else if (_stateHistory.last is ConfigStateAddFirstWeekPlan) {
            _currentDayOfPlanConfig--;
            if (_exerciseDaysData.isNotEmpty) {
              _exerciseDaysData.removeLast();
              log("After removing: $_exerciseDaysData");
            }
          } else if (_stateHistory.last is ConfigStateCreatePlanOrSkip) {
            _currentDayOfPlanConfig = 0;
            _exerciseDaysData.clear();
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

    on<ConfigEventConfirmAllByHand>(
      (event, emit) {
        _stateHistory.clear();
        _settingsService.setAppConfiguredFlag(true);
        emit(const ConfigStateMainView());
      },
    );

    on<ConfigEventConfirmDaysCreation>(
      (event, emit) {
        _stateHistory.add(state);
        emit(ConfigStateAddTrainingDays(++_currentDayOfPlanConfig, false));
      },
    );

    on<ConfigEventPushNextDayButton>(
      (event, emit) {
        _exerciseDaysData.add(event.trainingDay);
        if (_currentDayOfPlanConfig >= 3) {
          //numeracja 1 , 2 , ...
          //zmusza do zapisu 4 dnia

          emit(ConfigStateAddTrainingDays(_currentDayOfPlanConfig, true));
        } else {
          //debug
          log("After adding: $_exerciseDaysData");
          int a = _currentDayOfPlanConfig;
          a++;
          log("current day: $a");
          //
          emit(ConfigStateAddTrainingDays(++_currentDayOfPlanConfig, false));
        }
      },
    );

    on<ConfigEventPushDoneButton>(
      (event, emit) async {
        _exerciseDaysData.add(event.trainingDay);

        log(_exerciseDaysData.toString());
        _renameDuplicateDays(_exerciseDaysData);
        log(_exerciseDaysData.toString());

        final exerciseService = ExerciseService();
        for (TrainingDayData exerciseDay in _exerciseDaysData) {
          await exerciseService.saveTrainingDayData(exerciseDay, false);
        }

        _stateHistory.clear();
        _settingsService.setAppConfiguredFlag(true);
        _currentDayOfPlanConfig = 0;
        _exerciseDaysData.clear();

        emit(const ConfigStateMainView());
      },
    );

    on<ConfigEventConfirmTrainingDays>(
      (event, emit) {
        _stateHistory.add(state);

        for (var i = 0; i < event.selectedDays.length; i++) {
          _firstWeekPlan.add(
              ConfigStateAddFirstWeekPlan(event.selectedDays.elementAt(i)));
        }
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
      ///////
      (event, emit) async {
        _stateHistory.add(state);
        final exerciseService = ExerciseService();
        if (isThatReplacementOfPlans) {
          await exerciseService.deleteTrainingDaysDataFromPlan();
          await exerciseService
              .deleteExercisesAndSetsFromTomorrowToEndOfDates();
        }

        final dates = await exerciseService.createRangeOfDatesConfig(
          range: event.duration,
          fromDate: DateTime.now(),
        );
        final lastDate = dates.last;
        await exerciseService.createExercisesConfig(
          exerciseDays: _exerciseDaysData,
          dates: dates,
        );

        for (TrainingDayData exerciseDay in _exerciseDaysData) {
          await exerciseService.saveTrainingDayData(exerciseDay, true);
        }

        _settingsService.setPlanEndingDigitDate(lastDate.digitDate);
        _settingsService.setHasPlanFlag(true);
        _settingsService.setAppConfiguredFlag(true);

        _stateHistory.clear();
        _firstWeekPlan.clear();
        _currentDayOfPlanConfig = 0;
        _exerciseDaysData.clear();

        emit(const ConfigStateMainView());
      },
    );

    on<ConfigEventChangePlanFromMainView>(
      (event, emit) {
        _stateHistory.add(state);
        isThatReplacementOfPlans = true;
        emit(const ConfigStateChooseTrainingDays());
      },
    );

    on<ConfigEventAddPlanFromMainView>(
      (event, emit) {
        _stateHistory.add(state);
        isThatReplacementOfPlans = false;
        emit(const ConfigStateChooseTrainingDays());
      },
    );
  }
}

void _renameDuplicateDays(List<TrainingDayData> exerciseDaysData) {
  // Mapa do śledzenia liczby wystąpień każdego dnia
  Map<String, int> dayOccurrences = {};

  // Przejście przez całą listę dni treningowych
  for (int i = 0; i < exerciseDaysData.length; i++) {
    String day = exerciseDaysData[i].name;

    // Jeśli ten dzień już wystąpił, zwiększamy licznik i dodajemy go do nazwy
    if (dayOccurrences.containsKey(day)) {
      int occurrence = dayOccurrences[day]! + 1;
      dayOccurrences[day] = occurrence;
      // Aktualizacja nazwy dnia z numerem
      exerciseDaysData[i] = TrainingDayData(
        name: '$day$occurrence',
        exercises: exerciseDaysData[i].exercises,
        isFromPlan: exerciseDaysData[i].isFromPlan,
      );
    } else {
      // Jeśli ten dzień nie wystąpił wcześniej, zapisujemy go w mapie z wartością 1
      dayOccurrences[day] = 1;
    }
  }
}
