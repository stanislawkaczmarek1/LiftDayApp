import 'package:liftday/sevices/crud/data_package/exercise_data.dart';

class TrainingDayData {
  final String name;
  final List<ExerciseData> exercises;
  final int isFromPlan; // 1 dla dni z planu, 0 dla dni niestandardowych

  TrainingDayData({
    required this.name,
    required this.exercises,
    this.isFromPlan = 1,
  });

  @override
  String toString() {
    return "name: $name, exercises: $exercises, isFromPlan: $isFromPlan";
  }
}
