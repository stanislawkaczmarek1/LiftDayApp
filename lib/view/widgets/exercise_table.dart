import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables_classes/database_date.dart';
import 'package:liftday/sevices/crud/tables_classes/database_exercise.dart';
import 'package:liftday/sevices/crud/tables_classes/database_set.dart';
import 'package:liftday/sevices/crud/training_day.dart';

class ExerciseTable extends StatefulWidget {
  final DateTime selectedDate;
  const ExerciseTable({super.key, required this.selectedDate});

  @override
  State<ExerciseTable> createState() => _ExerciseTableState();
}

class _ExerciseTableState extends State<ExerciseTable> {
  late DatabaseDate? _date;
  late final ExerciseService _exerciseService;

  late StreamController<List<ExerciseCard>> _exercisesStreamController;
  List<ExerciseCard> _exerciseCards = [];

  TrainingDay? _selectedDay;
  TrainingDay? _tempSelectedDay;

  void _addExercise(String name) async {
    if (_date != null) {
      final existingExercise = await _exerciseService.getExerciseByDateAndName(
          dateId: _date!.id, name: name);
      if (existingExercise != null) {
        if (mounted) {
          showErrorDialog(context);
          return;
        }
      }
      if (_exerciseCards.length >= 10) {
        if (mounted) {
          showErrorDialog(context);
          return;
        }
      }
      await _exerciseService.createExercise(dateId: _date!.id, name: name);
      _exerciseCards.add(ExerciseCard(
        exerciseName: name,
        selectedDate: _date!,
        onDeleteCard: _deleteExercise,
      ));
      _exercisesStreamController.add(_exerciseCards);
    } else {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(const Duration(days: 14));
      DateTime endDate = now.add(const Duration(days: 14));

      if (widget.selectedDate.isAfter(startDate) &&
          widget.selectedDate.isBefore(endDate)) {
        _exerciseService.createDate(dateTime: widget.selectedDate);
        setState(() {
          _loadExercisesForSelectedDate();
        });
        _addExercise(name);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Kalendarz treningowy nie obejmuje tej daty')),
          );
        }
      }
    }
  }

  Future<void> _deleteExercise(int exerciseId, String name) async {
    await _exerciseService.deleteSetsForExercise(exerciseid: exerciseId);
    await _exerciseService.deleteExercise(id: exerciseId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ćwiczenie usunięte')),
      );
    }
    setState(() {
      _exerciseCards.removeWhere((card) => card.exerciseName == name);
    });
    _exercisesStreamController.add(_exerciseCards);
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

  Future<void> _loadExercisesForSelectedDate() async {
    final digitDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    _date = await _exerciseService.getDateByDigitDate(digitDate: digitDate);

    if (_date != null) {
      final dbExercises =
          await _exerciseService.getExercisesForDate(dateId: _date!.id);
      final dbExercisesCards = dbExercises
          .map((exercise) => ExerciseCard(
                exerciseName: exercise.name,
                selectedDate: _date!,
                onDeleteCard: _deleteExercise,
              ))
          .toList();
      _exerciseCards = dbExercisesCards;
      if (_selectedDay != null) {
        log("day is selcted");
        final selectedDayExercises =
            await _exerciseService.createExercisesFromTrainingDayInGivenDate(
                trainingDay: _selectedDay!, dateId: _date!.id);
        final selectedDayExercisesCards = selectedDayExercises
            .map((exercise) => ExerciseCard(
                  exerciseName: exercise.name,
                  selectedDate: _date!,
                  onDeleteCard: _deleteExercise,
                ))
            .toList();
        _exerciseCards.addAll(selectedDayExercisesCards);
        _selectedDay = null;
      }
      _exercisesStreamController.add(_exerciseCards);
    }
  }

  Future<List<TrainingDay>> _fetchTrainingDaysToRadioList() async {
    final trainingDays = _exerciseService.getTrainingDays();
    return trainingDays;
  }

  void _showSelectDayRadioList() async {
    List<TrainingDay> days = await _fetchTrainingDaysToRadioList();
    if (days.isEmpty) {
      if (mounted) {
        showErrorDialog(context);
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...days.map((day) {
                      return RadioListTile<TrainingDay>(
                        title: Text(
                          day.day,
                          style: const TextStyle(fontSize: 16),
                        ),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: day,
                        groupValue: _tempSelectedDay,
                        onChanged: (TrainingDay? value) {
                          setState(() {
                            _tempSelectedDay = value;
                          });
                        },
                      );
                    })
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Anuluj'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(
                        () {
                          _selectedDay = _tempSelectedDay;
                          _loadExercisesForSelectedDate();
                        },
                      );
                    },
                    child: const Text('Zatwierdź'),
                  ),
                ],
              );
            });
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseService = ExerciseService();
    _exercisesStreamController = StreamController<List<ExerciseCard>>.broadcast(
      onListen: () {
        _exercisesStreamController.sink.add(_exerciseCards);
      },
    );
  }

  @override
  void dispose() {
    _exercisesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _loadExercisesForSelectedDate(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder<List<ExerciseCard>>(
                      stream: _exercisesStreamController.stream,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                            if (snapshot.hasData && snapshot.data != null) {
                              final exercises = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: exercises.length,
                                itemBuilder: (context, index) {
                                  return exercises[index];
                                },
                              );
                            } else {
                              return const SizedBox(height: 0.0);
                            }
                          default:
                            return const SizedBox(height: 0.0);
                        }
                      }),
                  Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextButton(
                              onPressed: _showAddExerciseDialog,
                              style: TextButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  "+ Dodaj ćwiczenie",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        top: 16,
                        child: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'load_day') {
                              _showSelectDayRadioList();
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'load_day',
                                child: Text('Wczytaj dzień'),
                              ),
                            ];
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            default:
              return const SizedBox(height: 0);
          }
        });
  }
}

//exercise card moze byc stworzony tylko gdy dane cwiczenie istnieje w dany dzien (patrz metoda _loadExercises)
class ExerciseCard extends StatefulWidget {
  final DatabaseDate selectedDate;
  final String exerciseName;
  final Function(int exerciseId, String name) onDeleteCard;

  const ExerciseCard({
    super.key,
    required this.selectedDate,
    required this.exerciseName,
    required this.onDeleteCard,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late int _setCounter = 0;
  late final ExerciseService _exerciseService;
  late DatabaseExercise? _exercise;

  late StreamController<List<ExerciseRow>> _setsStreamController;
  List<ExerciseRow> _setRows = [];

  Future<void> _addSet(int setIndex) async {
    if (_exercise != null) {
      if (_setRows.length >= 10) {
        if (mounted) {
          showErrorDialog(context);
          return;
        }
      }

      int lastSetWeight = 0;
      int lastSetReps = 0;

      if (_setRows.isNotEmpty) {
        final lastSet = _setRows.last;
        final dbLastSet = await _exerciseService.getSetByExerciseAndIndex(
            exerciseId: _exercise!.id, setIndex: lastSet.setIndex);
        if (dbLastSet != null) {
          lastSetWeight = dbLastSet.weight;
          lastSetReps = dbLastSet.reps;
        }
      }

      await _exerciseService.createSet(
        exerciseId: _exercise!.id,
        setIndex: setIndex,
        weight: lastSetWeight,
        reps: lastSetReps,
      );
      _setRows.add(ExerciseRow(
        exercise: _exercise!,
        setIndex: setIndex,
        onDeleteSet: _deleteSet,
      ));
      _setsStreamController.add(_setRows);
      log("created set with index $setIndex");
    } else {
      if (mounted) {
        showErrorDialog(context);
      }
    }
  }

  Future<void> _deleteSet(int setIndex) async {
    if (_exercise != null) {
      await _exerciseService.deleteSetByIndexForExercise(
        exerciseId: _exercise!.id,
        setIndex: setIndex,
      );
      setState(() {
        _setRows.removeWhere((row) => row.setIndex == setIndex);
      });
      _setsStreamController.add(_setRows);
    }
  }

  Future<void> _loadSetsForExercise() async {
    DatabaseExercise? exercise =
        await _exerciseService.getExerciseByDateAndName(
            dateId: widget.selectedDate.id, name: widget.exerciseName);
    _exercise = exercise;

    if (exercise != null) {
      final dbSets =
          await _exerciseService.getSetsForExercise(exerciseId: exercise.id);
      if (dbSets.isEmpty) {
        _setCounter = 0;
        _addSet(++_setCounter);
      } else {
        _setCounter = dbSets.last.setIndex;
        final rowDbSets = dbSets
            .map((dbSet) => ExerciseRow(
                  exercise: exercise,
                  setIndex: dbSet.setIndex,
                  onDeleteSet: _deleteSet,
                ))
            .toList();
        _setRows = rowDbSets;
        _setsStreamController.add(_setRows);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseService = ExerciseService();
    _setsStreamController = StreamController<List<ExerciseRow>>.broadcast(
      onListen: () {
        _setsStreamController.sink.add(_setRows);
      },
    );
  }

  @override
  void dispose() {
    log("dispose card");
    _setsStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadSetsForExercise(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Card(
              color: Theme.of(context).colorScheme.primary,
              surfaceTintColor: Theme.of(context).colorScheme.primary,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.exerciseName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Usuń ćwiczenie'),
                                  content: const Text(
                                      'Czy na pewno chcesz usunąć to ćwiczenie?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Anuluj'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Usuń'),
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true && _exercise != null) {
                                widget.onDeleteCard(
                                    _exercise!.id, _exercise!.name);
                                // Informowanie o usunięciu ćwiczenia
                                // Zaktualizuj widok po usunięciu
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Usuń'),
                              ),
                            ];
                          },
                          icon: const Icon(Icons.more_vert),
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
                    StreamBuilder<List<ExerciseRow>>(
                        stream: _setsStreamController.stream,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                              if (snapshot.hasData && snapshot.data != null) {
                                final sets = snapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: sets.length,
                                  itemBuilder: (context, index) {
                                    return sets[index];
                                  },
                                );
                              } else {
                                return const SizedBox(height: 0.0);
                              }
                            default:
                              return const SizedBox(height: 0.0);
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () => _addSet(++_setCounter),
                        style: TextButton.styleFrom(
                          elevation: 3.0,
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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
          default:
            return const SizedBox(height: 0);
        }
      },
    );
  }
}

class ExerciseRow extends StatefulWidget {
  final DatabaseExercise exercise;
  final int setIndex;
  final Function(int setIndex) onDeleteSet;

  const ExerciseRow({
    super.key,
    required this.exercise,
    required this.setIndex,
    required this.onDeleteSet,
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

  Future<void> createOrGetExistingsSet() async {
    final dbSet = await _exerciseService.getSetByExerciseAndIndex(
      exerciseId: widget.exercise.id,
      setIndex: setIndex,
    );
    _set = dbSet;
    if (dbSet != null) {
      if (dbSet.weight != 0) {
        _weightController.text = dbSet.weight.toString();
      }
      if (dbSet.reps != 0) {
        _repsController.text = dbSet.reps.toString();
      }
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
    log("building row");
    return FutureBuilder<void>(
      future: createOrGetExistingsSet(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            _setupTextControllerListener();
            return Dismissible(
              key: Key(widget.setIndex.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                widget.onDeleteSet(widget.setIndex);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Padding(
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
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.secondary),
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
                        decoration: InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.secondary),
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
              ),
            );
          default:
            return const SizedBox(height: 0);
        }
      },
    );
  }
}
