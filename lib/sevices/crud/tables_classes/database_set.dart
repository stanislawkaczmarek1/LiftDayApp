import 'package:liftday/sevices/crud/tables_classes/database_constans.dart';

class DatabaseSet {
  final int id;
  final int exerciseId;
  final int setIndex;
  final int weight;
  final int reps;

  DatabaseSet({
    required this.id,
    required this.exerciseId,
    required this.setIndex,
    required this.weight,
    required this.reps,
  });

  DatabaseSet.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        exerciseId = map[exerciseIdColumn] as int,
        setIndex = map[setIndexColumn] as int,
        weight = map[weightColumn] as int,
        reps = map[repsColumn] as int;

  @override
  String toString() =>
      "Set, ID = $id, exerciseID = $exerciseId, setIndex = $setIndex, weight = $weight, reps = $reps";

  @override
  bool operator ==(covariant DatabaseSet other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
