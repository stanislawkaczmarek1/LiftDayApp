import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/app_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/view/ui_elements.dart';

class AddFirstWeekPlanView extends StatefulWidget {
  const AddFirstWeekPlanView({super.key});

  @override
  State<AddFirstWeekPlanView> createState() => _AddFirstWeekPlanViewState();
}

class _AddFirstWeekPlanViewState extends State<AddFirstWeekPlanView> {
  List<Exercise> exercises = [];

  void _addExercise(String name) {
    setState(() {
      exercises.add(Exercise(name));
    });
  }

  void _showAddExerciseDialog() {
    String exerciseName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Dodaj Ćwiczenie'),
          content: TextField(
            onChanged: (value) {
              exerciseName = value;
            },
            decoration: InputDecoration(hintText: "Nazwa ćwiczenia"),
          ),
          actions: [
            TextButton(
              child: Text('Anuluj'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Dodaj'),
              onPressed: () {
                if (exerciseName.isNotEmpty) {
                  _addExercise(exerciseName);
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<AppBloc>().add(const AppEventGoBack());
        }
      },
      child: Scaffold(
        appBar: appBar(),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseTile(exercise: exercises[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: normalButton("Dodaj Ćwiczenie", _showAddExerciseDialog),
            ),
          ],
        ),
      ),
    );
  }
}

class Exercise {
  final String name;
  final TextEditingController field1 = TextEditingController();
  final TextEditingController field2 = TextEditingController();
  final TextEditingController field3 = TextEditingController();
  final TextEditingController field4 = TextEditingController();

  Exercise(this.name);
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: exercise.field1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pole 1',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: exercise.field2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pole 2',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: exercise.field3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pole 3',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: exercise.field4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Pole 4',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
