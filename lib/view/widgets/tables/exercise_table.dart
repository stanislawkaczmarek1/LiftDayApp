import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liftday/dialogs/are_you_sure_to%20delete_exercise.dart';
import 'package:liftday/dialogs/no_days_to_load.dart';
import 'package:liftday/dialogs/unavailable_operation.dart';
import 'package:liftday/sevices/bloc/settings/settings_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_state.dart';
import 'package:liftday/sevices/bloc/tap/tap_bloc.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables/database_date.dart';
import 'package:liftday/sevices/crud/tables/database_exercise.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/crud/tables/database_set.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/view/routes_views/add_exercise_view.dart';
import 'package:liftday/view/routes_views/report_view.dart';

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

  TrainingDayData? _selectedDay;

  void _addExercise(String? name, String? type, String? muscleGroup,
      int? exerciseInfoId) async {
    if (_date != null) {
      final DatabaseExercise exercise;
      if (name != null &&
          type != null &&
          muscleGroup != null &&
          exerciseInfoId == null) {
        //wpisane
        final result = await _exerciseService.checkIfExerciseInfoExistAndReturn(
          name: name,
          type: type,
          muscleGroup: muscleGroup,
        );
        if (result == null) {
          //nie ma w bazie wiec tworzymy i dodajemy stworzone
          final info = await _exerciseService.createExerciseInfo(
              name: name, type: type, muscleGroup: muscleGroup);
          exercise = await _exerciseService.createExercise(
            dateId: _date!.id,
            exerciseInfoId: info.id,
          );
          _exerciseCards.add(ExerciseCard(
            exercise: exercise,
            exerciseName: info.name,
            exerciseType: info.type,
            selectedDate: _date!,
            onDeleteCard: _deleteExercise,
          ));
          _exercisesStreamController.add(_exerciseCards);
        } else {
          // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
          exercise = await _exerciseService.createExercise(
            dateId: _date!.id,
            exerciseInfoId: result.id,
          );
          _exerciseCards.add(ExerciseCard(
            exercise: exercise,
            exerciseName: result.name,
            exerciseType: result.type,
            selectedDate: _date!,
            onDeleteCard: _deleteExercise,
          ));
          _exercisesStreamController.add(_exerciseCards);
        }
      } else if (exerciseInfoId != null) {
        //z listy
        final info = await _exerciseService.getExerciseInfo(id: exerciseInfoId);
        exercise = await _exerciseService.createExercise(
          dateId: _date!.id,
          exerciseInfoId: exerciseInfoId,
        );
        _exerciseCards.add(ExerciseCard(
          exercise: exercise,
          exerciseName: info.name,
          exerciseType: info.type,
          selectedDate: _date!,
          onDeleteCard: _deleteExercise,
        ));
        _exercisesStreamController.add(_exerciseCards);
      }
    } else {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(const Duration(days: 14));
      DateTime endDate = now.add(const Duration(days: 14));

      if (widget.selectedDate.isAfter(startDate) &&
          widget.selectedDate.isBefore(endDate)) {
        _date =
            await _exerciseService.createDate(dateTime: widget.selectedDate);
        _addExercise(name, type, muscleGroup, exerciseInfoId);
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
      _exerciseCards.removeWhere((card) =>
          card.exerciseName ==
          name); //Uwaga usuwanie po nazwie ;( warto dodac indexy do cwiczen imo
    });
    _exercisesStreamController.add(_exerciseCards);
  }

  void _showAddExerciseView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddExerciseView(
          onResult: (name, type, muscleGroup, exerciseInfoId) {
            _addExercise(name, type, muscleGroup, exerciseInfoId);
          },
        ),
      ),
    );
  }

  Future<void> _loadExercisesForSelectedDate() async {
    final digitDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    _date = await _exerciseService.getDateByDigitDate(digitDate: digitDate);

    if (_date != null) {
      final dbExercises =
          await _exerciseService.getExercisesForDate(dateId: _date!.id);

      final dbExercisesCards =
          await Future.wait(dbExercises.map((exercise) async {
        final exerciseInfo =
            await _exerciseService.getExerciseInfo(id: exercise.exerciseInfoId);
        return ExerciseCard(
          exercise: exercise,
          exerciseName: exerciseInfo.name,
          exerciseType: exerciseInfo.type,
          selectedDate: _date!,
          onDeleteCard: _deleteExercise,
        );
      }).toList());
      _exerciseCards = dbExercisesCards;
      if (_selectedDay != null) {
        log("day is selcted: $_selectedDay");
        final selectedDayExercises =
            await _exerciseService.createExercisesFromTrainingDayInGivenDate(
                trainingDay: _selectedDay!, dateId: _date!.id);

        final selectedDayExercisesCards =
            await Future.wait(selectedDayExercises.map((exercise) async {
          final exerciseInfo = await _exerciseService.getExerciseInfo(
              id: exercise.exerciseInfoId);
          return ExerciseCard(
            exercise: exercise,
            exerciseName: exerciseInfo.name,
            exerciseType: exerciseInfo.type,
            selectedDate: _date!,
            onDeleteCard: _deleteExercise,
          );
        }).toList());
        _exerciseCards.addAll(selectedDayExercisesCards);
        _selectedDay = null;
      }
      _exercisesStreamController.add(_exerciseCards);
    } //else nic sie nie dzieje czekamy na akcje uzytkownika np dodanie cwiczenia
  }

  Future<List<TrainingDayData>> _fetchTrainingDaysToUiList() async {
    final trainingDays = await _exerciseService.getTrainingDaysData();
    return trainingDays;
  }

  Future<void> _loadDataAndShowReportView(
      DatabaseDate date, String unit) async {
    final List<DatabaseExercise> exercises =
        await _exerciseService.getExercisesForDate(dateId: date.id);
    final List<DatabaseExerciseInfo> exerciseInfos = [];
    final List<List<DatabaseSet>> allExerciseSets = [];
    for (var exercise in exercises) {
      exerciseInfos.add(
          await _exerciseService.getExerciseInfo(id: exercise.exerciseInfoId));
      allExerciseSets.add(
          await _exerciseService.getSetsForExercise(exerciseId: exercise.id));
    }
    double totalVolume = 0;
    for (List<DatabaseSet> exerciseSets in allExerciseSets) {
      for (DatabaseSet dbSet in exerciseSets) {
        totalVolume += dbSet.weight * dbSet.reps;
      }
    }
    if (mounted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReportView(
          trainingTitle: date.digitDate,
          exercises: exercises,
          exerciseInfos: exerciseInfos,
          allExerciseSets: allExerciseSets,
          totalVolume: totalVolume,
          unit: unit,
        ),
      ));
    }
  }

  Future<void> _showSelectDayUiList() async {
    if (_date != null) {
      List<TrainingDayData> days = await _fetchTrainingDaysToUiList();
      if (days.isEmpty) {
        if (mounted) {
          showNoDaysToLoadDialog(context);
        }
      } else {
        if (mounted) {
          TrainingDayData? tempSelectedDay;
          showModalBottomSheet(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setSheetState) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const Text(
                            "Wybierz dzień:",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ...days.map((day) {
                            return GestureDetector(
                              onTap: () {
                                setSheetState(() {
                                  if (tempSelectedDay == day) {
                                    tempSelectedDay = null;
                                  } else {
                                    tempSelectedDay = day;
                                  }
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: tempSelectedDay == day
                                      ? Theme.of(context).colorScheme.onTertiary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onTertiary,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: tempSelectedDay == day
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onTertiary,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      day.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (tempSelectedDay == day)
                                      Icon(
                                        Icons.check,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ).then((_) {
            if (tempSelectedDay != null) {
              setState(() {
                _selectedDay = tempSelectedDay;
              });
            }
          });
        }
      }
    } else {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(const Duration(days: 14));
      DateTime endDate = now.add(const Duration(days: 14));

      if (widget.selectedDate.isAfter(startDate) &&
          widget.selectedDate.isBefore(endDate)) {
        _date =
            await _exerciseService.createDate(dateTime: widget.selectedDate);
        await _showSelectDayUiList();
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 9,
                          child: GestureDetector(
                            onTap: () {
                              if (_exerciseCards.length >= 10) {
                                if (mounted) {
                                  showUnavailableOperationDialog(context);
                                }
                              } else {
                                _showAddExerciseView();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onTertiary,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  )),
                              child: Center(
                                child: Text(
                                  "+ Dodaj ćwiczenie",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: BlocBuilder<SettingsBloc, SettingsState>(
                            builder: (context, state) {
                              return PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'load_day') {
                                    await _showSelectDayUiList();
                                  }
                                  if (value == 'generate_report') {
                                    if (_date != null) {
                                      await _loadDataAndShowReportView(
                                          _date!, state.unit);
                                    } else {
                                      if (context.mounted) {
                                        showUnavailableOperationDialog(context);
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'load_day',
                                      child: Text('Wczytaj dzień'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'generate_report',
                                      child: Text('Generuj raport'),
                                    ),
                                  ];
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
  final DatabaseExercise exercise;
  final String exerciseName;
  final String exerciseType;
  final Function(int exerciseId, String name) onDeleteCard;

  const ExerciseCard({
    super.key,
    required this.selectedDate,
    required this.exercise,
    required this.exerciseName,
    required this.exerciseType,
    required this.onDeleteCard,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  late int _setCounter = 0;
  late final ExerciseService _exerciseService;

  late StreamController<List<ExerciseRow>> _setsStreamController;
  List<ExerciseRow> _setRows = [];

  late bool _isThatDurationTypeExercise = false;

  Future<void> _addSet(int setIndex) async {
    if (_setRows.length >= 10) {
      if (mounted) {
        showUnavailableOperationDialog(context);
        return;
      }
    }

    double lastSetWeight = 0.0;
    int lastSetReps = 0;
    int lastSetDuration = 0;

    if (_setRows.isNotEmpty) {
      final lastSet = _setRows.last;
      final dbLastSet = await _exerciseService.getSetByExerciseAndIndex(
          exerciseId: widget.exercise.id, setIndex: lastSet.setIndex);
      if (dbLastSet != null) {
        lastSetWeight = dbLastSet.weight;
        lastSetReps = dbLastSet.reps;
        lastSetDuration = dbLastSet.duration;
      }
    }

    if (_isThatDurationTypeExercise) {
      await _exerciseService.createDurationSet(
        exerciseId: widget.exercise.id,
        setIndex: setIndex,
        weight: lastSetWeight,
        duration: lastSetDuration,
      );
    } else {
      await _exerciseService.createSet(
        exerciseId: widget.exercise.id,
        setIndex: setIndex,
        weight: lastSetWeight,
        reps: lastSetReps,
      );
    }

    _setRows.add(ExerciseRow(
      exercise: widget.exercise,
      setIndex: setIndex,
      onDeleteSet: _deleteSet,
    ));
    _setsStreamController.add(_setRows);
    log("created set with index $setIndex");
  }

  Future<void> _deleteSet(int setIndex) async {
    await _exerciseService.deleteSetByIndexForExercise(
      exerciseId: widget.exercise.id,
      setIndex: setIndex,
    );
    setState(() {
      _setRows.removeWhere((row) => row.setIndex == setIndex);
    });
    _setsStreamController.add(_setRows);
  }

  Future<void> _loadSetsForExercise() async {
    final dbSets = await _exerciseService.getSetsForExercise(
        exerciseId: widget.exercise.id);
    if (dbSets.isEmpty) {
      _setCounter = 0;
      _addSet(++_setCounter);
    } else {
      _setCounter = dbSets.last.setIndex;
      final rowDbSets = dbSets
          .map((dbSet) => ExerciseRow(
                exercise: widget.exercise,
                setIndex: dbSet.setIndex,
                onDeleteSet: _deleteSet,
              ))
          .toList();
      _setRows = rowDbSets;
      _setsStreamController.add(_setRows);
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
    if (widget.exerciseType == "duration") {
      _isThatDurationTypeExercise = true;
    }
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
              color: Theme.of(context).colorScheme.onPrimary,
              surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
              shadowColor: Colors.transparent,
              margin: const EdgeInsets.all(0),
              shape: const ContinuousRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.exerciseName,
                              softWrap: true, //TODO: dodac gdzie potrzeba
                              maxLines: 2, //
                              overflow: TextOverflow.ellipsis, //
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) async {
                              if (value == 'delete') {
                                final confirm =
                                    await showAreYouSureToDeleteExerciseDialog(
                                        context);
                                if (confirm == true) {
                                  widget.onDeleteCard(
                                      widget.exercise.id, widget.exerciseName);
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
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Expanded(
                          child: Center(
                            child: Text('seria',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ),
                        const Expanded(
                          child: Center(
                              child: Icon(
                            Icons.history,
                            size: 20,
                            color: Colors.grey,
                          )),
                        ),
                        Expanded(
                          child: Center(
                            child: BlocBuilder<SettingsBloc, SettingsState>(
                              builder: (context, state) {
                                return Text(state.unit,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal));
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                              child: _isThatDurationTypeExercise
                                  ? const Icon(
                                      Icons.timer,
                                      size: 20,
                                    )
                                  : const Text('x',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal))),
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
                      child: GestureDetector(
                        onTap: () {
                          _addSet(++_setCounter);
                          context.read<TapBloc>().add(Tap());
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
                              "+ Dodaj serię",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).colorScheme.primary,
                              ),
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
  late final TextEditingController _durationController;
  late final FocusNode _weightFocusNode;
  late final FocusNode _repsFocusNode;
  late final FocusNode _durationFocusNode;
  final ValueNotifier<bool> _isInputActive = ValueNotifier<bool>(false);

  late int setIndex;

  late final ExerciseService _exerciseService;

  String? _lastSetHistory;

  DatabaseSet? _set;

  bool _isThatDurationTypeSet = false;

  void _setupTextControllerListenerTypeReps() {
    _weightController.removeListener(_kgAndRepsControllerListner);
    _weightController.addListener(_kgAndRepsControllerListner);
    _repsController.removeListener(_kgAndRepsControllerListner);
    _repsController.addListener(_kgAndRepsControllerListner);
  }

  void _setupTextControllerListenerTypeDuration() {
    _weightController.removeListener(_kgAndDurationControllerListner);
    _weightController.addListener(_kgAndDurationControllerListner);
    _durationController.removeListener(_kgAndDurationControllerListner);
    _durationController.addListener(_kgAndDurationControllerListner);
  }

  int? _convertToInt(String text) {
    try {
      int number = int.parse(text);
      return number;
    } catch (e) {
      return null;
    }
  }

  double? _convertToDouble(String text) {
    try {
      double number = double.parse(text);
      return number;
    } catch (e) {
      return null; // Zwraca null w przypadku błędu konwersji
    }
  }

  int _convertTimeToSeconds(String time) {
    if (!time.contains(':')) return 0;

    List<String> parts = time.split(':');
    if (parts.length != 2) return 0;

    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;

    return (minutes * 60) + seconds;
  }

  void _kgAndRepsControllerListner() async {
    final mySet = _set;
    if (mySet == null) {
      return;
    }
    final weight = _convertToDouble(_weightController.text);
    final reps = _convertToInt(_repsController.text);

    await _exerciseService.updateSet(
      setToUpdate: mySet,
      weight: weight,
      reps: reps,
      duration: null,
    );
    log("saved by controller => id: ${mySet.id}, weight: $weight, reps: $reps");
  }

  void _kgAndDurationControllerListner() async {
    String durationText = _durationController.text;
    durationText = durationText.replaceAll(RegExp(r'[^0-9]'), '');

    if (durationText.length >= 3) {
      durationText =
          '${durationText.substring(0, 2)}:${durationText.substring(2)}';
    }
    if (durationText.length > 5) {
      durationText = durationText.substring(0, 5);
    }
    _durationController.value = _durationController.value.copyWith(
      text: durationText,
      selection: TextSelection.collapsed(offset: durationText.length),
    );

    final mySet = _set;
    if (mySet == null) {
      return;
    }
    final weight = _convertToDouble(_weightController.text);
    final duration = _convertTimeToSeconds(durationText);

    await _exerciseService.updateSet(
      setToUpdate: mySet,
      weight: weight,
      reps: null,
      duration: duration,
    );
    log("saved by controller => id: ${mySet.id}, weight: $weight, duration: $duration");
  }

  String _convertSecondsToTime(int seconds) {
    if (seconds < 0) {
      return '00:00';
    }

    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }

  Future<void> createOrGetExistingsSet() async {
    //mozna to jakos bardziej elegancko rozwiazac
    final info = await _exerciseService.getExerciseInfo(
        id: widget.exercise.exerciseInfoId);
    if (info.type == "duration") {
      _isThatDurationTypeSet = true;
    }

    final dbSet = await _exerciseService.getSetByExerciseAndIndex(
      exerciseId: widget.exercise.id,
      setIndex: setIndex,
    );
    _set = dbSet;

    if (dbSet != null) {
      if (dbSet.weight != 0.0) {
        final value = dbSet.weight;
        String formattedValue = value == value.toInt()
            ? value.toInt().toString()
            : value.toStringAsFixed(1);
        _weightController.text = formattedValue;
      }
      if (dbSet.reps != 0) {
        _repsController.text = dbSet.reps.toString();
      }
      if (dbSet.duration != 0) {
        _durationController.text = _convertSecondsToTime(dbSet.duration);
      }

      if (_isThatDurationTypeSet) {
        _lastSetHistory = await _exerciseService.getPreviousDurationSetData(
            widget.exercise.dateId,
            widget.exercise.exerciseInfoId,
            widget.setIndex);
      } else {
        _lastSetHistory = await _exerciseService.getPreviousRepsSetData(
            widget.exercise.dateId,
            widget.exercise.exerciseInfoId,
            widget.setIndex);
      }
    }
  }

  void _removeFocus() {
    log("removing focus");
    if (_weightFocusNode.hasFocus) {
      _weightFocusNode.unfocus();
      _isInputActive.value = false;
    } else if (_repsFocusNode.hasFocus) {
      _isInputActive.value = false;
      _repsFocusNode.unfocus();
    } else if (_durationFocusNode.hasFocus) {
      _isInputActive.value = false;
      _durationFocusNode.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    _exerciseService = ExerciseService();
    _weightController = TextEditingController();
    _repsController = TextEditingController();
    _durationController = TextEditingController();
    _weightFocusNode = FocusNode();
    _repsFocusNode = FocusNode();
    _durationFocusNode = FocusNode();
    setIndex = widget.setIndex;
  }

  @override
  void dispose() {
    log("dispose row");
    _weightController.dispose();
    _repsController.dispose();
    _durationController.dispose();
    _weightFocusNode.dispose();
    _repsFocusNode.dispose();
    _durationFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("building row");
    return BlocListener<TapBloc, TapState>(
      listener: (context, state) {
        if (state is Tapped && _isInputActive.value == true) {
          log("change in state");
          _removeFocus();
          context.read<TapBloc>().add(SetTappedDefault());
        }
      },
      child: FutureBuilder<void>(
        future: createOrGetExistingsSet(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (_isThatDurationTypeSet) {
                _setupTextControllerListenerTypeDuration();
              } else {
                _setupTextControllerListenerTypeReps();
              }
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 0.0),
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
                          controller: TextEditingController(
                            text: _lastSetHistory ?? "-",
                          ),
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onTap: () => _isInputActive.value = true,
                          onEditingComplete: () {
                            _isInputActive.value = false;
                            if (_weightFocusNode.nextFocus()) {
                              _isInputActive.value = true;
                            } else {
                              _isInputActive.value = false;
                            }
                          },
                          controller: _weightController,
                          focusNode: _weightFocusNode,
                          decoration: InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      _isThatDurationTypeSet
                          ? Expanded(
                              child: TextField(
                                onTap: () => _isInputActive.value = true,
                                onEditingComplete: () {
                                  _durationFocusNode.unfocus();
                                  _isInputActive.value = false;
                                },
                                controller: _durationController,
                                focusNode: _durationFocusNode,
                                decoration: InputDecoration(
                                  hintText: 'min:sec',
                                  hintStyle: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                                textInputAction: TextInputAction.done,
                              ),
                            )
                          : Expanded(
                              child: TextField(
                                onTap: () => _isInputActive.value = true,
                                onEditingComplete: () {
                                  _repsFocusNode.unfocus();
                                  _isInputActive.value = false;
                                },
                                controller: _repsController,
                                focusNode: _repsFocusNode,
                                decoration: InputDecoration(
                                  hintText: '',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                                textInputAction: TextInputAction.done,
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
      ),
    );
  }
}
