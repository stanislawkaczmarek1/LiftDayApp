import 'package:flutter/material.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

typedef ExercisesCallback = void Function(List<String> exercisesFromTable);

class SimpleExerciseTable extends StatefulWidget {
  final ExercisesCallback callback;
  const SimpleExerciseTable({super.key, required this.callback});

  @override
  State<SimpleExerciseTable> createState() => _SimpleExerciseTableState();
}

class _SimpleExerciseTableState extends State<SimpleExerciseTable> {
  List<String> exercises = [];

  void _getExercises() {
    List<String> data = exercises;
    setState(() {
      widget.callback(data);
    });
  }

  void _addExercise(String name) {
    setState(() {
      exercises.add(name);
    });
  }

  void _showAddExerciseDialog() {
    String exerciseName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              exerciseName = value;
            },
            decoration: const InputDecoration(hintText: "Nazwa ćwiczenia"),
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Dodaj'),
              onPressed: () {
                if (exerciseName.isNotEmpty) {
                  _addExercise(exerciseName);
                  _getExercises();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            );
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: normalButton("+ Dodaj ćwiczenie", () {
              _showAddExerciseDialog();
            })),
      ],
    );
  }
}

class SimpleExerciseCard extends StatelessWidget {
  final int index;
  final String exercise;

  const SimpleExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorAccent,
          child: Text(
            '$index',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        title: Text(
          exercise,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
