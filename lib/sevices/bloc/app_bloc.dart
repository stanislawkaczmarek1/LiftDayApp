import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final List<AppState> _stateHistory = [];
  late List<String> _trainingDays;

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
          emit(_stateHistory.removeLast());
        }
      },
    );

    on<AppEventChoseWeekAutomation>(
      (event, emit) {
        _stateHistory.add(const AppStateCreatePlanOrSkip());
        emit(const AppStateChooseTrainingDays());
      },
    );

    on<AppEventConfirmTrainingDays>(
      (event, emit) {
        _stateHistory.add(const AppStateChooseTrainingDays());
        _trainingDays = event.selectedDays;
        if (_trainingDays.isNotEmpty) {
          emit(AppStateAddFirstWeekPlan(_trainingDays.removeAt(0)));
        }
      },
    );

    on<AppEventConfirmExercisesInDay>(
      (event, emit) {
        if (_trainingDays.isNotEmpty) {
          emit(AppStateAddFirstWeekPlan(_trainingDays.removeAt(0)));
        }
      },
    );
  }
}
