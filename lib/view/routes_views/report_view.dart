import 'package:flutter/material.dart';
import 'package:liftday/sevices/crud/tables/database_exercise.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:liftday/sevices/crud/tables/database_set.dart';

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

  static const List<String> muscleGroups = [
    "chest",
    "triceps",
    "back",
    "biceps",
    "legs",
    "core",
    "shoulders",
  ];

  String _formatWeight(double value) {
    String formattedValue = value == value.toInt()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
    return formattedValue;
  }

  Map<String, int> _getMusclePieChartDataFromTraining(
    List<String> muscleGroups,
    final List<DatabaseExercise> exercises,
    final List<DatabaseExerciseInfo> exerciseInfos,
    final List<List<DatabaseSet>> allExerciseSets,
  ) {
    final Map<String, int> data = {};

    for (var muscleGroup in muscleGroups) {
      int sets = 0;
      for (var i = 0; i < exerciseInfos.length; i++) {
        if (exerciseInfos.elementAt(i).muscleGroup == muscleGroup) {
          for (var dbSet in allExerciseSets.elementAt(i)) {
            if (dbSet.reps != 0 || dbSet.duration != 0) {
              sets += 1;
            }
          }
        }
      }
      data.putIfAbsent(muscleGroup, () => sets);
    }

    return data;
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
              Center(
                child: Text(
                  trainingTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ...exerciseWidgets,
              /*const SizedBox(height: 20),
              Center(
                child: Text(
                  "${AppLocalizations.of(context)!.volume}${_formatWeight(totalVolume)} $unit",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.muscle_distribution2,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  height: 250,
                  child: MusclePieChart(
                      data: _getMusclePieChartDataFromTraining(muscleGroups,
                          exercises, exerciseInfos, allExerciseSets)),
                ),
              )*/
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
