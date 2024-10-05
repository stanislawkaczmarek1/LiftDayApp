import 'package:flutter/material.dart';
import 'package:liftday/constants/themes.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/view/routes_views/exercise_list_view.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

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

  String selectedMuscleGroup = 'other';
  String tempSelectedGroup = 'other';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithButton(context, "Lista ćwiczeń", () {
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
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nazwa: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        exerciseName = value;
                      });
                    },
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Rodzaj: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 14),
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
                    child: Text(
                      exerciseText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorBabyBlue,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Główna grupa mięśniowa: ",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () async {
                      _showMuscleGroupDialog();
                    },
                    child: Text(
                      selectedMuscleGroup,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colorBabyBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          backgroundColor: colorBabyBlue,
          heroTag: 'addBtn',
          onPressed: () {
            if (exerciseName.isNotEmpty) {
              Navigator.of(context).pop();
              widget.onResult(
                  exerciseName, exerciseType, selectedMuscleGroup, null);
            } else {
              Navigator.of(context).pop();
            }
          },
          tooltip: 'Dodaj',
          child: const Icon(Icons.check),
        ),
      ),
    );
  }

  void _showMuscleGroupDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        tempSelectedGroup = selectedMuscleGroup;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setRadioState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ListBody(
                  children: appMuscleGroups.map((group) {
                    return RadioListTile<String>(
                      title: Text(group),
                      value: group,
                      groupValue: tempSelectedGroup,
                      onChanged: (String? value) {
                        if (value != null) {
                          setRadioState(() {
                            tempSelectedGroup = value;
                          });
                          setState(() {
                            selectedMuscleGroup = tempSelectedGroup;
                          });
                          Navigator.of(context).pop();
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
