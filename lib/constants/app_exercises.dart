import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';

final List<DatabaseExerciseInfo> appExercises = [
  DatabaseExerciseInfo(
      id: -1, name: "wyciskanie na ławce płaskiej", muscleGroup: "chest")
];

DatabaseExerciseInfo? getAppExerciseById(int id) {
  for (var exercise in appExercises) {
    if (exercise.id == id) {
      return exercise;
    }
  }
  return null;
}
