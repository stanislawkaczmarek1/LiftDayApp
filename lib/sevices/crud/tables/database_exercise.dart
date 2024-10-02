import 'package:liftday/constants/database.dart';

class DatabaseExercise {
  final int id;
  final int dateId;
  final int exerciseInfoId;

  DatabaseExercise({
    required this.id,
    required this.dateId,
    required this.exerciseInfoId,
  });

  DatabaseExercise.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        dateId = map[dateIdColumn] as int,
        exerciseInfoId = map[exerciseInfoIdColumn] as int;

  @override
  String toString() =>
      "Exercise, ID = $id, dateID = $dateId, exerciseInfoId = $exerciseInfoId";

  @override
  bool operator ==(covariant DatabaseExercise other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
