import 'package:intl/intl.dart';
import 'package:liftday/sevices/crud/crud_exceptions.dart';
import 'package:liftday/sevices/crud/tables_classes/database_constans.dart';
import 'package:liftday/sevices/crud/tables_classes/database_date.dart';
import 'package:liftday/sevices/crud/exercise_day.dart';
//import 'package:liftday/sevices/crud/database_set.dart';
import 'package:liftday/sevices/crud/exercises/database_exercise.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class ExerciseService {
  Database? _db;
  List<DatabaseDate> _dates = [];
  List<DatabaseExercise> _exercises = [];
  //List<DatabaseSet> _sets = [];

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

    _dates.add(date);
    //_notesStreamController.add(_notes);
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
      _dates.removeWhere((date) => date.id == id);
      _dates.add(date);
      //_notesStreamController.add(_notes);
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
    } else {
      _dates.removeWhere((note) => note.id == id);
      //_notesStreamController.add(_notes);
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
    DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
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
        _dates.add(newDate);
      }
    });

    return createdDates;
  }

  Future<DatabaseExercise> createExercise(
      {required DatabaseDate date, required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exerciseId = await db.insert(exercisesTable, {
      dateIdColumn: date.id,
      nameColumn: name,
    });

    final exercise = DatabaseExercise(
      id: exerciseId,
      dateId: date.id,
      name: name,
    );

    _exercises.add(exercise);
    //_notesStreamController.add(_notes);
    return exercise;
  }

  Future<void> createExercisesConfig({
    required List<ExerciseDay> exerciseDays,
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
    } else {
      _exercises.removeWhere((exercise) => exercise.id == id);
      //_notesStreamController.add(_notes);
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
