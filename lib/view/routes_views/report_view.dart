import 'package:flutter/material.dart';
import 'package:liftday/sevices/crud/tables/database_exercise.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/crud/tables/database_set.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportView extends StatelessWidget {
  final String trainingTitle;
  final List<DatabaseExercise> exercises;
  final List<DatabaseExerciseInfo> exerciseInfos;
  final List<List<DatabaseSet>> allExerciseSets;
  final double totalVolume;
  final String unit;

  const ReportView({
    super.key,
    required this.trainingTitle,
    required this.exercises,
    required this.exerciseInfos,
    required this.allExerciseSets,
    required this.totalVolume,
    required this.unit,
  });

  String _formatWeight(double value) {
    String formattedValue = value == value.toInt()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> exerciseWidgets = exercises.asMap().entries.map((entry) {
      final index = entry.key;
      final exercise = entry.value;
      final exerciseInfo = exerciseInfos
          .firstWhere((info) => info.id == exercise.exerciseInfoId);
      final sets = allExerciseSets[index];
      final setsFormatted =
          sets.map((dbSet) => formatSet(dbSet, unit)).join(', ');

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exerciseInfo.name,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          Text(
            setsFormatted,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
        ],
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Theme.of(context).brightness == Brightness.dark
            ? Image.asset('assets/liftday_logo_dark.png', height: 25.0)
            : Image.asset('assets/liftday_logo.png', height: 25.0),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trainingTitle,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ...exerciseWidgets,
              const SizedBox(height: 20),
              Text(
                "${AppLocalizations.of(context)!.volume}${_formatWeight(totalVolume)} $unit",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatSet(DatabaseSet dbSet, String unit) {
    if (dbSet.duration != 0) {
      return "${_formatWeight(dbSet.weight)} $unit x ${dbSet.duration}s";
    } else if (dbSet.reps != 0) {
      return "${_formatWeight(dbSet.weight)} $unit x ${dbSet.reps}";
    } else {
      return "";
    }
  }
}
