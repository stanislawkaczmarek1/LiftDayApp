import 'dart:async';
import 'package:intl/intl.dart';
import 'package:liftday/sevices/crud/crud_exceptions.dart';
import 'package:liftday/sevices/crud/tables_classes/database_constans.dart';
import 'package:liftday/sevices/crud/tables_classes/database_date.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/sevices/crud/tables_classes/database_exercise.dart';
import 'package:liftday/sevices/crud/tables_classes/database_set.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class ExerciseService {
  Database? _db;

  static final ExerciseService _shared = ExerciseService._sharedInstance();
  ExerciseService._sharedInstance();
  factory ExerciseService() => _shared;
  //singleton

  Future<DatabaseDate> createDate(
      {required String digitDate, required String day}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final dateId = await db.insert(datesTable, {
      digitDateColumn: digitDate,
      dayColumn: day,
    });

    final date = DatabaseDate(
      id: dateId,
      digitDate: digitDate,
      day: day,
    );

    return date;
  }

  Future<DatabaseDate> getDate({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dates = await db.query(
      datesTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (dates.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final date = DatabaseDate.fromRow(dates.first);
      return date;
    }
  }

  Future<Iterable<DatabaseDate>> getAllDates() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dates = await db.query(
      datesTable,
    );

    return dates.map((dateRow) => DatabaseDate.fromRow(dateRow));
  }

  Future<void> deleteDate({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      datesTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<List<DatabaseDate>> createRangeOfDatesConfig(
      {required int range}) async {
    //conversion
    if (range > 56) {
      throw Exception('Too big range');
    }
    List<String> digitDates = [];
    List<String> days = [];
    DateTime currentDate = DateTime.now();
    DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    DateFormat dayFormatter = DateFormat('EEEE');

    for (int i = 0; i < range; i++) {
      DateTime date = currentDate.add(Duration(days: i));

      String formattedDate = dateFormatter.format(date);
      String dayOfWeek = dayFormatter.format(date);

      digitDates.add(formattedDate);
      days.add(dayOfWeek);
    }
    //end of conversion

    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    if (digitDates.length != days.length || digitDates.length != range) {
      throw Exception('Length of digitDates and days must match the range.');
    }

    List<DatabaseDate> createdDates = [];

    await db.transaction((txn) async {
      for (int i = 0; i < range; i++) {
        final dateId = await txn.insert(datesTable, {
          digitDateColumn: digitDates[i],
          dayColumn: days[i],
        });

        final newDate = DatabaseDate(
          id: dateId,
          digitDate: digitDates[i],
          day: days[i],
        );

        createdDates.add(newDate);
      }
    });

    return createdDates;
  }

  Future<DatabaseExercise> createExercise(
      {required int dateId, required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exerciseId = await db.insert(exercisesTable, {
      dateIdColumn: dateId,
      nameColumn: name,
    });

    final exercise = DatabaseExercise(
      id: exerciseId,
      dateId: dateId,
      name: name,
    );

    return exercise;
  }

  Future<void> createExercisesConfig({
    required List<TrainingDay> exerciseDays,
    required List<DatabaseDate> dates,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Grupowanie dat według dni tygodnia
    final Map<String, List<DatabaseDate>> datesGroupedByDay = {};
    for (var date in dates) {
      if (!datesGroupedByDay.containsKey(date.day)) {
        datesGroupedByDay[date.day] = [];
      }
      datesGroupedByDay[date.day]!.add(date);
    }

    await db.transaction((txn) async {
      for (var exerciseDay in exerciseDays) {
        final day = exerciseDay.day;

        // Pobierz wszystkie daty odpowiadające dniowi tygodnia
        final datesForDay = datesGroupedByDay[day];

        if (datesForDay != null) {
          for (var date in datesForDay) {
            for (var exerciseName in exerciseDay.exercises) {
              await txn.insert(exercisesTable, {
                dateIdColumn: date.id,
                nameColumn: exerciseName,
              });
            }
          }
        }
      }
    });
  }

  Future<void> saveTrainingDay(TrainingDay trainingDay) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.insert(
      trainingDaysTable,
      {
        dayColumn: trainingDay.day,
        exercisesColumn: trainingDay.exercises.join(','),
      },
    );
  }

  Future<void> editTrainingDay(TrainingDay trainingDay) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final updatesCount = await db.update(
      trainingDaysTable,
      {
        exercisesColumn: trainingDay.exercises.join(','),
      },
      where: "day = ?",
      whereArgs: [trainingDay.day],
    );
    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    }
  }

  Future<List<TrainingDay>> getTrainingDays() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final List<Map<String, dynamic>> maps = await db.query(trainingDaysTable);

    return List.generate(maps.length, (i) {
      return TrainingDay(
        day: maps[i][dayColumn],
        exercises: (maps[i][exercisesColumn] as String).split(','),
      );
    });
  }

  Future<void> updateTrainingDayFromTomorrowToEndOfDates(
      TrainingDay trainingDay) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowString = tomorrow.toIso8601String().split('T')[0];

    await db.transaction((txn) async {
      // 1. Pobierz wszystkie daty od jutra do końca z tabeli `dates`
      final datesToRemove = await txn.query(
        datesTable,
        where: "$digitDateColumn >= ? AND $dayColumn = ?",
        whereArgs: [
          tomorrowString,
          trainingDay.day
        ], // Porównujemy na podstawie stringa ISO8601
      );

      // Jeśli nie ma dat do usunięcia, zakończ operację
      if (datesToRemove.isEmpty) {
        return;
      }

      // 2. Dla każdej daty usuń wszystkie ćwiczenia i powiązane zestawy
      for (var date in datesToRemove) {
        final dateId = date[idColumn];

        // Usuń zestawy powiązane z ćwiczeniami
        await txn.delete(
          setsTable,
          where:
              "$exerciseIdColumn IN (SELECT $idColumn FROM $exercisesTable WHERE $dateIdColumn = ?)",
          whereArgs: [dateId],
        );

        // Usuń ćwiczenia dla danej daty
        await txn.delete(
          exercisesTable,
          where: "$dateIdColumn = ?",
          whereArgs: [dateId],
        );
      }

      // 3. Dodaj nowe ćwiczenia dla każdej daty z tego samego zakresu
      for (var date in datesToRemove) {
        final dateId = date[idColumn];

        for (var exercise in trainingDay.exercises) {
          // Dodaj ćwiczenie dla danej daty
          await txn.insert(
            exercisesTable,
            {
              dateIdColumn: dateId,
              nameColumn: exercise,
            },
          );
        }
      }
    });
  }

  Future<DatabaseExercise> getExercise({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      exercisesTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseExercise.fromRow(results.first);
    }
  }

  Future<Iterable<DatabaseExercise>> getAllExercises() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final exercises = await db.query(
      exercisesTable,
    );

    return exercises
        .map((exercisesRow) => DatabaseExercise.fromRow(exercisesRow));
  }

  Future<void> deleteExercise({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      exercisesTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseDate?> getDateByDigitDate({required String digitDate}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dates = await db.query(
      datesTable,
      where: "$digitDateColumn = ?",
      whereArgs: [digitDate],
    );
    if (dates.isEmpty) return null;
    return DatabaseDate.fromRow(dates.first);
  }

  Future<List<DatabaseExercise>> getExercisesForDate(
      {required int dateId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final exercises = await db.query(
      exercisesTable,
      where: "$dateIdColumn = ?",
      whereArgs: [dateId],
    );
    return exercises.map((row) => DatabaseExercise.fromRow(row)).toList();
  }

  Future<DatabaseExercise?> getExerciseByDateAndName(
      {required int dateId, required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      exercisesTable,
      limit: 1,
      where: "$dateIdColumn = ? AND $nameColumn = ?",
      whereArgs: [dateId, name],
    );
    if (results.isEmpty) {
      return null;
    } else {
      return DatabaseExercise.fromRow(results.first);
    }
  }

  Future<DatabaseSet> createSet(
      {required int exerciseId,
      required int setIndex,
      required int weight,
      required int reps}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final setId = await db.insert(setsTable, {
      exerciseIdColumn: exerciseId,
      setIndexColumn: setIndex,
      weightColumn: weight,
      repsColumn: reps,
    });
    final newSet = DatabaseSet(
      id: setId,
      exerciseId: exerciseId,
      setIndex: setIndex,
      weight: weight,
      reps: reps,
    );

    return newSet;
  }

  Future<DatabaseSet> getSet({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      setsTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseSet.fromRow(results.first);
    }
  }

  Future<List<DatabaseSet>> getSetsForExercise(
      {required int exerciseId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final sets = await db.query(
      setsTable,
      where: "$exerciseIdColumn = ?",
      whereArgs: [exerciseId],
    );
    if (sets.isEmpty) {
      return [];
    } else {
      return sets.map((row) {
        final set = DatabaseSet.fromRow(row);
        return set;
      }).toList();
    }
  }

  Future<DatabaseSet?> getSetByExerciseAndIndex(
      {required int exerciseId, required int setIndex}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final sets = await db.query(
      setsTable,
      limit: 1,
      where: "$exerciseIdColumn = ? AND $setIndexColumn = ?",
      whereArgs: [exerciseId, setIndex],
    );
    if (sets.isEmpty) {
      return null;
    } else {
      final existingSet = DatabaseSet.fromRow(sets.first);
      return existingSet;
    }
  }

  Future<DatabaseSet?> updateSet(
      {required DatabaseSet setToUpdate,
      required int? weight,
      required int? reps}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final updates = <String, Object?>{};
    if (weight != null) {
      updates[weightColumn] = weight;
    }
    if (reps != null) {
      updates[repsColumn] = reps;
    }
    if (updates.isEmpty) {
      return null;
    }
    final updatesCount = await db.update(
      setsTable,
      updates,
      where: "$idColumn = ?",
      whereArgs: [setToUpdate.id],
    );
    if (updatesCount == 0) {
      return null;
    }

    final updatedSet = await getSet(id: setToUpdate.id);
    return updatedSet;
  }

  Future<void> deleteSet({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      setsTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<void> deleteSetByIndexForExercise(
      {required int setIndex, required int exerciseId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      setsTable,
      where: "$exerciseIdColumn = ? AND $setIndexColumn = ?",
      whereArgs: [exerciseId, setIndex],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<void> deleteSetsForExercise({required int exerciseid}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      setsTable,
      where: "$exerciseIdColumn = ?",
      whereArgs: [exerciseid],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpen();
    } else {
      return db;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createDatesTable);
      await db.execute(createExerciseTable);
      await db.execute(createSetsTable);
      await db.execute(createTrainingDaysTable);

      //await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}
