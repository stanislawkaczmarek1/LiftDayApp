import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';

class MuscleChart extends StatefulWidget {
  final Map<String, int> muscleChartData;

  const MuscleChart({
    super.key,
    required this.muscleChartData,
  });

  final textColor = Colors.grey;

  @override
  State<MuscleChart> createState() => _MuscleChartState();
}

class _MuscleChartState extends State<MuscleChart> {
  @override
  Widget build(BuildContext context) {
    final muscleGroupNames = widget.muscleChartData.keys.toList();
    final setsPerMuscleGroup = widget.muscleChartData.values.toList();

    int maxNumber;
    if (setsPerMuscleGroup.isNotEmpty) {
      maxNumber = setsPerMuscleGroup.reduce((a, b) => a > b ? a : b);
    } else {
      maxNumber = 1;
    }
    if (maxNumber == 0) {
      maxNumber = 1;
    }

    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          width: 300,
          child: RadarChart(
            RadarChartData(
              dataSets: [
                RadarDataSet(
                  dataEntries: setsPerMuscleGroup.map((value) {
                    return RadarEntry(value: value.toDouble());
                  }).toList(),
                ),
                RadarDataSet(
                  fillColor: Colors.transparent,
                  borderColor: Colors.transparent,
                  dataEntries: setsPerMuscleGroup.map((value) {
                    return const RadarEntry(value: 0);
                  }).toList(),
                ),
              ],
              radarBackgroundColor: Colors.transparent,
              borderData: FlBorderData(show: true),
              radarBorderData: const BorderSide(color: Colors.transparent),
              titlePositionPercentageOffset: 0.2,
              titleTextStyle: TextStyle(color: widget.textColor, fontSize: 14),
              getTitle: (index, angle) {
                if (index < muscleGroupNames.length) {
                  return RadarChartTitle(
                    text: ConversionService.getPolishMuscleNameOrReturn(
                        muscleGroupNames[index]),
                  );
                }
                return const RadarChartTitle(text: '');
              },
              tickCount: maxNumber * 100,
              ticksTextStyle:
                  const TextStyle(fontSize: 0, color: Colors.transparent),
              tickBorderData: const BorderSide(color: Colors.transparent),
              gridBorderData: BorderSide(color: widget.textColor, width: 2),
            ),
            swapAnimationDuration: const Duration(milliseconds: 400),
          ),
        ),
      ),
    );
  }
}
