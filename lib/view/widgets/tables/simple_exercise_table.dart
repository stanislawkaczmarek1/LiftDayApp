import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/view/routes_views/add_exercise_view.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

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
            child: normalButton(
              "+ Dodaj ćwiczenie",
              () {
                if (exercises.length >= 10) {
                  return;
                }
                _showAddExerciseView();
              },
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.primary,
            )),
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
              exercise.infoId
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
              child: Text('Usuń'),
            ),
          ],
        ),
      ),
    );
  }
}
