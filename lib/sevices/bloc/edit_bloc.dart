import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:liftday/constants/routes.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(const EditStateInit()) {
    on<EditEventPushEditIconOnPlansPage>(
      (event, emit) {
        emit(EditStateTrainingDayEdition(event.trainingDay));
        Navigator.of(event.context).pushNamed(editTrainingDayRoute);
      },
    );

    on<EditEventPushSaveButton>(
      (event, emit) async {
        final exerciseService = ExerciseService();
        await exerciseService.editTrainingDay(event.trainingDay);
        await exerciseService
            .updateTrainingDayFromTomorrowToEndOfDates(event.trainingDay);
        if (event.context.mounted) {
          Navigator.of(event.context).pop();
        }
        emit(const EditStateDayUpdated());
      },
    );

    on<EditEventEndedEdition>(
      (event, emit) {
        emit(const EditStateInit());
      },
    );

    on<EditEventPushDeletePlanButton>(
      (event, emit) async {
        final exerciseService = ExerciseService();
        await exerciseService.deleteTrainingDaysFromPlan();
        await exerciseService.deleteTrainingDayFromTomorrowToEndOfDates();
        final settingsService = SettingsService();
        settingsService.setHasPlanFlag(false);
        emit(const EditStatePlanDeleted());
      },
    );
  }
}
