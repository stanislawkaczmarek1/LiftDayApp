import 'package:liftday/constants/database.dart';

class DatabaseTrainingDayExercise {
  final int id;
  final int trainingDayId;
  final String name;
  final String type; //"reps" lub "duration"

  DatabaseTrainingDayExercise({
    required this.id,
    required this.trainingDayId,
    required this.name,
    this.type = "reps",
  });

  DatabaseTrainingDayExercise.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        trainingDayId = map[trainingDayIdColumn] as int,
        name = map[nameColumn] as String,
        type = map[typeColumn] as String;

  @override
  String toString() =>
      "Exercise, ID = $id, dateID = $trainingDayId, name = $name, type = $type";

  @override
  bool operator ==(covariant DatabaseTrainingDayExercise other) =>
      id == other.id;

  @override
  int get hashCode => id.hashCode;
}
