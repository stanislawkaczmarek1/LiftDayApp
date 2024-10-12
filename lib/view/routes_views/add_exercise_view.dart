import 'package:flutter/material.dart';
import 'package:liftday/constants/themes.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/view/routes_views/exercise_list_view.dart';

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
  String exerciseText = 'ciężar i powtórzenia';

  String selectedMuscleGroup = 'wybierz';
  String tempSelectedGroup = 'wybierz';

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
            child: const Text(
              "Lista ćwiczeń",
              style: TextStyle(fontSize: 18.0),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dodaj ćwiczenie",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Nazwa: ",
                      style: TextStyle(fontSize: 14),
                    ),
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          exerciseName = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (exerciseType == 'reps') {
                      exerciseType = 'duration';
                      exerciseText = 'ciężar i czas';
                    } else {
                      exerciseType = 'reps';
                      exerciseText = 'ciężar i powtórzenia';
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiary,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rodzaj: ",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        exerciseText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorBabyBlue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () async {
                  _showMuscleGroupDialog("CHANGE");
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiary,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Główna grupa mięśniowa: ",
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        selectedMuscleGroup,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: colorBabyBlue,
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
          backgroundColor: colorLightGreen,
          heroTag: 'addBtn',
          onPressed: () {
            if (exerciseName.isEmpty && selectedMuscleGroup == 'wybierz') {
              showErrorDialog(context);
            } else if (exerciseName.isNotEmpty &&
                selectedMuscleGroup == 'wybierz') {
              _showMuscleGroupDialog("SAVE");
            } else if ((exerciseName.isEmpty &&
                selectedMuscleGroup != 'wybierz')) {
              showErrorDialog(context);
            } else {
              Navigator.of(context).pop();
              widget.onResult(
                  exerciseName, exerciseType, selectedMuscleGroup, null);
            }
          },
          tooltip: 'Dodaj',
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void _showMuscleGroupDialog(String whenPressed) async {
    showDialog(
      context: context,
      builder: (context) {
        tempSelectedGroup = selectedMuscleGroup;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setRadioState) {
            return AlertDialog(
              title: const Text(
                "Główna grupa mięśniowa",
                style: TextStyle(fontSize: 16),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: appMuscleGroups.map((group) {
                    return RadioListTile<String>(
                      title: Text(group),
                      value: group,
                      groupValue: tempSelectedGroup,
                      onChanged: (String? value) {
                        if (value != null) {
                          if (whenPressed == "CHANGE") {
                            setRadioState(() {
                              tempSelectedGroup = value;
                            });
                            setState(() {
                              selectedMuscleGroup = tempSelectedGroup;
                            });
                            Navigator.of(context).pop();
                          }
                          if (whenPressed == "SAVE") {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            widget.onResult(exerciseName, exerciseType,
                                selectedMuscleGroup, null);
                          }
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
