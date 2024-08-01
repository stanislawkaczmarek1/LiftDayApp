import 'package:flutter/material.dart';
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
  //def
  List<ExerciseCard> exercises = [];

  @override
  void initState() {
    super.initState();
    _addSetRow();
  }

  void _addSetRow() {
    setState(() {
      /*sets.add(ExerciseRow(
        setNumber: setNumber++,
        previousValue: 50,
      ));*/
    });
  }

  void _addExercise(String name) {
    setState(() {
      exercises.add(ExerciseCard(exercise: name));
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return exercises[index];
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _showAddExerciseDialog,
                  child: const Text("Dodaj Ćwiczenie"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final String exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  List<ExerciseRow> sets = [];
  int setNumber = 1;

  @override
  void initState() {
    super.initState();
    sets.add(ExerciseRow(setNumber: setNumber));
  }

  void _addSet() {
    setState(() {
      sets.add(ExerciseRow(setNumber: ++setNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Set', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('kg', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Reps', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8.0),
            ...sets, // Rozpakowanie listy sets do widoku
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _addSet,
                child: const Text("Add Set"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseRow extends StatefulWidget {
  final int setNumber;
  const ExerciseRow({super.key, required this.setNumber});

  @override
  State<ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends State<ExerciseRow> {
  late final TextEditingController _kgController;
  late final TextEditingController _repsController;
  late final int setNumber;

  @override
  void initState() {
    _kgController = TextEditingController();
    _repsController = TextEditingController();
    setNumber = widget.setNumber;
    super.initState();
  }

  @override
  void dispose() {
    _kgController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$setNumber'),
          SizedBox(
            width: 50,
            child: TextField(
              controller: _kgController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(
            width: 50,
            child: TextField(
              controller: _repsController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }
}
