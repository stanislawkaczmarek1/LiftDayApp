import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:liftday/constants/themes.dart';

class MusclePieChart extends StatelessWidget {
  final Map<String, int> data;

  const MusclePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 300,
          width: 300,
          child: PieChart(
            PieChartData(
              sections: _buildSections(context),
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 40,
              sectionsSpace: 2,
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    final totalValue = data.values.fold(0, (sum, value) => sum + value);

    return data.entries.map((entry) {
      final value = entry.value;
      final title =
          '${entry.key}\n${((value / totalValue) * 100).toStringAsFixed(1)}%';
      final section = PieChartSectionData(
        color: colorBabyBlue,
        value: value.toDouble(),
        title: title,
        titleStyle: Theme.of(context).brightness == Brightness.dark
            ? const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorBlack)
            : const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: colorWhite),
        radius: 100,
      );
      return section;
    }).toList();
  }
}
