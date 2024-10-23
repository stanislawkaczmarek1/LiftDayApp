import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/dialogs/reach_maxiumum_of_days.dart';
import 'package:liftday/dialogs/training_days_delete_in_config.dart';
import 'package:liftday/dialogs/wrong_name.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/sevices/bloc/config/config_state.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/view/widgets/tables/simple_exercise_table.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTrainingDaysView extends StatefulWidget {
  const AddTrainingDaysView({super.key});

  @override
  State<AddTrainingDaysView> createState() => _AddTrainingDaysViewState();
}

class _AddTrainingDaysViewState extends State<AddTrainingDaysView> {
  Key _exerciseTableKey = UniqueKey();
  late SimpleExerciseTable _exerciseTable;
  List<ExerciseData> exercises = [];
  final TextEditingController _dayController = TextEditingController();
  bool _maximumOfDays = false;

  bool _chceckDayName(String name) {
    if (name.isNotEmpty &&
        name != 'Monday' &&
        name != 'Tuesday' &&
        name != 'Wednesday' &&
        name != 'Thursday' &&
        name != 'Friday' &&
        name != 'Saturday' &&
        name != 'Sunday') {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseTable = SimpleExerciseTable(
      key: _exerciseTableKey,
      callback: (List<ExerciseData> exercisesFromTable) {
        exercises = exercisesFromTable;
      },
    );
  }

  @override
  void dispose() {
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigBloc, ConfigState>(
      listener: (context, state) {
        if (state is ConfigStateAddTrainingDays) {
          setState(() {
            _maximumOfDays = state.maximumOfDays;
          });
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          log("message");
          if (!didPop) {
            final decision =
                await showAreYouSureToGoBackInConfigDialog(context);
            if (decision && context.mounted) {
              context.read<ConfigBloc>().add(const ConfigEventGoBack());
              setState(() {
                _dayController.clear();
                exercises = [];
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
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Theme.of(context).brightness == Brightness.dark
                ? Image.asset('assets/liftday_logo_dark.png', height: 25.0)
                : Image.asset('assets/liftday_logo.png', height: 25.0),
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            actions: [
              TextButton(
                onPressed: () {
                  final dayName = _dayController.text.trimRight();
                  if (_chceckDayName(dayName)) {
                    context.read<ConfigBloc>().add(ConfigEventPushDoneButton(
                        TrainingDayData(
                            name: dayName,
                            exercises: exercises,
                            isFromPlan: 0)));
                  } else {
                    showWrongNameDialog(context);
                  }
                },
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary),
                child: Text(
                  AppLocalizations.of(context)!.finish,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
              if (!_maximumOfDays)
                TextButton(
                  onPressed: () {
                    final dayName = _dayController.text.trimRight();
                    if (_chceckDayName(dayName)) {
                      context.read<ConfigBloc>().add(
                          ConfigEventPushNextDayButton(TrainingDayData(
                              name: dayName,
                              exercises: exercises,
                              isFromPlan: 0)));
                      setState(() {
                        _exerciseTableKey =
                            UniqueKey(); // Wymusza przebudowę ExerciseTable
                        _exerciseTable = SimpleExerciseTable(
                          key: _exerciseTableKey,
                          callback: (List<ExerciseData> exercisesFromTable) {
                            exercises = exercisesFromTable;
                          },
                        );
                        exercises = [];
                        _dayController.clear();
                      });
                    } else {
                      showWrongNameDialog(context);
                    }
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                  child: Text(
                    AppLocalizations.of(context)!.next_day,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                )
              else
                IconButton(
                    onPressed: () {
                      showReachMaxiumumOfRoutinesDialog(context);
                    },
                    icon: const Icon(
                      Icons.info,
                      size: 20,
                    ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    maxLength: 30,
                    buildCounter: (BuildContext context,
                        {int? currentLength, bool? isFocused, int? maxLength}) {
                      return null;
                    },
                    controller: _dayController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        hintText: AppLocalizations.of(context)!.enter_day_name2,
                        hintStyle: const TextStyle(fontSize: 24)),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                _exerciseTable,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
