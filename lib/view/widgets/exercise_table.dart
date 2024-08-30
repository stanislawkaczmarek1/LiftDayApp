import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables_classes/database_date.dart';
import 'package:liftday/sevices/crud/tables_classes/database_exercise.dart';
import 'package:liftday/sevices/crud/tables_classes/database_set.dart';
import 'package:liftday/ui_constants/colors.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class ExerciseTable extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseTable({super.key, required this.selectedDate});

  @override
  State<ExerciseTable> createState() => _ExerciseTableState();
}

class _ExerciseTableState extends State<ExerciseTable> {
  late DatabaseDate? _date;
  late final ExerciseService _exerciseService;
  late Future<List<ExerciseCard>> _exercisesFuture;
  bool _isLoaded = false;

  void _addExercise(String name) async {
    if (_date != null) {
      await _exerciseService.createExercise(dateId: _date!.id, name: name);
      _updateExercises();
    } else {
      if (mounted) {
        //w razie gdy jestesmy na polu kalendarza do ktorego nie ma daty w bazie danych
        showErrorDialog(context);
      }
    }
  }

  void _updateExercises() async {
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

  Future<List<ExerciseCard>> _loadExercisesForSelectedDate() async {
    final digitDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);
    _date = await _exerciseService.getDateByDigitDate(digitDate: digitDate);

    if (_date != null) {
      final exercisesList =
          await _exerciseService.getExercisesForDate(dateId: _date!.id);
      return exercisesList
          .map((exercise) => ExerciseCard(
                exerciseName: exercise.name,
                selectedDate: _date!,
              ))
          .toList();
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseService = ExerciseService();
    _updateExercises();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExerciseCard>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (snapshot.hasData && snapshot.data != null) {
                final exercises = snapshot.data!;
                return AnimatedOpacity(
                  opacity: _isLoaded ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Builder(
                        builder: (context) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!_isLoaded) {
                              setState(() {
                                _isLoaded = true;
                              });
                            }
                          });
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exercises.length,
                            itemBuilder: (context, index) {
                              return exercises[index];
                            },
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: normalButton("+ Dodaj ćwiczenie", () {
                          _showAddExerciseDialog();
                        }),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox(height: 0);
              }
            default:
              return const SizedBox(height: 0);
          }
        });
  }
}

//exercise card moze byc stworzony tylko gdy dane cwiczenie istnieje w dany dzien (patrz metoda _loadExercisesForSelectedDays)
class ExerciseCard extends StatefulWidget {
  final DatabaseDate selectedDate;
  final String exerciseName;

  const ExerciseCard({
    super.key,
    required this.selectedDate,
    required this.exerciseName,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late int _setNumber;
  late Future<List<ExerciseRow>> _setsFuture;
  late final ExerciseService _exerciseService;
  late DatabaseExercise? _exercise;

  late bool _isLoaded;

  void _addSet(int setIndex) async {
    if (_exercise != null) {
      await _exerciseService.createSet(
        exerciseId: _exercise!.id,
        setIndex: setIndex,
        weight: 0,
        reps: 0,
      );
      log("created set with index $setIndex");

      _updateSets();
    } else {
      if (mounted) {
        showErrorDialog(context);
      }
    }
  }

  void _updateSets() async {
    setState(() {
      _setsFuture = _loadSetsForExercise();
    });
  }

  void _checkAndDeleteEmptySets() async {
    DatabaseExercise? exercise =
        await _exerciseService.getExerciseByDateAndName(
            dateId: widget.selectedDate.id, name: widget.exerciseName);
    _exercise = exercise;
    if (_exercise != null) {
      final sets =
          await _exerciseService.getSetsForExercise(exerciseId: _exercise!.id);
      sets.sort((a, b) => a.setIndex.compareTo(b.setIndex));
      for (var oneSet in sets) {
        final weight = oneSet.weight;
        final reps = oneSet.reps;
        if (weight == 0 && reps == 0) {
          log("Prep to deleted set with index: ${oneSet.setIndex}");
          await _exerciseService.deleteSet(id: oneSet.id);
          log("delated");
        }
      }
    }
  }

  Future<List<ExerciseRow>> _loadSetsForExercise() async {
    DatabaseExercise? exercise =
        await _exerciseService.getExerciseByDateAndName(
            dateId: widget.selectedDate.id, name: widget.exerciseName);
    _exercise = exercise;
    if (_exercise != null) {
      final sets =
          await _exerciseService.getSetsForExercise(exerciseId: _exercise!.id);
      sets.sort((a, b) => a.setIndex.compareTo(b.setIndex));
      if (sets.isEmpty) {
        _setNumber = 1;
      } else {
        _setNumber = sets.last.setIndex;
      }
      return sets
          .map((dbSet) => ExerciseRow(
                exercise: _exercise!,
                setIndex: dbSet.setIndex,
              ))
          .toList();
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoaded = false;
    _exerciseService = ExerciseService();
    _updateSets();
  }

  @override
  void dispose() {
    log("dispose card");
    _checkAndDeleteEmptySets();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExerciseRow>>(
      future: _setsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            final sets = snapshot.data!;
            if (_exercise != null) {
              if (sets.isEmpty) {
                _addSet(_setNumber);
              }
            } else {
              if (mounted) {
                showErrorDialog(context);
              }
            }
            return AnimatedOpacity(
              opacity: _isLoaded ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _buildExerciseCard(sets),
            );
          } else {
            return const SizedBox(height: 0);
          }
        } else {
          return const SizedBox(height: 0);
        }
      },
    );
  }

  Widget _buildExerciseCard(List<ExerciseRow> sets) {
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
                  widget.exerciseName,
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
                    child: Text('Seria',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('kg',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('x',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Builder(
              builder: (context) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!_isLoaded) {
                    setState(() {
                      _isLoaded = true;
                    });
                  }
                });
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    return sets[index];
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () => _addSet(++_setNumber),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseRow extends StatefulWidget {
  final DatabaseExercise exercise;
  final int setIndex;
  const ExerciseRow({
    super.key,
    required this.exercise,
    required this.setIndex,
  });

  @override
  State<ExerciseRow> createState() => _ExerciseRowState();
}

class _ExerciseRowState extends State<ExerciseRow> {
  late final TextEditingController _weightController;
  late final TextEditingController _repsController;

  late final FocusNode _weightFocusNode;
  late final FocusNode _repsFocusNode;
  late int setIndex;

  late final ExerciseService _exerciseService;

  DatabaseSet? _set;

  void _setupTextControllerListener() {
    _weightController.removeListener(_kgAndRepsControllerListner);
    _weightController.addListener(_kgAndRepsControllerListner);
    _repsController.removeListener(_kgAndRepsControllerListner);
    _repsController.addListener(_kgAndRepsControllerListner);
  }

  int? _convertToInt(String text) {
    try {
      int number = int.parse(text);
      return number;
    } catch (e) {
      return null;
    }
  }

  void _kgAndRepsControllerListner() async {
    final mySet = _set;
    if (mySet == null) {
      return;
    }
    final weight = _convertToInt(_weightController.text);
    final reps = _convertToInt(_repsController.text);
    if (weight == null && reps == null) {
      return;
    }
    await _exerciseService.updateSet(
      setToUpdate: mySet,
      weight: weight,
      reps: reps,
    );
    log("saved by controller => id: ${mySet.id}, weight: $weight, reps: $reps");
  }

  void _onRepsSubmitted() {
    //to do
  }

  void _onKgSubmitted() {
    FocusScope.of(context).requestFocus(_repsFocusNode);
  }

  Future<DatabaseSet> createOrGetExistingsSet() async {
    final dbSet = await _exerciseService.getSetByExerciseAndIndex(
      exerciseId: widget.exercise.id,
      setIndex: setIndex,
    );
    if (dbSet == null) {
      //logika programu jest skonstruowana tak ze dbSet nigdy nie powinien byc null
      final newSet = await _exerciseService.createSet(
        exerciseId: widget.exercise.id,
        setIndex: setIndex,
        weight: 0,
        reps: 0,
      );
      _set = newSet;
      return newSet;
    } else {
      _set = dbSet;
      if (dbSet.weight != 0) {
        _weightController.text = dbSet.weight.toString();
      }
      if (dbSet.reps != 0) {
        _repsController.text = dbSet.reps.toString();
      }

      return dbSet;
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseService = ExerciseService();
    _weightController = TextEditingController();
    _repsController = TextEditingController();
    _weightFocusNode = FocusNode();
    _repsFocusNode = FocusNode();
    setIndex = widget.setIndex;
  }

  @override
  void dispose() {
    log("dispose row");
    _weightController.dispose();
    _repsController.dispose();
    _weightFocusNode.dispose();
    _repsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createOrGetExistingsSet(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            _setupTextControllerListener();
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        '$setIndex',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      focusNode: _weightFocusNode,
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
          default:
            return const SizedBox(height: 0);
        }
      },
    );
  }
}
