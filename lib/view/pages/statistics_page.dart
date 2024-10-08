import 'package:flutter/material.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
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
      color: Theme.of(context).colorScheme.tertiary,
      height: MediaQuery.of(context).size.height,
      child: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VolumeChartWidget(),
              SizedBox(height: 20),
              MuscleChartWidget(),
            ],
          ),
        ),
      ),
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
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Objętość treningowa",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
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
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
              isSelected: _selectionsForBarChart,
              borderRadius: BorderRadius.circular(8),
              fillColor: Theme.of(context).colorScheme.onPrimary,
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
    final data =
        await exerciseService.getMuscleChartData(appMuscleGroups, range);
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
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Dystrybucja mięśni",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
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
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ToggleButtons(
              isSelected: _selectionsForRadarChart,
              borderRadius: BorderRadius.circular(8),
              fillColor: Theme.of(context).colorScheme.onPrimary,
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
