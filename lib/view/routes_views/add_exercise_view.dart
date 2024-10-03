import 'package:flutter/material.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

typedef AddExerciseViewCallback = void Function(
    String? name, String? type, int? exerciseInfoId);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Nazwa: ",
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  exerciseName = value;
                });
              },
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  "Rodzaj: ",
                  style: TextStyle(fontSize: 16),
                ),
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
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                  Navigator.of(context).pop();
                  widget.onResult(exerciseName, exerciseType, null);
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
