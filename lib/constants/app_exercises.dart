import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

DatabaseExerciseInfo? getAppExerciseById(int id) {
  final List<DatabaseExerciseInfo> appExercises;

  SettingsService settingsService = SettingsService();
  if (settingsService.language() == "pl") {
    appExercises = appExercisesPl;
  } else {
    appExercises = appExercisesEn;
  }

  for (var exercise in appExercises) {
    if (exercise.id == id) {
      return exercise;
    }
  }
  return null;
}

final List<DatabaseExerciseInfo> appExercisesEn = [
  // Chest exercises
  DatabaseExerciseInfo(id: -1, name: "bench press", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -2, name: "incline bench press", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -3, name: "decline bench press", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -4, name: "dumbbell bench press", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -5, name: "incline dumbbell press", muscleGroup: "chest"),
  DatabaseExerciseInfo(id: -6, name: "dumbbell flyes", muscleGroup: "chest"),
  DatabaseExerciseInfo(id: -7, name: "pec deck flyes", muscleGroup: "chest"),
  DatabaseExerciseInfo(id: -8, name: "cable flyes", muscleGroup: "chest"),
  DatabaseExerciseInfo(id: -9, name: "push-ups", muscleGroup: "chest"),
  DatabaseExerciseInfo(id: -10, name: "chest dips", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -11, name: "chest press machine", muscleGroup: "chest"),

  // Back exercises
  DatabaseExerciseInfo(id: -1001, name: "pull-ups", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1002, name: "chin-ups", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1003, name: "neutral grip pull-ups", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1004, name: "inverted rows", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1005, name: "lat pulldown", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1006, name: "barbell rows", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1007, name: "one-arm dumbbell row", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1008, name: "machine rows", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1009, name: "cable rows", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1010, name: "single-arm cable row", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1011, name: "straight-arm pulldown", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1012, name: "t-bar row", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1013, name: "nautilus pullover", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1014, name: "shrugs", muscleGroup: "back"),

  // Arm exercises
  // Biceps
  DatabaseExerciseInfo(
      id: -2001, name: "dumbbell curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -2002, name: "barbell curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -2003, name: "hammer curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2004, name: "incline dumbbell curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2005, name: "preacher curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -2006, name: "machine curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -2007, name: "cable curls", muscleGroup: "biceps"),
  // Triceps
  DatabaseExerciseInfo(id: -2501, name: "french press", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2502, name: "single-arm french press", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2503,
      name: "tricep pushdown with overhand grip",
      muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2504, name: "tricep pushdown with rope", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2505, name: "overhead tricep extension", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2506, name: "diamond push-ups", muscleGroup: "triceps"),
  DatabaseExerciseInfo(id: -2507, name: "tricep dips", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2508, name: "close-grip bench press", muscleGroup: "triceps"),

  // Shoulder exercises
  DatabaseExerciseInfo(
      id: -3001, name: "lateral raises", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3002, name: "machine lateral raises", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3003, name: "cable lateral raises", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3004,
      name: "lateral raises on incline bench",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3005, name: "overhead press (ohp)", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3006, name: "arnold press", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(id: -3007, name: "face pull", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3008, name: "cable crossover", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3009, name: "dumbbell reverse fly", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3010, name: "machine reverse fly", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3011, name: "landmine press", muscleGroup: "shoulders"),

  // Leg exercises
  DatabaseExerciseInfo(
      id: -4001, name: "barbell squat", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4002, name: "front squat", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4003, name: "bulgarian split squat", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4004, name: "goblet squat", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(id: -4005, name: "lunges", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4006, name: "leg extension machine", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(id: -4007, name: "leg press", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4008, name: "hack squat", muscleGroup: "quadriceps"),

  DatabaseExerciseInfo(id: -4301, name: "deadlift", muscleGroup: "hamstrings"),
  DatabaseExerciseInfo(
      id: -4302, name: "sumo deadlift", muscleGroup: "hamstrings"),
  DatabaseExerciseInfo(
      id: -4303, name: "romanian deadlift", muscleGroup: "hamstrings"),
  DatabaseExerciseInfo(
      id: -4304, name: "leg curl machine", muscleGroup: "hamstrings"),

  DatabaseExerciseInfo(id: -4601, name: "hip thrust", muscleGroup: "glutes"),

  // Core exercises
  DatabaseExerciseInfo(id: -5001, name: "cable crunches", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5002, name: "plank", muscleGroup: "core", type: "duration"),
  DatabaseExerciseInfo(id: -5003, name: "russian twists", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5004, name: "hanging leg raises", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5005, name: "lying leg raises", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5006, name: "ab wheel", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5007, name: "front lever", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5008, name: "l-sit", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5009, name: "hollow body hold", muscleGroup: "core"),
];
//na razie bez innych

final List<DatabaseExerciseInfo> appExercisesPl = [
  // Ćwiczenia na klatkę piersiową
  DatabaseExerciseInfo(
      id: -1, name: "wyciskanie na ławce płaskiej", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -2, name: "wyciskanie na ławce skośnej", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -3, name: "wyciskanie na ławce ujemnej", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -4,
      name: "wyciskanie hantli na ławce płaskiej",
      muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -5, name: "wyciskanie hantli na ławce skośnej", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -6, name: "rozpiętki hantlami na ławce", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -7, name: "rozpiętki na maszynie", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -8, name: "rozpiętki na bramie", muscleGroup: "chest"),
  DatabaseExerciseInfo(id: -9, name: "pompki", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -10, name: "dipy na klatkę piersiową", muscleGroup: "chest"),
  DatabaseExerciseInfo(
      id: -11, name: "wyciskanie na maszynie", muscleGroup: "chest"),

  // Ćwiczenia na plecy
  DatabaseExerciseInfo(
      id: -1001, name: "podciąganie nachwytem", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1002, name: "podciąganie podchwytem", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1003, name: "podciąganie chwytem neutralnym", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1004, name: "podciąganie australijskie", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1005, name: "ściąganie drążka wyciągu górnego", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1006, name: "wiosłowanie sztangą", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1007, name: "wiosłowanie jednorącz hantlem", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1008, name: "wiosłowanie na maszynie", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1009, name: "wiosłowanie na wyciągu", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1010, name: "wiosłowanie jednorącz na wyciągu", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1011, name: "narciarz na wyciągu", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1012, name: "wiosłowanie t-bar", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -1013, name: "nautilus pullover", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -1014, name: "szrugsy", muscleGroup: "back"),

  // Ćwiczenia na ramiona
  //biceps
  DatabaseExerciseInfo(
      id: -2001, name: "uginanie ramion z hantlami", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2002, name: "uginanie ramion ze sztangą", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2003, name: "uginanie ramion młotkowo", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2004,
      name: "uginanie ramion na ławce skośnej",
      muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2005,
      name: "uginanie ramion na modlitewniku",
      muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2006, name: "uginanie ramion na maszynie", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -2007, name: "uginanie ramion z linką", muscleGroup: "biceps"),
  //triceps
  DatabaseExerciseInfo(
      id: -2501, name: "wyciskanie francuskie", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2502,
      name: "wyciskanie francuskie jednorącz",
      muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2503, name: "wyprosty ramion nachwytem", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2504, name: "wyprosty ramion liną", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2505,
      name: "wyprosty ramion na lince nad głową",
      muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2506, name: "pompki diamentowe", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2507, name: "dipy na triceps", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -2508,
      name: "wyciskanie na ławce wąskim chwytem",
      muscleGroup: "triceps"),

  // Ćwiczenia na barki
  DatabaseExerciseInfo(
      id: -3001, name: "wznosy bokiem", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3002, name: "wznosy bokiem na maszynie", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3003, name: "wznosy bokiem na lince", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3004,
      name: "wznosy bokiem leżąc na ławce skośnej",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3005,
      name: "wyciskanie żołnierskie (ohp)",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(id: -3006, name: "arnoldki", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(id: -3007, name: "face pull", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3008,
      name: "krzyżowanie linek wyciągu górnego",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3009, name: "odwrotne rozpiętki hantlami", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3010,
      name: "odwrotne rozpiętki na maszynie",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -3011, name: "wyciskanie landmine", muscleGroup: "shoulders"),

  // Ćwiczenia na nogi
  //Czworoglowe
  DatabaseExerciseInfo(
      id: -4001, name: "przysiad ze sztangą", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4002, name: "przysiad przedni", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4003, name: "przysiad bułgarski", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4004, name: "goblet squat", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(id: -4005, name: "wykroki", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4006, name: "maszyna na czworogłowe", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4007, name: "prostowanie nóg na suwnicy", muscleGroup: "quadriceps"),
  DatabaseExerciseInfo(
      id: -4008, name: "przysiad na hack maszynie", muscleGroup: "quadriceps"),
  //Dwuglowe
  DatabaseExerciseInfo(
      id: -4301, name: "martwy ciąg", muscleGroup: "hamstrings"),
  DatabaseExerciseInfo(
      id: -4302, name: "martwy ciąg sumo", muscleGroup: "hamstrings"),
  DatabaseExerciseInfo(
      id: -4303, name: "rumuński martwy ciąg", muscleGroup: "hamstrings"),
  DatabaseExerciseInfo(
      id: -4304, name: "maszyna na dwugłowe", muscleGroup: "hamstrings"),
  //Posladki
  DatabaseExerciseInfo(id: -4601, name: "hip-thrusty", muscleGroup: "glutes"),

  // Ćwiczenia na core
  DatabaseExerciseInfo(id: -5001, name: "allahy", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5002, name: "plank", muscleGroup: "core", type: "duration"),
  DatabaseExerciseInfo(
      id: -5003, name: "rosyjskie skręty", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5004, name: "wznosy nóg w zwisie", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -5005, name: "wznosy nóg leżąc", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5006, name: "kólko", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5007, name: "front lever", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5008, name: "l-sit", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -5009, name: "hollow body", muscleGroup: "core"),
];
