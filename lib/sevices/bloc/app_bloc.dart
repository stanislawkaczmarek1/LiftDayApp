import 'package:bloc/bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final List<AppState> _stateHistory = [];

  AppBloc() : super(const AppStateStart(isLoading: false)) {
    //
    on<AppEventStartButton>(
      (event, emit) {
        _stateHistory.add(const AppStateStart(isLoading: false));
        emit(const AppStateCreatePlanOrSkip(isLoading: false));
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
        _stateHistory.add(const AppStateCreatePlanOrSkip(isLoading: false));
        emit(const AppStateChooseTrainingDays(isLoading: false));
      },
    );

    on<AppEventConfirmTrainingDays>(
      (event, emit) {
        _stateHistory.add(const AppStateChooseTrainingDays(isLoading: false));
        emit(const AppStateAddFirstWeekPlan(isLoading: false));
      },
    );
  }
}
