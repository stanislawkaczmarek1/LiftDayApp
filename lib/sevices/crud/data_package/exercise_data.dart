class ExerciseData {
  final String? name;
  final String? type;
  final String? muscleGroup;
  final int? infoId; //null if custom

  ExerciseData({
    required this.name,
    this.type = "reps",
    required this.muscleGroup,
    required this.infoId,
  });

  @override
  String toString() {
    return "ExerciseData, name: $name, type: $type, muscleGroup: $muscleGroup, infoId: $infoId";
  }
}
