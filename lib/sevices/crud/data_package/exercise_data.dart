class ExerciseData {
  final String? name;
  final String? type;
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
