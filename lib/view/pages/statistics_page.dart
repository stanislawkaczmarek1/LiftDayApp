import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/dialogs/muscle_chart_info_dialog.dart';
import 'package:liftday/dialogs/volume_chart_info_dialog.dart';
import 'package:liftday/sevices/bloc/settings/settings_bloc.dart';
import 'package:liftday/sevices/bloc/settings/settings_state.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/data_package/snapshot_data.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/view/widgets/charts/muscle_chart.dart';
import 'package:liftday/view/widgets/charts/volume_chart.dart';
import 'package:liftday/sevices/crud/data_package/volume_chart_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        AppLocalizations.of(context)!.workout_statistics,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const MuscleChartWidget(),
              Divider(
                color: Theme.of(context).colorScheme.tertiary,
                thickness: 1,
                height: 60,
              ),
              const VolumeChartWidget(),
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
            final placeholderContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    AppLocalizations.of(context)!.weekly_snapshot,
                    style: const TextStyle(
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
                        Text(
                          AppLocalizations.of(context)!.workouts,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.transparent,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "", // Placeholder
                          style: TextStyle(
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
                        Text(
                          AppLocalizations.of(context)!.volume_label,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.transparent,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
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
                  final volumeString =
                      ConversionService.formatNumberInYAxis(volume);

                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            AppLocalizations.of(context)!.weekly_snapshot,
                            style: const TextStyle(
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
                                Text(
                                  AppLocalizations.of(context)!.workouts,
                                  style: const TextStyle(
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
                                Text(
                                  AppLocalizations.of(context)!.volume_label,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                BlocBuilder<SettingsBloc, SettingsState>(
                                  builder: (context, state) {
                                    return Text(
                                      "$volumeString ${state.unit}",
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
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
                  child: Opacity(
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
  final List<bool> _selectionsForBarChart = [true, false];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.workout_volume,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  IconButton(
                      onPressed: () {
                        showVolumeChartInfoDialog(context);
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.grey,
                      ))
                ],
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
          child: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ToggleButtons(
                textStyle: const TextStyle(fontSize: 13),
                isSelected: _selectionsForBarChart,
                borderRadius: BorderRadius.circular(8),
                fillColor: Theme.of(context).colorScheme.onTertiary,
                borderColor: Theme.of(context).colorScheme.onTertiary,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(AppLocalizations.of(context)!.days_7),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(AppLocalizations.of(context)!.days_30),
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
  final List<bool> _selectionsForRadarChart = [true, false];

  Future<Map<String, int>> _loadMuscleChartData(int range) async {
    ExerciseService exerciseService = ExerciseService();
    const List<String> muscleGroups = [
      "chest",
      "triceps",
      "back",
      "biceps",
      "legs",
      "core",
      "shoulders",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.muscle_distribution,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  IconButton(
                      onPressed: () {
                        showMuscleChartInfoDialog(context);
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.grey,
                      ))
                ],
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
        const SizedBox(
          height: 16,
        ),
        Center(
          child: Align(
            alignment: Alignment.center,
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
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(AppLocalizations.of(context)!.days_7),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(AppLocalizations.of(context)!.days_30),
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
        ),
      ],
    );
  }
}
