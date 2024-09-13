import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/bloc/edit_bloc.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/view/widgets/simple_exercise_table.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class EditTrainingDaysView extends StatefulWidget {
  const EditTrainingDaysView({super.key});

  @override
  State<EditTrainingDaysView> createState() => _EditTrainingDaysViewState();
}

class _EditTrainingDaysViewState extends State<EditTrainingDaysView> {
  List<String> exercises = [];

  String _getPolishDayAbbreviation(String dayOfWeek) {
    switch (dayOfWeek) {
      case 'Monday':
        return 'Pon';
      case 'Tuesday':
        return 'Wt';
      case 'Wednesday':
        return 'Śr';
      case 'Thursday':
        return 'Czw';
      case 'Friday':
        return 'Pt';
      case 'Saturday':
        return 'Sob';
      case 'Sunday':
        return 'Ndz';
      default:
        return dayOfWeek;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBloc, EditState>(
      builder: (context, state) {
        if (state is EditStateTrainingDayEdition) {
          return Scaffold(
            appBar: appBarWithButton(
              "Zapisz",
              () {
                context.read<EditBloc>().add(EditEventPushSaveButton(
                    context,
                    TrainingDay(
                      day: state.trainingDay.day,
                      exercises: exercises,
                    )));
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Trening w ${_getPolishDayAbbreviation(state.trainingDay.day)}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SimpleExerciseTable(
                    exercises: state.trainingDay.exercises,
                    callback: (List<String> exercisesFromTable) {
                      exercises = exercisesFromTable;
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
