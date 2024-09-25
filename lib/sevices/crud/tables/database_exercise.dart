import 'package:liftday/constants/database.dart';

class DatabaseExercise {
  final int id;
  final int dateId;
  final String name;
  final String type; //"reps" lub "duration"

  DatabaseExercise({
    required this.id,
    required this.dateId,
    required this.name,
    this.type = "reps",
  });

  DatabaseExercise.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        dateId = map[dateIdColumn] as int,
        name = map[nameColumn] as String,
        type = map[typeColumn] as String;

  @override
  String toString() =>
      "Exercise, ID = $id, dateID = $dateId, name = $name, type = $type";

  @override
  bool operator ==(covariant DatabaseExercise other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
