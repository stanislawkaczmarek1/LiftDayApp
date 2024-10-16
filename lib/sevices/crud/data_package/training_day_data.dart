import 'package:liftday/sevices/crud/data_package/exercise_data.dart';

class TrainingDayData {
  final String name;
  final List<ExerciseData> exercises;
  final int isFromPlan; // 1 for days from plan, 0 for routines

  TrainingDayData({
    required this.name,
    required this.exercises,
    this.isFromPlan = 1,
  });

  @override
  String toString() {
    return "TrainingDayData, name: $name, exercises: $exercises, isFromPlan: $isFromPlan";
  }
}
