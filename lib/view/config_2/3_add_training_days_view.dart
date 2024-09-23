import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/dialogs/training_days_delete_in_config.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_state.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/bloc/config_bloc.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/view/widgets/simple_exercise_table.dart';

class AddTrainingDaysView extends StatefulWidget {
  const AddTrainingDaysView({super.key});

  @override
  State<AddTrainingDaysView> createState() => _AddTrainingDaysViewState();
}

class _AddTrainingDaysViewState extends State<AddTrainingDaysView> {
  Key _exerciseTableKey = UniqueKey();
  late SimpleExerciseTable _exerciseTable;
  List<String> exercises = [];
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
    _exerciseTable = SimpleExerciseTable(
      key: _exerciseTableKey,
      callback: (List<String> exercisesFromTable) {
        exercises = exercisesFromTable;
      },
    );
    super.initState();
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
          if (!didPop) {
            final decision = await showAreYouSureToGoBackInConfig(context);
            if (decision && context.mounted) {
              context.read<ConfigBloc>().add(const ConfigEventGoBack());
              setState(() {
                _dayController.clear();
                exercises = [];
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
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<AppBarBloc, AppBarState>(
              builder: (context, state) {
                return state.title;
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            actions: [
              TextButton(
                onPressed: () {
                  if (_chceckDayName(_dayController.text)) {
                    context.read<ConfigBloc>().add(ConfigEventPushDoneButton(
                        TrainingDay(
                            day: _dayController.text,
                            exercises: exercises,
                            isFromPlan: 0)));
                  } else {
                    showErrorDialog(context);
                  }
                },
                style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary),
                child: const Text(
                  "Zakończ",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              if (!_maximumOfDays)
                TextButton(
                  onPressed: () {
                    if (_chceckDayName(_dayController.text)) {
                      context.read<ConfigBloc>().add(
                          ConfigEventPushNextDayButton(TrainingDay(
                              day: _dayController.text,
                              exercises: exercises,
                              isFromPlan: 0)));
                      setState(() {
                        _exerciseTableKey =
                            UniqueKey(); // Wymusza przebudowę ExerciseTable
                        _exerciseTable = SimpleExerciseTable(
                          key: _exerciseTableKey,
                          callback: (List<String> exercisesFromTable) {
                            exercises = exercisesFromTable;
                          },
                        );
                        exercises = [];
                        _dayController.clear();
                      });
                    } else {
                      showErrorDialog(context);
                    }
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary),
                  child: const Text(
                    "Kolejny dzień",
                    style: TextStyle(fontSize: 14.0),
                  ),
                )
              else
                IconButton(
                    onPressed: () {
                      showErrorDialog(context);
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
                _exerciseTable,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
