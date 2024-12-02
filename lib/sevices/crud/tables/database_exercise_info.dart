import 'package:liftday/constants/database.dart';

class DatabaseExerciseInfo {
  final int id;
  final String name;
  final String type; //"reps" or "duration"
  final String muscleGroup;
  final int isArchived;

  DatabaseExerciseInfo({
    required this.id,
    required this.name,
    this.type = "reps",
    required this.muscleGroup,
    this.isArchived = 0,
  });

  DatabaseExerciseInfo.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[dayNameColumn] as String,
        type = map[typeColumn] as String,
        muscleGroup = map[muscleGroupColumn] as String,
        isArchived = map[isArchivedColumn] as int;

  @override
  String toString() =>
      "Exercise, ID = $id, name = $name, type = $type, muscleGroup = $muscleGroup, isArchived = $isArchived";

  @override
  bool operator ==(covariant DatabaseExerciseInfo other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const List<String> appMuscleGroups = [
  "chest",
  "back",
  "shoulders",
  "triceps",
  "biceps",
  "quadriceps",
  "hamstrings",
  "glutes",
  "core",
  "other"
];
