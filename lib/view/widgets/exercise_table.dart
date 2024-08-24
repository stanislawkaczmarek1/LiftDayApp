import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/ui_constants/colors.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class ExerciseTable extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseTable({super.key, required this.selectedDate});

  @override
  State<ExerciseTable> createState() => _ExerciseTableState();
}

class _ExerciseTableState extends State<ExerciseTable> {
  late final ExerciseService _exerciseService;
  late Future<List<ExerciseCard>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exerciseService = ExerciseService();
    _updateExercises();
  }

  Future<List<ExerciseCard>> _loadExercisesForSelectedDate() async {
    final date = await _exerciseService.getDateByDigitDate(
        digitDate: DateFormat('dd-MM-yyyy').format(widget.selectedDate));
    if (date != null) {
      final exercisesList =
          await _exerciseService.getExercisesForDate(dateId: date.id);
      return exercisesList
          .map((exercise) => ExerciseCard(exercise: exercise.name))
          .toList();
    } else {
      return [];
    }
  }

  void _addExercise(String name) async {
    final digitDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);
    final date =
        await _exerciseService.getDateByDigitDate(digitDate: digitDate);

    if (date != null) {
      await _exerciseService.createExercise(date: date, name: name);
      _updateExercises();
    } else {
      if (mounted) {
        showErrorDialog(context);
      }
    }
  }

  void _updateExercises() {
    setState(() {
      _exercisesFuture = _loadExercisesForSelectedDate();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        FutureBuilder<List<ExerciseCard>>(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final exercises = snapshot.data!;
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        return exercises[index];
                      });
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            }),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: normalButton("+ Dodaj ćwiczenie", () {
            _showAddExerciseDialog();
          }),
        ),
      ],
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
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 15),
                Text(
                  widget.exercise,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text('seria',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('kg',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('x',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...sets, // Rozpakowanie listy sets do widoku
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _addSet,
                  style: TextButton.styleFrom(
                    elevation: 3.0,
                    backgroundColor: colorPrimaryButton,
                    foregroundColor: colorSecondaryButton,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "+ Dodaj serię",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                )),
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
  late final FocusNode _kgFocusNode;
  late final FocusNode _repsFocusNode;
  late final int setNumber;

  @override
  void initState() {
    super.initState();
    _kgController = TextEditingController();
    _repsController = TextEditingController();
    _kgFocusNode = FocusNode();
    _repsFocusNode = FocusNode();
    setNumber = widget.setNumber;
  }

  @override
  void dispose() {
    _kgController.dispose();
    _repsController.dispose();
    _kgFocusNode.dispose();
    _repsFocusNode.dispose();
    super.dispose();
  }

  void _onRepsSubmitted() {
    //to do
  }

  void _onKgSubmitted() {
    FocusScope.of(context).requestFocus(_repsFocusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '$setNumber',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _kgController,
              focusNode: _kgFocusNode,
              decoration: const InputDecoration(
                hintText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: colorAccent),
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                _onKgSubmitted();
              },
            ),
          ),
          Expanded(
            child: TextField(
              controller: _repsController,
              focusNode: _repsFocusNode,
              decoration: const InputDecoration(
                hintText: '',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2, color: colorAccent),
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                _onRepsSubmitted();
              },
            ),
          ),
        ],
      ),
    );
  }
}
