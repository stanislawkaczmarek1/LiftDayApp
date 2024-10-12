class MySnapshotData {
  final int workouts;
  final double volume;

  MySnapshotData({required this.workouts, required this.volume});

  @override
  String toString() {
    return "VolumeChartData: workouts: $workouts, volume: $volume";
  }
}
