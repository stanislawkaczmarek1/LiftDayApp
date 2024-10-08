class VolumeChartData {
  final int volume;
  final String bottomTitle;

  VolumeChartData({required this.volume, required this.bottomTitle});

  @override
  String toString() {
    return "VolumeChartData: volume: $volume, bottomTitle: $bottomTitle";
  }
}
