import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:liftday/constants/routes.dart';
import 'package:liftday/sevices/bloc/edit/edit_event.dart';
import 'package:liftday/sevices/bloc/edit/edit_state.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  bool _isThatEddition = true;

  EditBloc() : super(const EditStateInit()) {
    on<EditEventEditTrainingDayFromPlan>(
      (event, emit) {
        _isThatEddition = true;
        emit(EditStateEditTrainingDayFromPlan(event.trainingDay));
        Navigator.of(event.context).pushNamed(editTrainingDayRoute);
      },
    );

    on<EditEventEditOtherTrainingDay>(
      (event, emit) {
        _isThatEddition = true;
        emit(EditStateEditOtherTrainingDay(event.trainingDay));
        Navigator.of(event.context).pushNamed(editTrainingDayRoute);
      },
    );

    on<EditEventAddOtherTrainingDay>(
      (event, emit) {
        _isThatEddition = false; //addition
        emit(const EditStateAddOtherTrainingDay());
        Navigator.of(event.context).pushNamed(editTrainingDayRoute);
      },
    );

    on<EditEventPushSaveButton>(
      (event, emit) async {
        final exerciseService = ExerciseService();
        if (_isThatEddition) {
          await exerciseService.editTrainingDay(
              event.trainingDay, event.currentName);
          await exerciseService
              .updateTrainingDayFromTomorrowToEndOfDates(event.trainingDay);
        } else {
          //addition of other days
          await exerciseService.saveTrainingDay(event.trainingDay, false);
        }
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
        await exerciseService.deleteExercisesAndSetsFromTomorrowToEndOfDates();
        final settingsService = SettingsService();
        settingsService.setHasPlanFlag(false);
        emit(const EditStatePlanDeleted());
      },
    );

    on<EditEventDeleteTrainingDay>(
      (event, emit) async {
        final exerciseService = ExerciseService();
        await exerciseService.deleteTrainingDay(event.trainingDay);
        emit(const EditStateDayDeleted());
      },
    );
  }
}
