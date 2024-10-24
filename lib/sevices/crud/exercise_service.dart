import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:liftday/constants/app_exercises.dart';
import 'package:liftday/constants/database.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/crud_exceptions.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/data_package/snapshot_data.dart';
import 'package:liftday/sevices/crud/tables/database_date.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/sevices/crud/tables/database_exercise.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/crud/tables/database_set.dart';
import 'package:liftday/sevices/crud/tables/database_training_day.dart';
import 'package:liftday/sevices/crud/tables/database_training_day_exercise.dart';
import 'package:liftday/sevices/crud/data_package/volume_chart_data.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

class ExerciseService {
  Database? _db;

  static final ExerciseService _shared = ExerciseService._sharedInstance();
  ExerciseService._sharedInstance();
  factory ExerciseService() => _shared;
  //singleton

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
      await _open();
    } on DatabaseAlreadyOpenException {
      //empty
    }
  }

  Future<void> _open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createDatesTable);
      await db.execute(createExercisesInfoTable);
      await db.execute(createExerciseTable);
      await db.execute(createSetsTable);
      await db.execute(createTrainingDaysTable);
      await db.execute(createTrainingDayExercisesTable);
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

  //-----navigation----
  //dates
  //exercise infos
  //exercises
  //sets
  //training days
  //training day exercises
  //traing day data
  //charts data

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //dates
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<DatabaseDate> createDate({required DateTime dateTime}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    String digitDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String day = DateFormat('EEEE').format(dateTime);

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

  Future<DatabaseDate> getDateById({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dates = await db.query(
      datesTable,
      limit: 1,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (dates.isEmpty) {
      throw CouldNotFindInDb();
    } else {
      final date = DatabaseDate.fromRow(dates.first);
      return date;
    }
  }

  Future<DatabaseDate> getDate({required String digitDate}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dates = await db.query(
      datesTable,
      limit: 1,
      where: "$digitDateColumn = ?",
      whereArgs: [digitDate],
    );
    if (dates.isEmpty) {
      throw CouldNotFindInDb();
    } else {
      final date = DatabaseDate.fromRow(dates.first);
      return date;
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

  Future<Map<String, Set<DateTime>>> getDatesByTypeAndRange(
      DateTime start, DateTime end) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    String startDate = start.toIso8601String().split('T')[0];
    String endDate = end.toIso8601String().split('T')[0];

    final result = await db.rawQuery('''
    SELECT $datesTable.$digitDateColumn, 
           SUM(CASE WHEN $setsTable.$repsColumn > 0 OR $setsTable.$durationColumn > 0 OR $setsTable.$weightColumn > 0 THEN 1 ELSE 0 END) AS valid_sets_count
    FROM $datesTable
    JOIN $exercisesTable ON $datesTable.$idColumn = $exercisesTable.$dateIdColumn
    LEFT JOIN $setsTable ON $exercisesTable.$idColumn = $setsTable.$exerciseIdColumn
    WHERE $datesTable.$digitDateColumn BETWEEN ? AND ?
    GROUP BY $datesTable.$idColumn
  ''', [startDate, endDate]);

    Set<DateTime> greenDates = {};
    Set<DateTime> grayDates = {};

    for (var row in result) {
      DateTime date = DateTime.parse(row[digitDateColumn] as String);
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);

      int validSetsCount = row['valid_sets_count'] as int;

      if (validSetsCount > 0) {
        greenDates.add(normalizedDate);
      } else {
        grayDates.add(normalizedDate);
      }
    }

    return {
      'green': greenDates,
      'gray': grayDates,
    };
  }

  Future<String?> getFirstDigitDate() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT MIN($digitDateColumn) AS first_date 
    FROM $datesTable
  ''');

    if (result.isNotEmpty && result.first['first_date'] != null) {
      return result.first['first_date'] as String;
    }

    return null;
  }

  Future<String?> getLastDigitDate() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT MAX($digitDateColumn) AS last_date 
    FROM $datesTable
  ''');

    if (result.isNotEmpty && result.first['last_date'] != null) {
      return result.first['last_date'] as String;
    }

    return null;
  }

  Future<List<DatabaseDate>> getDatesFromBetweenTwoDatesBackInTime(
      DateTime start, DateTime end) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final dateFormat = DateFormat('yyyy-MM-dd');
    final startFormatted = dateFormat.format(start);
    final endDateFormatted = dateFormat.format(end);

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM $datesTable
    WHERE $digitDateColumn BETWEEN ? AND ?
    ORDER BY $digitDateColumn DESC
  ''', [endDateFormatted, startFormatted]);

    return result.map((dateRow) => DatabaseDate.fromRow(dateRow)).toList();
  }

  Future<List<DatabaseDate>> getDatesFromTodayInSomeRangeBackInTime(
      int range) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final today = DateTime.now();

    final pastDate = today.subtract(Duration(days: range));

    final dateFormat = DateFormat('yyyy-MM-dd');
    final todayFormatted = dateFormat.format(today);
    final pastDateFormatted = dateFormat.format(pastDate);

    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT * FROM $datesTable
    WHERE $digitDateColumn BETWEEN ? AND ?
    ORDER BY $digitDateColumn DESC
  ''', [pastDateFormatted, todayFormatted]);

    return result.map((dateRow) => DatabaseDate.fromRow(dateRow)).toList();
  }

  Future<List<DatabaseDate>> getAllDates() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dates = await db.query(
      datesTable,
    );

    return dates.map((dateRow) => DatabaseDate.fromRow(dateRow)).toList();
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
      throw CouldNotDeleteFromDb();
    }
  }

  Future<List<DatabaseDate>> createRangeOfDatesConfig(
      {required int range, required DateTime fromDate}) async {
    //conversion
    if (range > 56) {
      throw Exception('Too big range');
    }
    List<String> digitDates = [];
    List<String> days = [];
    DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    DateFormat dayFormatter = DateFormat('EEEE');

    for (int i = 0; i < range; i++) {
      DateTime date = fromDate.add(Duration(days: i));

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

    List<DatabaseDate> dates = [];

    for (int i = 0; i < range; i++) {
      final dateId = await db.rawInsert(
        'INSERT OR IGNORE INTO $datesTable ($digitDateColumn, $dayColumn) VALUES (?, ?)',
        [digitDates[i], days[i]],
      );
      if (dateId != 0) {
        final newDate = DatabaseDate(
          id: dateId,
          digitDate: digitDates[i],
          day: days[i],
        );
        dates.add(newDate);
      } else {
        dates.add(await getDate(digitDate: digitDates[i]));
      }
    }

    return dates;
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //dates
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //exercise infos
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<DatabaseExerciseInfo?> checkIfExerciseInfoExistAndReturn(
      {required String name,
      required String type,
      required String muscleGroup}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exercisesInfo = await db.query(
      exercisesInfoTable,
      limit: 1,
      where:
          "$dayNameColumn = ? AND $typeColumn = ? AND $muscleGroupColumn = ?",
      whereArgs: [name, type, muscleGroup],
    );
    if (exercisesInfo.isEmpty) {
      return null;
    } else {
      return DatabaseExerciseInfo.fromRow(exercisesInfo.first);
    }
  }

  Future<DatabaseExerciseInfo> createExerciseInfo(
      {required String name,
      required String type,
      required String muscleGroup}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exerciseInfoId = await db.insert(exercisesInfoTable, {
      dayNameColumn: name,
      typeColumn: type,
      muscleGroupColumn: muscleGroup,
    });
    final exerciseInfo = DatabaseExerciseInfo(
      id: exerciseInfoId,
      name: name,
      type: type,
      muscleGroup: muscleGroup,
    );
    return exerciseInfo;
  }

  Future<List<DatabaseExerciseInfo>> getExerciseInfosByMuscleGroup(
      String muscleGroup) async {
    List<DatabaseExerciseInfo> selectedExerciseInfos = [];
    final List<DatabaseExerciseInfo> appExercises;

    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      appExercises = appExercisesPl;
    } else {
      appExercises = appExercisesEn;
    }

    final allAppExerciseInfos = List.of(appExercises);
    for (var appExerciseInfo in allAppExerciseInfos) {
      if (appExerciseInfo.muscleGroup == muscleGroup) {
        selectedExerciseInfos.add(appExerciseInfo);
      }
    }

    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbExercisesInfos = await db.query(
      exercisesInfoTable,
      where: "$muscleGroupColumn = ?",
      whereArgs: [muscleGroup],
    );
    final exerciseInfosFromDb = dbExercisesInfos
        .map((exerciseInfoRow) => DatabaseExerciseInfo.fromRow(exerciseInfoRow))
        .toList();

    selectedExerciseInfos.addAll(exerciseInfosFromDb);
    return selectedExerciseInfos;
  }

  Future<DatabaseExerciseInfo> getExerciseInfo({required int id}) async {
    if (id < 0) {
      try {
        final List<DatabaseExerciseInfo> appExercises;
        SettingsService settingsService = SettingsService();
        if (settingsService.language() == "pl") {
          appExercises = appExercisesPl;
        } else {
          appExercises = appExercisesEn;
        }
        final exercise =
            appExercises.firstWhere((exercise) => exercise.id == id);
        return exercise;
      } catch (e) {
        throw Exception(
            'Exercise with ID $id not found in predefined app exercises.');
      }
    }

    log("request fot info id: $id");
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final exercisesInfo = await db.query(
      exercisesInfoTable,
      limit: 1,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (exercisesInfo.isEmpty) {
      throw CouldNotFindInDb();
    } else {
      final exerciseInfo = DatabaseExerciseInfo.fromRow(exercisesInfo.first);
      return exerciseInfo;
    }
  }

  Future<List<DatabaseExerciseInfo>> getAllExercisesInfo() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final exercisesInfo = await db.query(
      exercisesInfoTable,
    );

    return exercisesInfo
        .map((exerciseInfoRow) => DatabaseExerciseInfo.fromRow(exerciseInfoRow))
        .toList();
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //exercise infos
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //exercises
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<DatabaseExercise> createExercise(
      {required int dateId, required int exerciseInfoId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exerciseId = await db.insert(exercisesTable, {
      dateIdColumn: dateId,
      exerciseInfoIdColumn: exerciseInfoId,
    });

    final exercise = DatabaseExercise(
      id: exerciseId,
      dateId: dateId,
      exerciseInfoId: exerciseInfoId,
    );

    return exercise;
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

  Future<List<DatabaseExercise>> getExerciseByDateAndInfoId(
      {required int dateId, required int infoId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      exercisesTable,
      limit: 1,
      where: "$dateIdColumn = ? AND $exerciseInfoIdColumn = ?",
      whereArgs: [dateId, infoId],
    );
    return results.map((row) => DatabaseExercise.fromRow(row)).toList();
  }

  Future<void> deleteExercise({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      exercisesTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteFromDb();
    }
  }

  Future<void> createExercisesConfig({
    required List<TrainingDayData> exerciseDays,
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

    for (var exerciseDay in exerciseDays) {
      final day = exerciseDay.name;

      // Pobierz wszystkie daty odpowiadające dniowi tygodnia
      final datesForDay = datesGroupedByDay[day];

      if (datesForDay != null) {
        for (var date in datesForDay) {
          for (var exercise in exerciseDay.exercises) {
            if (exercise.infoId == null &&
                exercise.name != null &&
                exercise.muscleGroup != null &&
                exercise.type != null) {
              //uzytkownik wpisal wlasne cwiczenie
              // sprawdzenie czy wpisane cwiczenie znajduje sie juz w bazie
              final result = await checkIfExerciseInfoExistAndReturn(
                name: exercise.name!,
                type: exercise.type!,
                muscleGroup: exercise.muscleGroup!,
              );
              if (result == null) {
                //nie ma w bazie wiec tworzymy i dodajemy stworzone
                final info = await createExerciseInfo(
                    name: exercise.name!,
                    type: exercise.type!,
                    muscleGroup: exercise.muscleGroup!);
                await db.insert(exercisesTable, {
                  dateIdColumn: date.id,
                  exerciseInfoIdColumn: info.id,
                });
              } else {
                // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
                await db.insert(exercisesTable, {
                  dateIdColumn: date.id,
                  exerciseInfoIdColumn: result.id,
                });
              }
            } else if (exercise.infoId != null) {
              //uzytkownik wybral cwiczenie z listy
              await db.insert(exercisesTable, {
                dateIdColumn: date.id,
                exerciseInfoIdColumn: exercise.infoId,
              });
            }
          }
        }
      }
    }
  }

  Future<List<DatabaseExercise>> createExercisesFromTrainingDayInGivenDate({
    required TrainingDayData trainingDay,
    required int dateId,
  }) async {
    List<DatabaseExercise> exercises = [];

    for (var i = 0; i < trainingDay.exercises.length; i++) {
      final exerciseInfoId = trainingDay.exercises.elementAt(i).infoId;
      if (exerciseInfoId != null) {
        //nie moze byc null bo w liscie w ui sa ExerciseData w takim formacie (name, type, id)
        exercises.add(await createExercise(
            dateId: dateId, exerciseInfoId: exerciseInfoId));
      }
    }
    return exercises;
  }

  Future<void> deleteExercisesAndSetsFromTomorrowToEndOfDates() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowString = tomorrow.toIso8601String().split('T')[0];

    await db.transaction((txn) async {
      // 1. Pobierz wszystkie daty od jutra do końca z tabeli `dates`
      final datesToRemove = await txn.query(
        datesTable,
        where: "$digitDateColumn >= ?",
        whereArgs: [tomorrowString], // Porównujemy na podstawie stringa ISO8601
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
    });
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //exercises
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //sets
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<DatabaseSet> createSet(
      {required int exerciseId,
      required int setIndex,
      required double weight,
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

  Future<DatabaseSet> createDurationSet(
      {required int exerciseId,
      required int setIndex,
      required double weight,
      required int duration}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final setId = await db.insert(setsTable, {
      exerciseIdColumn: exerciseId,
      setIndexColumn: setIndex,
      weightColumn: weight,
      repsColumn: 0,
      durationColumn: duration,
    });
    final newSet = DatabaseSet(
      id: setId,
      exerciseId: exerciseId,
      setIndex: setIndex,
      weight: weight,
      reps: 0,
      duration: duration,
    );

    return newSet;
  }

  Future<DatabaseSet> getSet({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      setsTable,
      limit: 1,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (results.isEmpty) {
      throw CouldNotFindInDb();
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

  Future<DatabaseSet?> updateSet({
    required DatabaseSet setToUpdate,
    required double? weight,
    required int? reps,
    required int? duration,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final updates = <String, Object?>{};
    if (weight != null) {
      updates[weightColumn] = weight;
    } else {
      updates[weightColumn] = 0.0;
    }
    if (reps != null) {
      updates[repsColumn] = reps;
    } else {
      updates[repsColumn] = 0;
    }
    if (duration != null) {
      updates[durationColumn] = duration;
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
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteFromDb();
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
      throw CouldNotDeleteFromDb();
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
      throw CouldNotDeleteFromDb();
    }
  }

  Future<String?> getPreviousRepsSetData(
      int dateId, int exerciseInfoId, int setIndex) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final date = await getDateById(id: dateId);
    final digitDate = date.digitDate;

    final result = await db.rawQuery('''
    SELECT s.$weightColumn, s.$repsColumn
    FROM $setsTable s
    JOIN $exercisesTable e ON e.$idColumn = s.$exerciseIdColumn
    JOIN $datesTable d ON d.$idColumn = e.$dateIdColumn
    WHERE d.$digitDateColumn < ? AND e.$exerciseInfoIdColumn = ? AND s.$setIndexColumn = ?
    ORDER BY d.$digitDateColumn DESC
    LIMIT 1;
  ''', [digitDate, exerciseInfoId, setIndex]);

    if (result.isNotEmpty) {
      final set = result.first;
      final weight = set[weightColumn] as double;
      final reps = set[repsColumn];
      final weightString = ConversionService.formatWeight(weight);
      final string = '$weightString x $reps';
      if (string == '0 x 0') {
        return null;
      } else {
        return string;
      }
    } else {
      return null;
    }
  }

  Future<String?> getPreviousDurationSetData(
      int dateId, int exerciseInfoId, int setIndex) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final date = await getDateById(id: dateId);
    final digitDate = date.digitDate;

    final result = await db.rawQuery('''
    SELECT s.$weightColumn, s.$durationColumn
    FROM $setsTable s
    JOIN $exercisesTable e ON e.$idColumn = s.$exerciseIdColumn
    JOIN $datesTable d ON d.$idColumn = e.$dateIdColumn
    WHERE d.$digitDateColumn < ? AND e.$exerciseInfoIdColumn = ? AND s.$setIndexColumn = ?
    ORDER BY d.$digitDateColumn DESC
    LIMIT 1;
  ''', [digitDate, exerciseInfoId, setIndex]);

    if (result.isNotEmpty) {
      final set = result.first;
      final weight = set[weightColumn] as double;
      final duration = set[durationColumn] as int;
      final durationString = ConversionService.convertSecondsToTime(duration);
      final weightString = ConversionService.formatWeight(weight);
      final string = '$weightString x $durationString';
      if (string == '0 x 0s') {
        return null;
      } else {
        return string;
      }
    } else {
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //sets
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //training days
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<DatabaseTrainingDay> createTrainingDay(
      {required String name, required bool isFromPlan}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final int trainingDayId;
    final int isFromPlanInt;
    if (isFromPlan) {
      isFromPlanInt = 1;
      trainingDayId = await db.insert(trainingDaysTable, {
        dayNameColumn: name,
      });
    } else {
      isFromPlanInt = 0;
      trainingDayId = await db.insert(trainingDaysTable, {
        dayNameColumn: name,
        isFromPlanColumn: isFromPlanInt,
      });
    }

    final trainingDay = DatabaseTrainingDay(
        id: trainingDayId, name: name, isFromPlan: isFromPlanInt);

    return trainingDay;
  }

  Future<DatabaseTrainingDay> getTrainingDayByName(
      {required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final trainingDays = await db.query(
      trainingDaysTable,
      limit: 1,
      where: "$dayNameColumn = ?",
      whereArgs: [name],
    );
    if (trainingDays.isEmpty) {
      throw CouldNotFindInDb();
    } else {
      final trainingDay = DatabaseTrainingDay.fromRow(trainingDays.first);
      return trainingDay;
    }
  }

  Future<List<DatabaseTrainingDay>> getTrainingDaysFromPlan() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final trainingDays = await db.query(
      trainingDaysTable,
      where: "$isFromPlanColumn = ?",
      whereArgs: [1],
    );

    return trainingDays
        .map((dayRow) => DatabaseTrainingDay.fromRow(dayRow))
        .toList();
  }

  Future<List<DatabaseTrainingDay>> getTrainingDaysNotFromPlan() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final trainingDays = await db.query(
      trainingDaysTable,
      where: "$isFromPlanColumn = ?",
      whereArgs: [0],
    );

    return trainingDays
        .map((dayRow) => DatabaseTrainingDay.fromRow(dayRow))
        .toList();
  }

  Future<List<DatabaseTrainingDay>> getTrainingDays() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final trainingDays = await db.query(trainingDaysTable);

    return trainingDays
        .map((dayRow) => DatabaseTrainingDay.fromRow(dayRow))
        .toList();
  }

  Future<void> updateTrainingDayByName({required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    //mozna ew stworzyc geter z id i updateowac po id

    final updatesCount = await db.update(
      trainingDaysTable,
      {
        dayNameColumn: name,
      },
      where: "$dayNameColumn = ?",
      whereArgs: [name],
    );

    if (updatesCount == 0) {
      throw CouldNotUpdateInDb();
    }
  }

  Future<void> deleteTrainingDayByName({required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      trainingDaysTable,
      where: "$dayNameColumn = ?",
      whereArgs: [name],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteFromDb();
    }
  }

  Future<bool> checkIfThereIsPlanInRestoredDB() async {
    final days = await getTrainingDaysFromPlan();
    if (days.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateTrainingDayFromTomorrowToEndOfDates(
      TrainingDayData trainingDay) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowString = tomorrow.toIso8601String().split('T')[0];

    // 1. Pobierz wszystkie daty od jutra do końca z tabeli `dates`
    final datesToRemove = await db.query(
      datesTable,
      where: "$digitDateColumn >= ? AND $dayColumn = ?",
      whereArgs: [
        tomorrowString,
        trainingDay.name
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
      await db.delete(
        setsTable,
        where:
            "$exerciseIdColumn IN (SELECT $idColumn FROM $exercisesTable WHERE $dateIdColumn = ?)",
        whereArgs: [dateId],
      );

      // Usuń ćwiczenia dla danej daty
      await db.delete(
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
        if (exercise.infoId == null &&
            exercise.name != null &&
            exercise.muscleGroup != null &&
            exercise.type != null) {
          //uzytkownik wpisal wlasne cwiczenie
          // sprawdzenie czy wpisane cwiczenie znajduje sie juz w bazie
          final result = await checkIfExerciseInfoExistAndReturn(
            name: exercise.name!,
            type: exercise.type!,
            muscleGroup: exercise.muscleGroup!,
          );
          if (result == null) {
            //nie ma w bazie wiec tworzymy i dodajemy stworzone
            final info = await createExerciseInfo(
              name: exercise.name!,
              type: exercise.type!,
              muscleGroup: exercise.muscleGroup!,
            );
            await db.insert(exercisesTable, {
              dateIdColumn: dateId,
              exerciseInfoIdColumn: info.id,
            });
          } else {
            // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
            await db.insert(exercisesTable, {
              dateIdColumn: dateId,
              exerciseInfoIdColumn: result.id,
            });
          }
        } else if (exercise.infoId != null) {
          //uzytkownik wybral cwiczenie z listy
          await db.insert(exercisesTable, {
            dateIdColumn: dateId,
            exerciseInfoIdColumn: exercise.infoId,
          });
        }
      }
    }
  }

  ////////////////////////////////////////////////////////////////
  //training days
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //training day exercises
  ////////////////////////////////////////////////////////////////

  Future<DatabaseTrainingDayExercise> createTrainingDayExercise(
      {required int trainingDayId, required int exerciseInfoId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exerciseId = await db.insert(trainingDayExercisesTable, {
      trainingDayIdColumn: trainingDayId,
      exerciseInfoIdColumn: exerciseInfoId,
    });

    final exercise = DatabaseTrainingDayExercise(
      id: exerciseId,
      trainingDayId: trainingDayId,
      exerciseInfoId: exerciseInfoId,
    );

    return exercise;
  }

  Future<List<DatabaseTrainingDayExercise>>
      getTrainingDayExercisesByTrainingDayId(
          {required int trainingDayId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbExercises = await db.query(
      trainingDayExercisesTable,
      where: "$trainingDayIdColumn = ?",
      whereArgs: [trainingDayId],
    );

    return dbExercises
        .map((exerciseRow) => DatabaseTrainingDayExercise.fromRow(exerciseRow))
        .toList();
  }

  Future<void> deleteTrainingDayExercisesByTrainingDayId(
      {required int trainingDayId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await db.delete(
      trainingDayExercisesTable,
      where: "$trainingDayIdColumn = ?",
      whereArgs: [trainingDayId],
    );
    //pytanie czy to powinno sie zawsze wywolywac w metodach jesli mamy pusta liste cwiczen
    //wczesniej rzucalem wyjatek jesli liczba usunietych jest 0 - zmuszalo mnie to do ominiecia takiej sytaucji
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //training day exercises
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //training day data
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<void> saveTrainingDayData(
      TrainingDayData trainingDayData, bool isFromPlan) async {
    final dbTrainingDay = await createTrainingDay(
        name: trainingDayData.name, isFromPlan: isFromPlan);

    for (var exercise in trainingDayData.exercises) {
      if (exercise.infoId == null &&
          exercise.name != null &&
          exercise.type != null &&
          exercise.muscleGroup != null) {
        //uzytkownik wpisal wlasne cwiczenie
        final result = await checkIfExerciseInfoExistAndReturn(
          name: exercise.name!,
          type: exercise.type!,
          muscleGroup: exercise.muscleGroup!,
        );
        if (result == null) {
          //nie ma w bazie wiec tworzymy i dodajemy stworzone
          final info = await createExerciseInfo(
            name: exercise.name!,
            type: exercise.type!,
            muscleGroup: exercise.muscleGroup!,
          );
          await createTrainingDayExercise(
              trainingDayId: dbTrainingDay.id, exerciseInfoId: info.id);
        } else {
          // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
          await createTrainingDayExercise(
              trainingDayId: dbTrainingDay.id, exerciseInfoId: result.id);
        }
      } else if (exercise.infoId != null) {
        //uzytkownik wybral cwiczenie z listy(lub nie zmodyfikowal - sytuacja (cos,cos,cos))
        //zalozenie: nie mozna modyfikowac name, type, ... w exerciseData - operujemy tylko na id
        await createTrainingDayExercise(
            trainingDayId: dbTrainingDay.id, exerciseInfoId: exercise.infoId!);
      }
    }
  }

  Future<void> editTrainingDayData(
      TrainingDayData trainingDay, String currentName) async {
    final dbDay = await getTrainingDayByName(name: currentName);

    await deleteTrainingDayExercisesByTrainingDayId(trainingDayId: dbDay.id);

    for (var newExercise in trainingDay.exercises) {
      if (newExercise.infoId == null &&
          newExercise.name != null &&
          newExercise.muscleGroup != null &&
          newExercise.type != null) {
        //uzytkownik wpisal wlasne cwiczenie
        final result = await checkIfExerciseInfoExistAndReturn(
          name: newExercise.name!,
          type: newExercise.type!,
          muscleGroup: newExercise.muscleGroup!,
        );
        if (result == null) {
          //nie ma w bazie wiec tworzymy i dodajemy stworzone
          final info = await createExerciseInfo(
            name: newExercise.name!,
            type: newExercise.type!,
            muscleGroup: newExercise.muscleGroup!,
          );
          await createTrainingDayExercise(
              trainingDayId: dbDay.id, exerciseInfoId: info.id);
        } else {
          // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
          await createTrainingDayExercise(
              trainingDayId: dbDay.id, exerciseInfoId: result.id);
        }
      } else if (newExercise.infoId != null) {
        //uzytkownik wybral cwiczenie z listy lub nie modyfikowal
        await createTrainingDayExercise(
            trainingDayId: dbDay.id, exerciseInfoId: newExercise.infoId!);
      }
    }

    await updateTrainingDayByName(name: trainingDay.name);

    //jesli wiemy z jakiego dnia pochodza cwiczenia, a znamy zawsze bo nazwy dni sa unikatowe
    //to mozemy usunac cwiczenia danego dnia a potem dodac nowe przeslane w data (zawsze przysylamy wszystkie)

    //problem by byl jesli chcielibysmy edytowac cwiczenie bez konkretnego dnia treningowego
    //co jest sprzeczne z zamiarem tabeli TRAINING_DAY_exercises
  }

  Future<void> deleteTrainingDayDataByName(
      TrainingDayData trainingDayData) async {
    final day = await getTrainingDayByName(name: trainingDayData.name);
    if (trainingDayData.exercises.isNotEmpty) {
      await deleteTrainingDayExercisesByTrainingDayId(trainingDayId: day.id);
    }
    await deleteTrainingDayByName(name: trainingDayData.name);
  }

  Future<void> deleteTrainingDaysDataFromPlan() async {
    final days = await getTrainingDaysFromPlan();

    for (var day in days) {
      await deleteTrainingDayExercisesByTrainingDayId(trainingDayId: day.id);
      await deleteTrainingDayByName(name: day.name);
    }
  }

  Future<List<TrainingDayData>> getTrainingDaysFromPlanData() async {
    final days = await getTrainingDaysFromPlan();

    List<TrainingDayData> data = [];
    for (var day in days) {
      final dbExercises =
          await getTrainingDayExercisesByTrainingDayId(trainingDayId: day.id);

      List<ExerciseData> exercises = [];
      for (var dbExericse in dbExercises) {
        final info = await getExerciseInfo(id: dbExericse.exerciseInfoId);
        exercises.add(ExerciseData(
          name: info.name,
          type: info.type,
          muscleGroup: info.muscleGroup,
          infoId: dbExericse.exerciseInfoId,
        )); //wszystkie training Day exercises maja exercise info id
        //wiec kiedy zwracam exercise data to musi miec ID (dodaje nazwy i cala reszte aby nie trzeba bylo tego robic w ui)
      }

      data.add(TrainingDayData(name: day.name, exercises: exercises));
    }
    return data;
  }

  Future<List<TrainingDayData>> getTrainingDaysNotFromPlanData() async {
    final days = await getTrainingDaysNotFromPlan();

    List<TrainingDayData> data = [];
    for (var day in days) {
      final dbExercises =
          await getTrainingDayExercisesByTrainingDayId(trainingDayId: day.id);

      List<ExerciseData> exercises = [];
      for (var dbExericse in dbExercises) {
        final info = await getExerciseInfo(id: dbExericse.exerciseInfoId);
        exercises.add(ExerciseData(
          name: info.name,
          type: info.type,
          muscleGroup: info.muscleGroup,
          infoId: dbExericse.exerciseInfoId,
        ));
      }

      data.add(TrainingDayData(name: day.name, exercises: exercises));
    }
    return data;
  }

  Future<List<TrainingDayData>> getTrainingDaysData() async {
    final days = await getTrainingDays();
    log("$days");
    List<TrainingDayData> data = [];
    for (var day in days) {
      final dbExercises =
          await getTrainingDayExercisesByTrainingDayId(trainingDayId: day.id);

      List<ExerciseData> exercises = [];
      for (var dbExericse in dbExercises) {
        final info = await getExerciseInfo(id: dbExericse.exerciseInfoId);
        exercises.add(ExerciseData(
          name: info.name,
          type: info.type,
          muscleGroup: info.muscleGroup,
          infoId: dbExericse.exerciseInfoId,
        ));
      }

      data.add(TrainingDayData(
          name: day.name, exercises: exercises, isFromPlan: day.isFromPlan));
    }
    return data;
  }

  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //training day data
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  //charts data
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////

  Future<MySnapshotData> getWeeklySnapshotData() async {
    final now = DateTime.now();
    double volume = 0;
    int workouts = 0;

    final DateTime startDate, endDate;

    startDate = now;
    endDate = now.subtract(Duration(days: ((startDate.weekday + 7) % 7) - 1));

    final rangeDates =
        await getDatesFromBetweenTwoDatesBackInTime(startDate, endDate);

    for (var date in rangeDates) {
      final exercises = await getExercisesForDate(dateId: date.id);
      for (var exercise in exercises) {
        final sets = await getSetsForExercise(exerciseId: exercise.id);
        for (var oneSet in sets) {
          volume += (oneSet.reps * oneSet.weight);
        }
      }
    }

    String startDateDigitDate = startDate.toIso8601String().split('T')[0];
    String endDateDigitDate = endDate.toIso8601String().split('T')[0];

    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.rawQuery('''
    SELECT $datesTable.$digitDateColumn, 
           COUNT($setsTable.$idColumn) AS valid_sets_count
    FROM $datesTable
    JOIN $exercisesTable ON $datesTable.$idColumn = $exercisesTable.$dateIdColumn
    JOIN $setsTable ON $exercisesTable.$idColumn = $setsTable.$exerciseIdColumn
    WHERE $datesTable.$digitDateColumn BETWEEN ? AND ?
      AND ($setsTable.$repsColumn > 0 OR $setsTable.$durationColumn > 0 OR $setsTable.$weightColumn > 0)
    GROUP BY $datesTable.$digitDateColumn
  ''', [endDateDigitDate, startDateDigitDate]);

    workouts = result.length;
    return MySnapshotData(workouts: workouts, volume: volume);
  }

  Future<List<VolumeChartData>> getVolumeChartData(int range) async {
    final List<VolumeChartData> dataList = [];
    const weekInterval = 7;
    const int numberOfDaysInWeek = 7;
    const int numberOfDaysInMonth = 30;
    const int numberOfDaysInThreeMonts = 90;
    final now = DateTime.now();

    final int numberOfIterations;

    if (range == numberOfDaysInWeek) {
      numberOfIterations = 7;
    } else if (range == numberOfDaysInMonth) {
      numberOfIterations = 4;
    } else if (range == numberOfDaysInThreeMonts) {
      numberOfIterations = 12;
    } else {
      return [];
    }

    if (range == numberOfDaysInWeek) {
      for (var i = 0; i < numberOfIterations; i++) {
        double volume = 0;
        final date = now.subtract(Duration(days: i));
        final rangeDates =
            await getDatesFromBetweenTwoDatesBackInTime(date, date);
        for (var date in rangeDates) {
          final exercises = await getExercisesForDate(dateId: date.id);
          for (var exercise in exercises) {
            final sets = await getSetsForExercise(exerciseId: exercise.id);
            for (var oneSet in sets) {
              volume += (oneSet.reps * oneSet.weight);
            }
          }
        }
        dataList.add(VolumeChartData(
            volume: volume.round(), bottomTitle: "${date.weekday}"));
      }
    } else {
      for (var i = 0; i < numberOfIterations; i++) {
        double volume = 0;
        final DateTime startDate, endDate;

        if (i == 0) {
          startDate = now;
          endDate =
              now.subtract(Duration(days: ((startDate.weekday + 7) % 7) - 1));
        } else {
          startDate = now.subtract(Duration(
              days: ((i - 1) * weekInterval) +
                  (((now.weekday + 7) % 7) - 1) +
                  1));
          endDate = startDate.subtract(const Duration(days: 6));
        }

        final rangeDates =
            await getDatesFromBetweenTwoDatesBackInTime(startDate, endDate);

        for (var date in rangeDates) {
          final exercises = await getExercisesForDate(dateId: date.id);
          for (var exercise in exercises) {
            final sets = await getSetsForExercise(exerciseId: exercise.id);
            for (var oneSet in sets) {
              volume += (oneSet.reps * oneSet.weight);
            }
          }
        }

        String bottomTitle = startDate.month.toString();
        dataList.add(
            VolumeChartData(volume: volume.round(), bottomTitle: bottomTitle));
      }
    }

    final reservedDataList = dataList.reversed.toList();
    return reservedDataList;
  }

  Future<Map<String, int>> getMuscleChartData(
      //TODO: ogarnąć co z plankiem np, ew małe ikonki i do wykresów
      List<String> muscleGroups,
      int range) async {
    Map<String, int> data = {};
    const rangeOfAllTime = -1;

    final List<DatabaseDate> rangeDates;
    if (range == rangeOfAllTime) {
      rangeDates = await getAllDates();
    } else {
      rangeDates = await getDatesFromTodayInSomeRangeBackInTime(range);
    }

    for (var muscleGroup in muscleGroups) {
      List<DatabaseExercise> wantedExercises = [];

      final wantedExerciseInfos =
          await getExerciseInfosByMuscleGroup(muscleGroup);
      for (var date in rangeDates) {
        final allExercisesInDate = await getExercisesForDate(dateId: date.id);
        //log("number of Exercises in ${date.digitDate}: ${allExercisesInDate.length}");
        for (var exerciseInDate in allExercisesInDate) {
          bool containsId = wantedExerciseInfos
              .any((info) => info.id == exerciseInDate.exerciseInfoId);
          if (containsId) {
            //log("\nnow muscle is : $muscleGroup, looking for exercises engaging this muscle in date ${date.digitDate}: find exercise; ${exerciseInDate}, added to wantedExercises :)");
            wantedExercises.add(exerciseInDate);
          }
        }
      }

      List<DatabaseSet> wantedSets = [];

      for (var exercise in wantedExercises) {
        wantedSets.addAll(await getSetsForExercise(exerciseId: exercise.id));
      }

      int repsCount = 0;

      for (var wantedSet in wantedSets) {
        repsCount += wantedSet.reps;
      }

      data.putIfAbsent(muscleGroup, () => repsCount);
    }

    return data;
  }
}
