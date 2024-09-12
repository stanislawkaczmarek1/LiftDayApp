import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:liftday/constants/routes.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(const EditStateInit()) {
    on<EditEventPushEditIconOnPlansPage>(
      (event, emit) async {
        emit(EditStateTrainingDayEdition(event.trainingDay));
        Navigator.of(event.context).pushNamed(editTrainingDayRoute);
      },
    );
  }
}
