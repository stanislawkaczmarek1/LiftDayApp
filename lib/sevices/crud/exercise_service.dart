import 'dart:async';
import 'package:intl/intl.dart';
import 'package:liftday/constants/database.dart';
import 'package:liftday/sevices/crud/crud_exceptions.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/tables/database_date.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/sevices/crud/tables/database_exercise.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/crud/tables/database_set.dart';
import 'package:liftday/sevices/crud/tables/database_training_day.dart';
import 'package:liftday/sevices/crud/tables/database_training_day_exercise.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

//uzupelnic wszedzie muscle group

class ExerciseService {
  Database? _db;

  static final ExerciseService _shared = ExerciseService._sharedInstance();
  ExerciseService._sharedInstance();
  factory ExerciseService() => _shared;
  //singleton

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

  Future<DatabaseExerciseInfo?> checkIfExerciseInfoExistAndReturn(
      {required String name, required String type}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exercisesInfo = await db.query(
      exercisesInfoTable,
      limit: 1,
      where: "$nameColumn = ? AND $typeColumn = ?",
      whereArgs: [name, type],
    );
    if (exercisesInfo.isEmpty) {
      return null;
    } else {
      return DatabaseExerciseInfo.fromRow(exercisesInfo.first);
    }
  }

  Future<DatabaseExerciseInfo> createExerciseInfo(
      {required String name, required String type}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final exerciseInfoId = await db.insert(exercisesInfoTable, {
      nameColumn: name,
      typeColumn: type,
    });
    final exerciseInfo = DatabaseExerciseInfo(
      id: exerciseInfoId,
      name: name,
      type: type,
    );
    return exerciseInfo;
  }

  Future<DatabaseExerciseInfo> getExerciseInfo({required int id}) async {
    //wrzedzie gdzie uzywam tej metody zwaracm tylko id z bazy danych a powinienem tez z bazy cwiczen TO DO
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final exercisesInfo = await db.query(
      exercisesInfoTable,
      limit: 1,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (exercisesInfo.isEmpty) {
      throw CouldNotFindNote();
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
                exercise.type != null) {
              //uzytkownik wpisal wlasne cwiczenie
              // sprawdzenie czy wpisane cwiczenie znajduje sie juz w bazie
              final result = await checkIfExerciseInfoExistAndReturn(
                name: exercise.name!,
                type: exercise.type!,
              );
              if (result == null) {
                //nie ma w bazie wiec tworzymy i dodajemy stworzone
                final info = await createExerciseInfo(
                    name: exercise.name!, type: exercise.type!);
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
            } else if (exercise.infoId != null &&
                exercise.name == null &&
                exercise.type == null) {
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

  Future<DatabaseTrainingDay> createTrainingDay(
      {required String name, required bool isFromPlan}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final int trainingDayId;
    final int isFromPlanInt;
    if (isFromPlan) {
      isFromPlanInt = 1;
      trainingDayId = await db.insert(trainingDaysTable, {
        nameColumn: name,
      });
    } else {
      isFromPlanInt = 0;
      trainingDayId = await db.insert(trainingDaysTable, {
        nameColumn: name,
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
      where: "$nameColumn = ?",
      whereArgs: [name],
    );
    if (trainingDays.isEmpty) {
      throw CouldNotFindNote();
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
        nameColumn: name,
      },
      where: "name = ?",
      whereArgs: [name],
    );

    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    }
  }

  Future<void> deleteTrainingDayByName({required String name}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      trainingDaysTable,
      where: "$nameColumn = ?",
      whereArgs: [name],
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
    }
  }

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

  Future<void> saveTrainingDayData(
      TrainingDayData trainingDayData, bool isFromPlan) async {
    final dbTrainingDay = await createTrainingDay(
        name: trainingDayData.name, isFromPlan: isFromPlan);

    for (var exercise in trainingDayData.exercises) {
      if (exercise.infoId == null &&
          exercise.name != null &&
          exercise.type != null) {
        //uzytkownik wpisal wlasne cwiczenie
        final result = await checkIfExerciseInfoExistAndReturn(
          name: exercise.name!,
          type: exercise.type!,
        );
        if (result == null) {
          //nie ma w bazie wiec tworzymy i dodajemy stworzone
          final info = await createExerciseInfo(
              name: exercise.name!, type: exercise.type!);
          await createTrainingDayExercise(
              trainingDayId: dbTrainingDay.id, exerciseInfoId: info.id);
        } else {
          // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
          await createTrainingDayExercise(
              trainingDayId: dbTrainingDay.id, exerciseInfoId: result.id);
        }
      } else if (exercise.infoId != null &&
          exercise.name == null &&
          exercise.type == null) {
        //uzytkownik wybral cwiczenie z listy
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
          newExercise.type != null) {
        //uzytkownik wpisal wlasne cwiczenie
        //TO DO SPrawdzenie
        final result = await checkIfExerciseInfoExistAndReturn(
          name: newExercise.name!,
          type: newExercise.type!,
        );
        if (result == null) {
          //nie ma w bazie wiec tworzymy i dodajemy stworzone
          final info = await createExerciseInfo(
              name: newExercise.name!, type: newExercise.type!);
          await createTrainingDayExercise(
              trainingDayId: dbDay.id, exerciseInfoId: info.id);
        } else {
          // jest w bazie wiec nie tworzymy drugiego i dodajemy to ktore jest
          await createTrainingDayExercise(
              trainingDayId: dbDay.id, exerciseInfoId: result.id);
        }
      } else if (newExercise.infoId != null &&
          newExercise.name == null &&
          newExercise.type == null) {
        //uzytkownik wybral cwiczenie z listy
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
        exercises.add(ExerciseData(
          name: null,
          type: null,
          infoId: dbExericse.id,
        )); //wszystkie training Day exercises maja exercise info id
        //wiec kiedy zwracam exercise data to musi miec tylko ID (mozna by ogarnac zwracanie List<DatabaseExerciseInfo> zamiast tego)
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
        exercises.add(ExerciseData(
          name: null,
          type: null,
          infoId: dbExericse.id,
        ));
      }

      data.add(TrainingDayData(name: day.name, exercises: exercises));
    }
    return data;
  }

  Future<List<TrainingDayData>> getTrainingDaysData() async {
    final days = await getTrainingDays();

    List<TrainingDayData> data = [];
    for (var day in days) {
      final dbExercises =
          await getTrainingDayExercisesByTrainingDayId(trainingDayId: day.id);

      List<ExerciseData> exercises = [];
      for (var dbExericse in dbExercises) {
        exercises.add(ExerciseData(
          name: null,
          type: null,
          infoId: dbExericse.id,
        ));
      }

      data.add(TrainingDayData(
          name: day.name, exercises: exercises, isFromPlan: day.isFromPlan));
    }
    return data;
  }

  Future<List<DatabaseExercise>> createExercisesFromTrainingDayInGivenDate({
    required TrainingDayData trainingDay,
    required int dateId,
  }) async {
    List<DatabaseExercise> exercises = [];

    for (var i = 0; i < trainingDay.exercises.length; i++) {
      final exerciseInfoId = trainingDay.exercises.elementAt(i).infoId;
      if (exerciseInfoId != null) {
        //nie moze byc null bo w radio liscie sa ExerciseData w takim formacie (null, null, id)
        exercises.add(await createExercise(
            dateId: dateId, exerciseInfoId: exerciseInfoId));
      }
    }

    return exercises;
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
            exercise.type != null) {
          //uzytkownik wpisal wlasne cwiczenie
          // sprawdzenie czy wpisane cwiczenie znajduje sie juz w bazie
          final result = await checkIfExerciseInfoExistAndReturn(
            name: exercise.name!,
            type: exercise.type!,
          );
          if (result == null) {
            //nie ma w bazie wiec tworzymy i dodajemy stworzone
            final info = await createExerciseInfo(
                name: exercise.name!, type: exercise.type!);
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
        } else if (exercise.infoId != null &&
            exercise.name == null &&
            exercise.type == null) {
          //uzytkownik wybral cwiczenie z listy
          await db.insert(exercisesTable, {
            dateIdColumn: dateId,
            exerciseInfoIdColumn: exercise.infoId,
          });
        }
      }
    }
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

  Future<DatabaseExercise?> getExerciseByDateAndInfoId(
      //potencjalny problem z duplikatami
      {required int dateId,
      required int infoId}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      exercisesTable,
      limit: 1,
      where: "$dateIdColumn = ? AND $exerciseInfoIdColumn = ?",
      whereArgs: [dateId, infoId],
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

  Future<DatabaseSet> createDurationSet(
      {required int exerciseId,
      required int setIndex,
      required int weight,
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

  Future<DatabaseSet?> updateSet({
    required DatabaseSet setToUpdate,
    required int? weight,
    required int? reps,
    required int? duration,
  }) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final updates = <String, Object?>{};
    if (weight != null) {
      updates[weightColumn] = weight;
    } else {
      updates[weightColumn] = 0;
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

  Future<String?> getPreviousRepsSetData(
      int dateId, int exerciseInfoId, int setIndex) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.rawQuery('''
    SELECT s.weight, s.reps
    FROM $setsTable s
    JOIN $exercisesTable e ON e.id = s.exercise_id
    JOIN $datesTable d ON d.id = e.date_id
    WHERE d.id < ? AND e.$exerciseInfoIdColumn = ? AND s.set_index = ?
    ORDER BY d.id DESC
    LIMIT 1;
  ''', [dateId, exerciseInfoId, setIndex]);

    if (result.isNotEmpty) {
      final set = result.first;
      final weight = set['weight'];
      final reps = set['reps'];
      return '$weight x $reps';
    } else {
      return null;
    }
  }

  Future<String?> getPreviousDurationSetData(
      int dateId, int exerciseInfoId, int setIndex) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.rawQuery('''
    SELECT s.weight, s.duration
    FROM $setsTable s
    JOIN $exercisesTable e ON e.id = s.exercise_id
    JOIN $datesTable d ON d.id = e.date_id
    WHERE d.id < ? AND e.$exerciseInfoIdColumn = ? AND s.set_index = ?
    ORDER BY d.id DESC
    LIMIT 1;
  ''', [dateId, exerciseInfoId, setIndex]);

    if (result.isNotEmpty) {
      final set = result.first;
      final weight = set['weight'];
      final duration = set['duration'];
      return '$weight x ${duration}s';
    } else {
      return null;
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
      await db.execute(createExercisesInfoTable);
      await db.execute(createExerciseTable);
      await db.execute(createSetsTable);
      await db.execute(createTrainingDaysTable);
      await db.execute(createTrainingDayExercisesTable);

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
