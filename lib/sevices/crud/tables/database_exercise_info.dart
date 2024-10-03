import 'package:liftday/constants/database.dart';

class DatabaseExerciseInfo {
  final int id;
  final String name;
  final String type; //"reps" lub "duration"
  final String muscleGroup;

  DatabaseExerciseInfo({
    required this.id,
    required this.name,
    required this.muscleGroup,
    this.type = "reps",
  });

  DatabaseExerciseInfo.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        type = map[typeColumn] as String,
        muscleGroup = map[muscleGroupColumn] as String;

  @override
  String toString() =>
      "Exercise, ID = $id, name = $name, type = $type, muscleGroup = $muscleGroup";

  @override
  bool operator ==(covariant DatabaseExerciseInfo other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const List<String> muscleGroups = [
  "chest",
  "back",
  "arms",
  "shoulders",
  "legs",
  "core",
  "other"
];

final List<DatabaseExerciseInfo> appExercises = [
  DatabaseExerciseInfo(
      id: 10000, name: "wyciskanie na ławce płaskiej", muscleGroup: "chest")
];
