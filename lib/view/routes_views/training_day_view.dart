import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/sevices/bloc/edit/edit_bloc.dart';
import 'package:liftday/sevices/bloc/edit/edit_event.dart';
import 'package:liftday/sevices/bloc/edit/edit_state.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/view/widgets/tables/simple_exercise_table.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class TrainingDayView extends StatefulWidget {
  const TrainingDayView({super.key});

  @override
  State<TrainingDayView> createState() => _TrainingDayViewState();
}

class _TrainingDayViewState extends State<TrainingDayView> {
  List<ExerciseData> exercises = [];
  final TextEditingController _dayController = TextEditingController();
  late ExerciseService _exerciseService;
  String _currentName = "";

  Future<bool> _chceckDayName(String name) async {
    if (name.isNotEmpty &&
        name != 'Monday' &&
        name != 'Tuesday' &&
        name != 'Wednesday' &&
        name != 'Thursday' &&
        name != 'Friday' &&
        name != 'Saturday' &&
        name != 'Sunday') {
      final otherDays = await _exerciseService.getTrainingDaysNotFromPlanData();
      for (var i = 0; i < otherDays.length; i++) {
        if (otherDays.elementAt(i).name == name && _currentName != name) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  String _getPolishDayAbbreviation(String dayOfWeek) {
    switch (dayOfWeek) {
      case 'Monday':
        return 'Poniedziałek';
      case 'Tuesday':
        return 'Wtorek';
      case 'Wednesday':
        return 'Środa';
      case 'Thursday':
        return 'Czwartek';
      case 'Friday':
        return 'Piątek';
      case 'Saturday':
        return 'Sobota';
      case 'Sunday':
        return 'Niedziela';
      default:
        return dayOfWeek;
    }
  }

  @override
  void initState() {
    _exerciseService = ExerciseService();
    super.initState();
  }

  @override
  void dispose() {
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditBloc, EditState>(
      builder: (context, state) {
        if (state is EditStateEditTrainingDayFromPlan) {
          if (exercises.isEmpty) {
            exercises = List.from(state.trainingDay.exercises);
          }
          return Scaffold(
            appBar: appBarWithButton(
              context,
              "Zapisz",
              () {
                context.read<EditBloc>().add(EditEventPushSaveButton(
                    context,
                    TrainingDayData(
                      name: state.trainingDay.name,
                      exercises: exercises,
                    ),
                    state.trainingDay.name));
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _getPolishDayAbbreviation(state.trainingDay.name),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SimpleExerciseTable(
                    exercises: state.trainingDay.exercises,
                    callback: (List<ExerciseData> exercisesFromTable) {
                      exercises = exercisesFromTable;
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is EditStateEditOtherTrainingDay) {
          _dayController.text = state.trainingDay.name;
          _currentName = state.trainingDay.name;
          if (exercises.isEmpty) {
            exercises = List.from(state.trainingDay.exercises);
          }
          return Scaffold(
            appBar: appBarWithButton(
              context,
              "Zapisz",
              () async {
                if (await _chceckDayName(_dayController.text)) {
                  if (context.mounted) {
                    context.read<EditBloc>().add(EditEventPushSaveButton(
                        context,
                        TrainingDayData(
                          name: _dayController.text,
                          exercises: exercises,
                        ),
                        _currentName));
                  }
                } else {
                  if (context.mounted) {
                    showErrorDialog(context);
                  }
                }
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _dayController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          hintText: 'Wpisz nazwę dnia',
                          hintStyle: const TextStyle(fontSize: 24)),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SimpleExerciseTable(
                    exercises: state.trainingDay.exercises,
                    callback: (List<ExerciseData> exercisesFromTable) {
                      exercises = exercisesFromTable;
                    },
                  ),
                ],
              ),
            ),
          );
        } else if (state is EditStateAddOtherTrainingDay) {
          return Scaffold(
            appBar: appBarWithButton(
              context,
              "Zapisz",
              () async {
                if (await _chceckDayName(_dayController.text)) {
                  if (context.mounted) {
                    context.read<EditBloc>().add(EditEventPushSaveButton(
                        context,
                        TrainingDayData(
                          name: _dayController.text,
                          exercises: exercises,
                        ),
                        " "));
                  }
                } else {
                  if (context.mounted) {
                    showErrorDialog(context);
                  }
                }
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: _dayController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          hintText: 'Wpisz nazwę dnia',
                          hintStyle: const TextStyle(fontSize: 24)),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SimpleExerciseTable(
                    exercises: exercises,
                    callback: (List<ExerciseData> exercisesFromTable) {
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
