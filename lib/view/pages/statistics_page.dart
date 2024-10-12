import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/data_package/snapshot_data.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/view/widgets/charts/muscle_chart.dart';
import 'package:liftday/view/widgets/charts/volume_chart.dart';
import 'package:liftday/sevices/crud/data_package/volume_chart_data.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WeeklySnapshot(),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Statystyki treningowe",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const VolumeChartWidget(),
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
                thickness: 1,
                height: 60,
              ),
              const MuscleChartWidget(),
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
                thickness: 1,
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeeklySnapshot extends StatefulWidget {
  const WeeklySnapshot({super.key});

  @override
  State<WeeklySnapshot> createState() => _WeeklySnapshotState();
}

class _WeeklySnapshotState extends State<WeeklySnapshot> {
  Future<MySnapshotData> _loadData() async {
    ExerciseService exerciseService = ExerciseService();
    return await exerciseService.getWeeklySnapshotData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const placeholderContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Migawka z tygodnia",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "treningi",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "", // Placeholder
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "objętość",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.transparent,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "", // Placeholder
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );

            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (snapshot.hasData && snapshot.data != null) {
                  final int workouts = snapshot.data!.workouts;
                  final double volume = snapshot.data!.volume;
                  ConversionService conversionService = ConversionService();
                  final volumeString =
                      conversionService.formatNumberInYAxis(volume);

                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "Migawka z tygodnia",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "treningi",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$workouts",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  "objętość",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  volumeString,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    child: placeholderContent,
                  );
                }
              default:
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onTertiary,
                  ),
                  child: const Opacity(
                    opacity: 1.0,
                    child: placeholderContent,
                  ),
                );
            }
          },
        );
      },
    );
  }
}

class VolumeChartWidget extends StatefulWidget {
  const VolumeChartWidget({super.key});

  @override
  State<VolumeChartWidget> createState() => _VolumeChartWidgetState();
}

class _VolumeChartWidgetState extends State<VolumeChartWidget> {
  int _selectedRangeForBarChart = 7;
  final List<bool> _selectionsForBarChart = [true, false, false];

  Future<List<VolumeChartData>> _loadVolumeChartData(int range) async {
    ExerciseService exerciseService = ExerciseService();
    final data = await exerciseService.getVolumeChartData(range);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Objętość treningowa",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: SizedBox(
                  height: 300,
                  child: FutureBuilder<List<VolumeChartData>>(
                    future: _loadVolumeChartData(_selectedRangeForBarChart),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.hasData && snapshot.data != null) {
                            final range = _selectedRangeForBarChart;
                            final data = snapshot.data!;
                            return VolumeChart(
                              data: data,
                              range: range,
                            );
                          } else {
                            return const SizedBox(height: 0);
                          }
                        default:
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
              textStyle: const TextStyle(fontSize: 13),
              isSelected: _selectionsForBarChart,
              borderRadius: BorderRadius.circular(8),
              fillColor: Theme.of(context).colorScheme.onTertiary,
              borderColor: Theme.of(context).colorScheme.onTertiary,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text("7 dni"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text("30 dni"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text("90 dni"),
                ),
              ],
              onPressed: (int newIndex) {
                setState(() {
                  for (int i = 0; i < _selectionsForBarChart.length; i++) {
                    _selectionsForBarChart[i] = i == newIndex;
                  }
                  switch (newIndex) {
                    case 0:
                      _selectedRangeForBarChart = 7;
                      break;
                    case 1:
                      _selectedRangeForBarChart = 30;
                      break;
                    case 2:
                      _selectedRangeForBarChart = 90;
                      break;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class MuscleChartWidget extends StatefulWidget {
  const MuscleChartWidget({super.key});

  @override
  State<MuscleChartWidget> createState() => _MuscleChartWidgetState();
}

class _MuscleChartWidgetState extends State<MuscleChartWidget> {
  int _selectedRangeForRadarChart = 7;
  final List<bool> _selectionsForRadarChart = [true, false, false, false];

  Future<Map<String, int>> _loadMuscleChartData(int range) async {
    ExerciseService exerciseService = ExerciseService();
    const List<String> muscleGroups = [
      "chest",
      "back",
      "arms",
      "shoulders",
      "legs",
      "core",
    ];
    final data = await exerciseService.getMuscleChartData(muscleGroups, range);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Dystrybucja mięśni",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: SizedBox(
                  height: 300,
                  child: FutureBuilder<Map<String, int>>(
                    future: _loadMuscleChartData(_selectedRangeForRadarChart),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          if (snapshot.hasData && snapshot.data != null) {
                            return MuscleChart(muscleChartData: snapshot.data!);
                          } else {
                            return const SizedBox(height: 0);
                          }
                        default:
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
              textStyle: const TextStyle(
                fontSize: 13,
              ),
              isSelected: _selectionsForRadarChart,
              borderRadius: BorderRadius.circular(8),
              fillColor: Theme.of(context).colorScheme.onTertiary,
              borderColor: Theme.of(context).colorScheme.onTertiary,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    "7 dni",
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text("30 dni"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text("90 dni"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text("Cały okres"),
                ),
              ],
              onPressed: (int newIndex) {
                setState(() {
                  for (int i = 0; i < _selectionsForRadarChart.length; i++) {
                    _selectionsForRadarChart[i] = i == newIndex;
                  }
                  switch (newIndex) {
                    case 0:
                      _selectedRangeForRadarChart = 7;
                      break;
                    case 1:
                      _selectedRangeForRadarChart = 30;
                      break;
                    case 2:
                      _selectedRangeForRadarChart = 90;
                      break;
                    case 3:
                      _selectedRangeForRadarChart = -1;
                      break;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
