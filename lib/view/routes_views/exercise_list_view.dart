import 'package:flutter/material.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';

typedef AddExerciseFromListCallback = void Function(int? exerciseInfoId);

Future<List<DatabaseExerciseInfo>> getAllExerciseInfos() async {
  ExerciseService exerciseService = ExerciseService();
  return await exerciseService.getAllExercisesInfo();
}

class ExerciseListView extends StatefulWidget {
  final AddExerciseFromListCallback onResult;

  const ExerciseListView({super.key, required this.onResult});

  @override
  State<ExerciseListView> createState() => _ExerciseListViewState();
}

class _ExerciseListViewState extends State<ExerciseListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<DatabaseExerciseInfo>> _customExercises;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _customExercises = getAllExerciseInfos(); // Fetch custom exercises
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista ćwiczeń',
          style: TextStyle(fontSize: 20),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Z aplikacji'),
            Tab(text: 'Własne'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildExerciseList(appExercises),
          ),
          FutureBuilder<List<DatabaseExerciseInfo>>(
            future: _customExercises,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Błąd ładowania ćwiczeń'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Brak własnych ćwiczeń'));
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildExerciseList(snapshot.data!),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Method to build the list of exercises
  Widget _buildExerciseList(List<DatabaseExerciseInfo> exercises) {
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ListTile(
          title: Text(exercise.name),
          onTap: () {
            widget.onResult(exercise.id);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
