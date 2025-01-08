import 'package:flutter/material.dart';
import 'package:liftday/constants/app_exercises.dart';
import 'package:liftday/sevices/conversion/conversion_service.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/crud/tables/database_exercise_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:liftday/sevices/settings/settings_service.dart';

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

  String _searchTerm = '';
  List<DatabaseExerciseInfo> _filteredAppExercises = [];
  List<DatabaseExerciseInfo> _filteredCustomExercises = [];
  List<String> _selectedMuscleGroups = [];
  List<DatabaseExerciseInfo> _customExercisesData = [];

  DatabaseExerciseInfo? _selectedExercise;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _customExercises = getAllExerciseInfos();
    final List<DatabaseExerciseInfo> appExercises;

    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      appExercises = appExercisesPl;
    } else {
      appExercises = appExercisesEn;
    }
    _filteredAppExercises = appExercises;
  }

  void _filterAppExercises() {
    setState(() {
      final List<DatabaseExerciseInfo> appExercises;

      SettingsService settingsService = SettingsService();
      if (settingsService.language() == "pl") {
        appExercises = appExercisesPl;
      } else {
        appExercises = appExercisesEn;
      }
      _filteredAppExercises = appExercises.where((exercise) {
        final matchesSearchTerm =
            exercise.name.toLowerCase().contains(_searchTerm.toLowerCase());

        final matchesMuscleGroup = _selectedMuscleGroups.isEmpty ||
            _selectedMuscleGroups.contains(exercise.muscleGroup);

        return matchesSearchTerm && matchesMuscleGroup;
      }).toList();
    });
  }

  void _filterCustomExercises() {
    setState(() {
      _filteredCustomExercises = _customExercisesData.where((exercise) {
        final matchesSearchTerm =
            exercise.name.toLowerCase().contains(_searchTerm.toLowerCase());

        final matchesMuscleGroup = _selectedMuscleGroups.isEmpty ||
            _selectedMuscleGroups.contains(exercise.muscleGroup);

        return matchesSearchTerm && matchesMuscleGroup;
      }).toList();
    });
  }

  void _selectExercise(DatabaseExerciseInfo exercise) {
    setState(() {
      if (_selectedExercise == exercise) {
        _selectedExercise = null;
      } else {
        _selectedExercise = exercise;
      }
    });
  }

  void _addSelectedExercise() {
    if (_selectedExercise != null) {
      widget.onResult(_selectedExercise!.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.exercise_list,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(190), // sum of all boxes
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 60,
                    child: TextField(
                      maxLength: 50,
                      buildCounter: (BuildContext context,
                          {int? currentLength,
                          bool? isFocused,
                          int? maxLength}) {
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.search_exercise,
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.grey),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.onTertiary,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.onPrimary,
                              width: 1.5),
                        ),
                        enabled: true,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchTerm = value;
                          _filterAppExercises();
                          _filterCustomExercises();
                        });
                      },
                    )),
                Stack(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: appMuscleGroups.map((group) {
                            final isSelected =
                                _selectedMuscleGroups.contains(group);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedMuscleGroups.remove(group);
                                    } else {
                                      _selectedMuscleGroups.add(group);
                                    }
                                    _filterAppExercises();
                                    _filterCustomExercises();
                                  });
                                },
                                child: Text(
                                  ConversionService.getPolishMuscleNameOrReturn(
                                      group),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.grey,
                                    fontWeight: isSelected
                                        ? FontWeight.w800
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.read_more,
                        size: 20,
                      ),
                    )
                  ],
                ),
                // TabBar
                SizedBox(
                  height: 40,
                  child: TabBar(
                    indicatorColor: Theme.of(context).colorScheme.secondary,
                    labelColor: Theme.of(context).colorScheme.secondary,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.normal),
                    controller: _tabController,
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.from_app),
                      Tab(text: AppLocalizations.of(context)!.custom),
                    ],
                  ),
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: _buildExerciseList(_filteredAppExercises),
                ),
              ],
            ),
          ),
          FutureBuilder<List<DatabaseExerciseInfo>>(
            future: _customExercises,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        AppLocalizations.of(context)!.exercise_loading_error));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                    child: Text(
                        AppLocalizations.of(context)!.no_custom_exercises));
              } else {
                _customExercisesData = snapshot.data!;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _filterCustomExercises();
                });

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildExerciseList(_filteredCustomExercises),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: _selectedExercise != null
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              heroTag: 'addBtn2',
              onPressed: _addSelectedExercise,
              child: const Icon(Icons.check),
            )
          : null,
    );
  }

  Widget _buildExerciseList(List<DatabaseExerciseInfo> exercises) {
    return ListView.separated(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final isSelected = _selectedExercise == exercise;

        return ListTile(
          title: Text(
            exercise.name,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Text(
            ConversionService.getPolishMuscleNameOrReturn(exercise.muscleGroup),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          tileColor: isSelected ? Colors.grey.withOpacity(0.3) : null,
          onTap: () {
            _selectExercise(exercise);
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 0.3,
          color: Colors.grey,
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
