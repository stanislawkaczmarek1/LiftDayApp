import 'package:liftday/constants/database.dart';

class DatabaseTrainingDay {
  final int id;
  final String name;
  final int isFromPlan; // 1 dla dni z planu, 0 dla dni niestandardowych

  DatabaseTrainingDay({
    required this.id,
    required this.name,
    this.isFromPlan = 1,
  });

  DatabaseTrainingDay.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        name = map[dayNameColumn] as String,
        isFromPlan = map[isFromPlanColumn] as int;

  @override
  String toString() {
    return "Training Day, id: $id, name: $name, isFromPlan: $isFromPlan";
  }

  @override
  bool operator ==(covariant DatabaseTrainingDay other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
