const dbName = 'app_database.db';
const datesTable = 'dates';
const exercisesTable = 'exercises';
const setsTable = 'sets';
const trainingDaysTable = 'training_days';
const idColumn = 'id';
const digitDateColumn = 'digit_date';
const dayColumn = 'day';
const dateIdColumn = 'date_id';
const nameColumn = 'name';
const exerciseIdColumn = 'exercise_id';
const setIndexColumn = 'set_index';
const weightColumn = 'weight';
const repsColumn = 'reps';
const exercisesColumn = 'exercises';
const isFromPlanColumn = 'is_from_plan';
const muscleGroupColumn = 'muscle_group';
const durationColumn = 'duration';
const typeColumn = 'type';
const createDatesTable = """CREATE TABLE IF NOT EXISTS "dates" (
	"id"	INTEGER NOT NULL,
	"digit_date"	TEXT NOT NULL UNIQUE,
	"day"	TEXT NOT NULL,
	PRIMARY KEY("id" AUTOINCREMENT)
);""";
const createExerciseTable = """CREATE TABLE IF NOT EXISTS "exercises" (
	"id"	INTEGER NOT NULL,
	"date_id"	INTEGER NOT NULL,
	"name"	TEXT NOT NULL,
	"type"	TEXT NOT NULL DEFAULT 'reps',
	FOREIGN KEY("date_id") REFERENCES "dates"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);""";
const createSetsTable = """CREATE TABLE IF NOT EXISTS "sets" (
	"id"	INTEGER NOT NULL,
	"exercise_id"	INTEGER NOT NULL,
	"set_index"	INTEGER NOT NULL,
	"weight"	INTEGER NOT NULL,
	"reps"	INTEGER NOT NULL,
  "duration"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("exercise_id") REFERENCES "exercises"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);""";
const createTrainingDaysTable = """CREATE TABLE IF NOT EXISTS "training_days" (
	"id"	INTEGER NOT NULL,
	"day"	TEXT NOT NULL UNIQUE,
	"exercises"	TEXT NOT NULL,
  "is_from_plan"	INTEGER NOT NULL DEFAULT 1,
	PRIMARY KEY("id" AUTOINCREMENT)
);""";


//"muscle_group"	TEXT NOT NULL,