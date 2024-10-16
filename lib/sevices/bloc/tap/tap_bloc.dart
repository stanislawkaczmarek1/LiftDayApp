import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:liftday/sevices/bloc/abstract/app_event.dart';
import 'package:liftday/sevices/bloc/abstract/app_state.dart';

@immutable
abstract class TapEvent extends AppEvent {
  const TapEvent();
}

class Tap extends TapEvent {
  const Tap();
}

class SetTappedDefault extends TapEvent {
  const SetTappedDefault();
}

@immutable
abstract class TapState extends AppState {
  const TapState();
}

class Tapped extends TapState {
  const Tapped();
}

class NoTapped extends TapState {
  const NoTapped();
}

class TapBloc extends Bloc<TapEvent, TapState> {
  TapBloc() : super(const NoTapped()) {
    on<Tap>((event, emit) {
      emit(
          const Tapped()); //potencjalnie duza strata wydajnosci (emisja stanu przy kazdym klinknieciu)
    });

    on<SetTappedDefault>((event, emit) {
      emit(const NoTapped());
    });
  }
}
