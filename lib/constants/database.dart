const dbName = 'liftday_database.db';
const datesTable = 'dates';
const exercisesTable = 'exercises';
const setsTable = 'sets';
const trainingDaysTable = 'training_days';
const trainingDayExercisesTable = 'training_day_exercises';
const exercisesInfoTable = 'exercises_info';
const idColumn = 'id';
const digitDateColumn = 'digit_date';
const dayColumn = 'day';
const dateIdColumn = 'date_id';
const dayNameColumn = 'day_name';
const exerciseIdColumn = 'exercise_id';
const setIndexColumn = 'set_index';
const weightColumn = 'weight';
const repsColumn = 'reps';
const isFromPlanColumn = 'is_from_plan';
const muscleGroupColumn = 'muscle_group';
const durationColumn = 'duration';
const typeColumn = 'type';
const trainingDayIdColumn = 'training_day_id';
const exerciseInfoIdColumn = 'exercise_info_id';
const isArchivedColumn = 'is_archived';
const createDatesTable = """CREATE TABLE IF NOT EXISTS "$datesTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$digitDateColumn"	TEXT NOT NULL UNIQUE,
	"$dayColumn"	TEXT NOT NULL,
	PRIMARY KEY("$idColumn" AUTOINCREMENT)
);""";
const createExerciseTable = """CREATE TABLE IF NOT EXISTS "$exercisesTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$dateIdColumn"	INTEGER NOT NULL,
	"$exerciseInfoIdColumn" INTEGER NOT NULL,
	FOREIGN KEY("$exerciseInfoIdColumn") REFERENCES "$exercisesTable"("$idColumn"),
	FOREIGN KEY("$dateIdColumn") REFERENCES "$datesTable"("$idColumn"),
	PRIMARY KEY("$idColumn" AUTOINCREMENT)
);""";
const createSetsTable = """CREATE TABLE IF NOT EXISTS "$setsTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$exerciseIdColumn"	INTEGER NOT NULL,
	"$setIndexColumn"	INTEGER NOT NULL,
	"$weightColumn"	REAL NOT NULL,
	"$repsColumn"	INTEGER NOT NULL,
  "$durationColumn"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("$exerciseIdColumn") REFERENCES "$exercisesTable"("$idColumn"),
	PRIMARY KEY("$idColumn" AUTOINCREMENT)
);""";
const createTrainingDaysTable =
    """CREATE TABLE IF NOT EXISTS "$trainingDaysTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$dayNameColumn"	TEXT NOT NULL UNIQUE,
  "$isFromPlanColumn"	INTEGER NOT NULL DEFAULT 1,
	PRIMARY KEY("$idColumn" AUTOINCREMENT)
);""";
const createTrainingDayExercisesTable =
    """CREATE TABLE IF NOT EXISTS "$trainingDayExercisesTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$trainingDayIdColumn"	INTEGER NOT NULL,
  "$exerciseInfoIdColumn" INTEGER NOT NULL,
	FOREIGN KEY("$exerciseInfoIdColumn") REFERENCES "$exercisesInfoTable"("$idColumn"),
	FOREIGN KEY("$trainingDayIdColumn") REFERENCES "$trainingDaysTable"("$idColumn"),
	PRIMARY KEY("$idColumn" AUTOINCREMENT)
);""";

const createExercisesInfoTable =
    """CREATE TABLE IF NOT EXISTS "$exercisesInfoTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$dayNameColumn"	TEXT NOT NULL,
	"$typeColumn"	TEXT NOT NULL DEFAULT 'reps',
  "$muscleGroupColumn"	TEXT NOT NULL,
  "$isArchivedColumn"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("$idColumn" AUTOINCREMENT)
);""";
