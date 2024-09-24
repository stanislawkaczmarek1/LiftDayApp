class TrainingDay {
  final String day;
  final List<String> exercises;
  final int isFromPlan; // 1 dla dni z planu, 0 dla dni niestandardowych

  TrainingDay({
    required this.day,
    required this.exercises,
    this.isFromPlan = 1,
  });

  @override
  String toString() {
    return "$day, $exercises, isFromPlan: $isFromPlan";
  }
}
