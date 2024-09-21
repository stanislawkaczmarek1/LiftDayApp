import 'package:flutter/material.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

typedef ExercisesCallback = void Function(List<String> exercisesFromTable);

class SimpleExerciseTable extends StatefulWidget {
  final List<String>? exercises;
  final ExercisesCallback callback;
  const SimpleExerciseTable(
      {super.key, required this.callback, this.exercises});

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

  bool _addExercise(String name) {
    bool added = false;
    if (exercises.length >= 10) {
      added = false;
      return added;
    }
    setState(() {
      if (exercises.contains(name)) {
        added = false;
      } else {
        exercises.add(name);
        added = true;
      }
    });
    return added;
  }

  void _editExercise(int index, String newName) {
    setState(() {
      exercises[index] = newName;
      _getExercises();
    });
  }

  void _removeExercise(int index) {
    setState(() {
      exercises.removeAt(index);
      _getExercises();
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
                  if (_addExercise(exerciseName)) {
                    _getExercises();
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                    showErrorDialog(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditExerciseDialog(int index) {
    String updatedExerciseName = exercises[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              updatedExerciseName = value;
            },
            decoration: const InputDecoration(hintText: "Edytuj ćwiczenie"),
            controller: TextEditingController(text: exercises[index]),
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Zapisz'),
              onPressed: () {
                if (updatedExerciseName.isNotEmpty) {
                  _editExercise(index, updatedExerciseName);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
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
              onEdit: () => _showEditExerciseDialog(index),
              onDelete: () => _removeExercise(index),
            );
          },
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: normalButton(context, "+ Dodaj ćwiczenie", () {
              _showAddExerciseDialog();
            })),
      ],
    );
  }
}

class SimpleExerciseCard extends StatelessWidget {
  final int index;
  final String exercise;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SimpleExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
    required this.onEdit,
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
          exercise,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edytuj'),
            ),
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
