class ExerciseData {
  final String? name; //null if from list
  final String? type; //reps and duration, null if from list
  final int? infoId; //null if custom

  ExerciseData({
    required this.name,
    required this.infoId,
    this.type = "reps",
  });

  @override
  String toString() {
    return "ExerciseData name: $name, type: $type, infoId: $infoId";
  }
}
