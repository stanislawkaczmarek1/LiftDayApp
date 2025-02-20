import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/sevices/bloc/config/config_state.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/view/widgets/tables/simple_exercise_table.dart';
import 'package:liftday/view/widgets/ui_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddFirstWeekPlanView extends StatefulWidget {
  const AddFirstWeekPlanView({super.key});

  @override
  State<AddFirstWeekPlanView> createState() => _AddFirstWeekPlanViewState();
}

class _AddFirstWeekPlanViewState extends State<AddFirstWeekPlanView> {
  String dayOfWeek = "";
  Key _exerciseTableKey = UniqueKey();
  late SimpleExerciseTable _exerciseTable;
  List<ExerciseData> exercises = [];

  @override
  void initState() {
    _exerciseTable = SimpleExerciseTable(
      key: _exerciseTableKey,
      callback: (List<ExerciseData> exercisesFromTable) {
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
                  callback: (List<ExerciseData> exercisesFromTable) {
                    exercises = exercisesFromTable;
                  },
                );
              });
            }
          },
          child: Scaffold(
            appBar: appBarWithButton(
              context,
              AppLocalizations.of(context)!.next,
              () {
                String day = dayOfWeek;
                context.read<ConfigBloc>().add(
                      ConfigEventConfirmExercisesInDay(
                        TrainingDayData(name: day, exercises: exercises),
                      ),
                    );
                setState(() {
                  _exerciseTableKey =
                      UniqueKey(); // Wymusza przebudowę ExerciseTable
                  _exerciseTable = SimpleExerciseTable(
                    key: _exerciseTableKey,
                    callback: (List<ExerciseData> exercisesFromTable) {
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
                      ConversionService.getPolishDayOrReturn(dayOfWeek),
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
