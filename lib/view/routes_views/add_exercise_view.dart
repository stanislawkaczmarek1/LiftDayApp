import 'package:flutter/material.dart';
import 'package:liftday/dialogs/entry_exerciese_name.dart';
import 'package:liftday/dialogs/entry_exercise_musle.dart';
import 'package:liftday/dialogs/entry_exercise_name_and_muscle.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/view/routes_views/exercise_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef AddExerciseViewCallback = void Function(
    String? name, String? type, String? muscleGroup, int? exerciseInfoId);

class AddExerciseView extends StatefulWidget {
  final AddExerciseViewCallback onResult;

  const AddExerciseView({super.key, required this.onResult});

  @override
  State<AddExerciseView> createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends State<AddExerciseView> {
  String exerciseName = '';
  String exerciseType = 'reps';
  String selectedMuscleGroup = 'empty';
  String exerciseTypeText = 'empty';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExerciseListView(
                    onResult: (exerciseInfoId) {
                      Navigator.of(context).pop();
                      widget.onResult(null, null, null, exerciseInfoId);
                    },
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.secondary),
            child: Text(
              AppLocalizations.of(context)!.exercise_list,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.enter_name,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8)),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        maxLength: 150,
                        buildCounter: (BuildContext context,
                            {int? currentLength,
                            bool? isFocused,
                            int? maxLength}) {
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            exerciseName = value.trimRight();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.5,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.2)),
                          ),
                        ),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (exerciseType == 'reps') {
                      exerciseType = 'duration';
                      exerciseTypeText =
                          AppLocalizations.of(context)!.weight_and_time;
                    } else {
                      exerciseType = 'reps';
                      exerciseTypeText = exerciseTypeText =
                          AppLocalizations.of(context)!.weight_and_reps;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2)),
                  ),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.select_type,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8)),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        exerciseTypeText == "empty"
                            ? AppLocalizations.of(context)!.weight_and_reps
                            : exerciseTypeText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  _showMuscleGroupBottomSheet();
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2))),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.select_muscle_group,
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8)),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        selectedMuscleGroup != "empty"
                            ? ConversionService.getPolishMuscleNameOrReturn(
                                selectedMuscleGroup)
                            : AppLocalizations.of(context)!.select,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          heroTag: 'addBtn',
          onPressed: () {
            if (exerciseName.isEmpty && selectedMuscleGroup == 'empty') {
              showEntryExerciseNameAndMuscleDialog(context);
            } else if (exerciseName.isNotEmpty &&
                selectedMuscleGroup == 'empty') {
              showEntryExerciseMuscleDialog(context);
            } else if ((exerciseName.isEmpty &&
                selectedMuscleGroup != 'empty')) {
              showEntryExerciseNameDialog(context);
            } else {
              Navigator.of(context).pop();
              widget.onResult(
                  exerciseName, exerciseType, selectedMuscleGroup, null);
            }
          },
          tooltip: AppLocalizations.of(context)!.add,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void _showMuscleGroupBottomSheet() async {
    String tempSelectedGroup;
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      context: context,
      builder: (BuildContext context) {
        tempSelectedGroup = selectedMuscleGroup;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.main_muscle_group,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize
                          .min, // Zapobiega rozciąganiu na całą wysokość ekranu
                      children: appMuscleGroups.map((group) {
                        return GestureDetector(
                          onTap: () {
                            setSheetState(() {
                              tempSelectedGroup = group;
                            });
                            setState(() {
                              selectedMuscleGroup = tempSelectedGroup;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: tempSelectedGroup == group
                                  ? Theme.of(context).colorScheme.onTertiary
                                  : Theme.of(context).colorScheme.onTertiary,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: tempSelectedGroup == group
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.onTertiary,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ConversionService.getPolishMuscleNameOrReturn(
                                      group),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (tempSelectedGroup == group)
                                  Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
