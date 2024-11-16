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
  DatabaseExerciseInfo(id: -101, name: "pull-ups", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -102, name: "chin-ups", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -103, name: "neutral grip pull-ups", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -104, name: "inverted rows", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -105, name: "lat pulldown", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -106, name: "barbell rows", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -107, name: "one-arm dumbbell row", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -108, name: "machine rows", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -109, name: "cable rows", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -110, name: "single-arm cable row", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -111, name: "straight-arm pulldown", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -112, name: "t-bar row", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -113, name: "nautilus pullover", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -114, name: "shrugs", muscleGroup: "back"),

  // Arm exercises
  // Biceps
  DatabaseExerciseInfo(id: -201, name: "dumbbell curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -202, name: "barbell curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -203, name: "hammer curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -204, name: "incline dumbbell curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -205, name: "preacher curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -206, name: "machine curls", muscleGroup: "biceps"),
  DatabaseExerciseInfo(id: -207, name: "cable curls", muscleGroup: "biceps"),
  // Triceps
  DatabaseExerciseInfo(id: -251, name: "french press", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -252, name: "single-arm french press", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -253,
      name: "tricep pushdown with overhand grip",
      muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -254, name: "tricep pushdown with rope", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -255, name: "overhead tricep extension", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -256, name: "diamond push-ups", muscleGroup: "triceps"),
  DatabaseExerciseInfo(id: -257, name: "tricep dips", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -258, name: "close-grip bench press", muscleGroup: "triceps"),

  // Shoulder exercises
  DatabaseExerciseInfo(
      id: -301, name: "lateral raises", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -302, name: "machine lateral raises", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -303, name: "cable lateral raises", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -304,
      name: "lateral raises on incline bench",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -305, name: "overhead press (ohp)", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -306, name: "arnold press", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(id: -307, name: "face pull", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -308, name: "cable crossover", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -309, name: "dumbbell reverse fly", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -310, name: "machine reverse fly", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -311, name: "landmine press", muscleGroup: "shoulders"),

  // Leg exercises
  DatabaseExerciseInfo(id: -401, name: "barbell squat", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -402, name: "front squat", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -403, name: "bulgarian split squat", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -404, name: "goblet squat", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -405, name: "lunges", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -406, name: "deadlift", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -407, name: "sumo deadlift", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -408, name: "romanian deadlift", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -409, name: "leg extension machine", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -410, name: "leg curl machine", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -411, name: "leg press", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -412, name: "hack squat", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -413, name: "hip thrust", muscleGroup: "legs"),

  // Core exercises
  DatabaseExerciseInfo(id: -501, name: "cable crunches", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -502, name: "plank", muscleGroup: "core", type: "duration"),
  DatabaseExerciseInfo(id: -503, name: "russian twists", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -504, name: "hanging leg raises", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -505, name: "lying leg raises", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -506, name: "ab wheel", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -507, name: "front lever", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -508, name: "l-sit", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -509, name: "hollow body hold", muscleGroup: "core"),

  // Other exercises
  DatabaseExerciseInfo(
      id: -601,
      name: "treadmill running",
      muscleGroup: "other",
      type: "duration"),
  DatabaseExerciseInfo(
      id: -602,
      name: "stationary bike",
      muscleGroup: "other",
      type: "duration"),
  DatabaseExerciseInfo(
      id: -603, name: "boxing", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -604, name: "elliptical", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -605, name: "rowing machine", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -606, name: "jump rope", muscleGroup: "other", type: "duration"),
];

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
      id: -101, name: "podciąganie nachwytem", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -102, name: "podciąganie podchwytem", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -103, name: "podciąganie chwytem neutralnym", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -104, name: "podciąganie australijskie", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -105, name: "ściąganie drążka wyciągu górnego", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -106, name: "wiosłowanie sztangą", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -107, name: "wiosłowanie jednorącz hantlem", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -108, name: "wiosłowanie na maszynie", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -109, name: "wiosłowanie na wyciągu", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -110, name: "wiosłowanie jednorącz na wyciągu", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -111, name: "narciarz na wyciągu", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -112, name: "wiosłowanie t-bar", muscleGroup: "back"),
  DatabaseExerciseInfo(
      id: -113, name: "nautilus pullover", muscleGroup: "back"),
  DatabaseExerciseInfo(id: -114, name: "szrugsy", muscleGroup: "back"),

  // Ćwiczenia na ramiona
  //biceps
  DatabaseExerciseInfo(
      id: -201, name: "uginanie ramion z hantlami", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -202, name: "uginanie ramion ze sztangą", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -203, name: "uginanie ramion młotkowo", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -204,
      name: "uginanie ramion na ławce skośnej",
      muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -205, name: "uginanie ramion na modlitewniku", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -206, name: "uginanie ramion na maszynie", muscleGroup: "biceps"),
  DatabaseExerciseInfo(
      id: -207, name: "uginanie ramion z linką", muscleGroup: "biceps"),
  //triceps
  DatabaseExerciseInfo(
      id: -251, name: "wyciskanie francuskie", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -252, name: "wyciskanie fransukie jednorącz", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -253, name: "wyprosty ramion nachwytem", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -254, name: "wyprosty ramion liną", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -255,
      name: "wyprosty ramion na lince nad głową",
      muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -256, name: "pompki diamentowe", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -257, name: "dipy na triceps", muscleGroup: "triceps"),
  DatabaseExerciseInfo(
      id: -258,
      name: "wyciskanie na ławce wąskim chwytem",
      muscleGroup: "triceps"),

  // Ćwiczenia na barki
  DatabaseExerciseInfo(
      id: -301, name: "wznosy bokiem", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -302, name: "wznosy bokiem na maszynie", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -303, name: "wznosy bokiem na lince", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -304,
      name: "wznosy bokiem leżąc na ławce skośnej",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -305, name: "wyciskanie żołnierskie (ohp)", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(id: -306, name: "arnoldki", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(id: -307, name: "face pull", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -308,
      name: "krzyżowanie linek wyciągu górnego",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -309, name: "odwrotne rozpiętki hantlami", muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -310,
      name: "odwrotne rozpiętki na maszynie",
      muscleGroup: "shoulders"),
  DatabaseExerciseInfo(
      id: -311, name: "wyciskanie landmine", muscleGroup: "shoulders"),

  // Ćwiczenia na nogi
  DatabaseExerciseInfo(
      id: -401, name: "przysiad ze sztangą", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -402, name: "przysiad przedni", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -403, name: "przysiad bułgarski", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -404, name: "goblet squat", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -405, name: "wykroki", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -406, name: "martwy ciąg", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -407, name: "martwy ciąg sumo", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -408, name: "rumuński martwy ciąg", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -409, name: "maszyna na czworogłowe", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -410, name: "maszyna na dwugłowe", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -411, name: "prostowanie nóg na suwnicy", muscleGroup: "legs"),
  DatabaseExerciseInfo(
      id: -412, name: "przysiad na hack maszynie", muscleGroup: "legs"),
  DatabaseExerciseInfo(id: -413, name: "hip-thrusty", muscleGroup: "legs"),

  // Ćwiczenia na core
  DatabaseExerciseInfo(id: -501, name: "allahy", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -502, name: "plank", muscleGroup: "core", type: "duration"),
  DatabaseExerciseInfo(id: -503, name: "rosyjskie skręty", muscleGroup: "core"),
  DatabaseExerciseInfo(
      id: -504, name: "wznosy nóg w zwisie", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -505, name: "wznosy nóg leżąc", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -506, name: "kólko", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -507, name: "front lever", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -508, name: "l-sit", muscleGroup: "core"),
  DatabaseExerciseInfo(id: -509, name: "hollow body", muscleGroup: "core"),

  // Inne ćwiczenia
  DatabaseExerciseInfo(
      id: -601, name: "bieg na bieżni", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -602,
      name: "rowerek stacjonarny",
      muscleGroup: "other",
      type: "duration"),
  DatabaseExerciseInfo(
      id: -603, name: "boks", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -604, name: "orbitrek", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -605, name: "wioślarz", muscleGroup: "other", type: "duration"),
  DatabaseExerciseInfo(
      id: -606, name: "skakanka", muscleGroup: "other", type: "duration"),
];
