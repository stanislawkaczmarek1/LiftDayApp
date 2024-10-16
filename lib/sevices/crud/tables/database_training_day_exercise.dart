import 'package:liftday/constants/database.dart';

class DatabaseTrainingDayExercise {
  final int id;
  final int trainingDayId;
  final int exerciseInfoId;

  DatabaseTrainingDayExercise({
    required this.id,
    required this.trainingDayId,
    required this.exerciseInfoId,
  });

  DatabaseTrainingDayExercise.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        trainingDayId = map[trainingDayIdColumn] as int,
        exerciseInfoId = map[exerciseInfoIdColumn] as int;

  @override
  String toString() =>
      "TrainingDayExercise, ID = $id, trainingDayId = $trainingDayId, exerciseInfoId = $exerciseInfoId";

  @override
  bool operator ==(covariant DatabaseTrainingDayExercise other) =>
      id == other.id;

  @override
  int get hashCode => id.hashCode;
}
