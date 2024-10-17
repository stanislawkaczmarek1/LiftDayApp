import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:liftday/constants/app_exercises.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/view/routes_views/add_exercise_view.dart';

typedef ExercisesCallback = void Function(
    List<ExerciseData> exercisesFromTable);

class SimpleExerciseTable extends StatefulWidget {
  final List<ExerciseData>? exercises;
  final ExercisesCallback callback;
  const SimpleExerciseTable(
      {super.key, required this.callback, this.exercises});

  @override
  State<SimpleExerciseTable> createState() => _SimpleExerciseTableState();
}

class _SimpleExerciseTableState extends State<SimpleExerciseTable> {
  List<ExerciseData> exercises = [];

  void _getExercises() {
    List<ExerciseData> data = exercises;
    setState(() {
      widget.callback(data);
    });
  }

  void _addExercise(ExerciseData exerciseData) {
    setState(() {
      exercises.add(exerciseData);
      log("added: $exerciseData");
      _getExercises();
    });
  }

  void _removeExercise(int index) {
    setState(() {
      exercises.removeAt(index);
      _getExercises();
    });
  }

  void _showAddExerciseView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddExerciseView(
          onResult: (name, type, muscleGroup, exerciseInfoId) {
            _addExercise(ExerciseData(
                name: name,
                type: type,
                muscleGroup: muscleGroup,
                infoId: exerciseInfoId));
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    exercises = widget.exercises ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return SimpleExerciseCard(
              index: index + 1,
              exercise: exercises[index],
              onDelete: () => _removeExercise(index),
            );
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              if (exercises.length >= 10) {
                return;
              }
              _showAddExerciseView();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
              child: Center(
                child: Text(
                  "+ Dodaj ćwiczenie",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SimpleExerciseCard extends StatelessWidget {
  final int index;
  final ExerciseData exercise;
  final VoidCallback onDelete;

  const SimpleExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String appExerciseName = "";
    if (exercise.name == null && exercise.infoId != null) {
      DatabaseExerciseInfo? appExerciseInfo =
          getAppExerciseById(exercise.infoId!);
      if (appExerciseInfo != null) {
        appExerciseName = appExerciseInfo.name;
      }
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Text(
            '$index',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        title: Text(
          exercise.name ??
              appExerciseName
                  .toString(), //bedzie trzeba pobrac nazwe i typ jesli cwicznie bedzie z listy
          style: const TextStyle(fontSize: 18),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Usuń'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
