import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/view/widgets/simple_exercise_table.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class AddFirstWeekPlanView extends StatefulWidget {
  const AddFirstWeekPlanView({super.key});

  @override
  State<AddFirstWeekPlanView> createState() => _AddFirstWeekPlanViewState();
}

class _AddFirstWeekPlanViewState extends State<AddFirstWeekPlanView> {
  String dayOfWeek = "";
  Key _exerciseTableKey = UniqueKey();
  late SimpleExerciseTable _exerciseTable;
  List<String> exercises = [];

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
    _exerciseTable = SimpleExerciseTable(
      key: _exerciseTableKey,
      callback: (List<String> exercisesFromTable) {
        exercises = exercisesFromTable;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        if (state is ConfigStateAddFirstWeekPlan) {
          dayOfWeek = state.dayOfWeek;
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              context.read<ConfigBloc>().add(const ConfigEventGoBack());
              exercises = [];
              setState(() {
                _exerciseTableKey =
                    UniqueKey(); // Wymusza przebudowę ExerciseTable
                _exerciseTable = SimpleExerciseTable(
                  key: _exerciseTableKey,
                  callback: (List<String> exercisesFromTable) {
                    exercises = exercisesFromTable;
                  },
                );
              });
            }
          },
          child: Scaffold(
            appBar: appBarWithButton(
              context,
              "Dalej",
              () {
                String day = dayOfWeek;
                context.read<ConfigBloc>().add(
                      ConfigEventConfirmExercisesInDay(
                        TrainingDay(day: day, exercises: exercises),
                      ),
                    );
                setState(() {
                  _exerciseTableKey =
                      UniqueKey(); // Wymusza przebudowę ExerciseTable
                  _exerciseTable = SimpleExerciseTable(
                    key: _exerciseTableKey,
                    callback: (List<String> exercisesFromTable) {
                      exercises = exercisesFromTable;
                    },
                  );
                });
                exercises = [];
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _getPolishDayAbbreviation(dayOfWeek),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _exerciseTable,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
