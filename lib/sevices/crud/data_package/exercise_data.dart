class ExerciseData {
  final String name;
  final String type; //reps and duration

  ExerciseData({
    required this.name,
    this.type = "reps",
  });

  @override
  String toString() {
    return "name: $name";
  }
}
