import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

final List<DatabaseExerciseInfo> appExercisesEn = [
  DatabaseExerciseInfo(id: -1, name: "Flat bench press", muscleGroup: "chest")
];

final List<DatabaseExerciseInfo> appExercisesPl = [
  DatabaseExerciseInfo(
      id: -1, name: "Wyciskanie na ławce płaskiej", muscleGroup: "chest")
];

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
