import 'package:liftday/constants/database.dart';

class DatabaseExerciseInfo {
  final int id;
  final String name;
  final String type; //"reps" lub "duration"

  DatabaseExerciseInfo({
    required this.id,
    required this.name,
    this.type = "reps",
  });

  DatabaseExerciseInfo.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[nameColumn] as String,
        type = map[typeColumn] as String;

  @override
  String toString() => "Exercise, ID = $id, name = $name, type = $type";

  @override
  bool operator ==(covariant DatabaseExerciseInfo other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
