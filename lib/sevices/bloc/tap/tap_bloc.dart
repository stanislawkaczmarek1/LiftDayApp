import 'package:bloc/bloc.dart';

abstract class TapEvent {}

class Tap extends TapEvent {
  Tap();
}

class SetTappedDefault extends TapEvent {
  SetTappedDefault();
}

abstract class TapState {
  TapState();
}

class Tapped extends TapState {
  Tapped();
}

class NoTapped extends TapState {
  NoTapped();
}

class TapBloc extends Bloc<TapEvent, TapState> {
  TapBloc() : super(NoTapped()) {
    on<Tap>((event, emit) {
      emit(
          Tapped()); //potencjalnie duza strata wydajnosci (emisja stanu przy kazdym klinknieciu)
    });

    on<SetTappedDefault>((event, emit) {
      emit(NoTapped());
    });
  }
}
