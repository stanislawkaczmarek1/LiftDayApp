class ExerciseDay {
  final String day;
  final List<String> exercises;

  ExerciseDay({required this.day, required this.exercises});

  @override
  String toString() {
    return "$day, $exercises";
  }
}
