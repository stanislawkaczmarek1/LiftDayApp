import 'package:liftday/constants/database.dart';

class DatabaseSet {
  final int id;
  final int exerciseId;
  final int setIndex;
  final double weight;
  final int reps;
  final int duration; //default 0

  DatabaseSet({
    required this.id,
    required this.exerciseId,
    required this.setIndex,
    required this.weight,
    required this.reps,
    this.duration = 0,
  });

  DatabaseSet.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        exerciseId = map[exerciseIdColumn] as int,
        setIndex = map[setIndexColumn] as int,
        weight = map[weightColumn] as double,
        reps = map[repsColumn] as int,
        duration = map[durationColumn] as int;

  @override
  String toString() =>
      "Set, ID = $id, exerciseID = $exerciseId, setIndex = $setIndex, weight = $weight, reps = $reps, duration = $duration";

  @override
  bool operator ==(covariant DatabaseSet other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
