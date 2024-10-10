import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liftday/dialogs/are_you_sure_to_delate_plan.dart';
import 'package:liftday/dialogs/error_dialog.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/sevices/bloc/edit/edit_bloc.dart';
import 'package:liftday/sevices/bloc/edit/edit_event.dart';
import 'package:liftday/sevices/bloc/edit/edit_state.dart';
import 'package:liftday/sevices/crud/data_package/exercise_data.dart';
import 'package:liftday/sevices/crud/data_package/training_day_data.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
//caly plans page sie rozjechal podczas testow, reszta wydaje sie ok
//TO DO

class PlansTab extends StatefulWidget {
  const PlansTab({super.key});

  @override
  State<PlansTab> createState() => _PlansTabState();
}

class _PlansTabState extends State<PlansTab> {
  late SettingsService _settingsService;
  late bool hasPlan;

  Future<List<TrainingDayData>> _fetchTrainingDays() async {
    final exerciseService = ExerciseService();
    final trainingDays = await exerciseService.getTrainingDaysFromPlanData();
    return trainingDays;
  }

  Future<int?> _getDaysUntilEnd() async {
    final String? planEndingDigitDate = _settingsService.planEndingDigitDate();

    if (planEndingDigitDate != null) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final DateTime lastDate = formatter.parse(planEndingDigitDate);
      final DateTime now = DateTime.now();
      final DateTime currentDate = DateTime(now.year, now.month, now.day);

      return lastDate.difference(currentDate).inDays;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    _settingsService = SettingsService();
    hasPlan = _settingsService.hasPlanFlag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBloc, EditState>(
      listener: (context, state) {
        if (state is EditStateDayUpdated) {
          setState(() {
            _fetchTrainingDays();
          });
          context.read<EditBloc>().add(const EditEventEndedEdition());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Zaktualizowane dane')),
            );
          }
        }
        if (state is EditStatePlanDeleted) {
          setState(() {
            hasPlan = false;
            _fetchTrainingDays();
          });
          context.read<EditBloc>().add(const EditEventEndedEdition());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usunięto plan')),
            );
          }
        }
        if (state is EditStateDayDeleted) {
          setState(() {
            _fetchTrainingDays();
          });
          context.read<EditBloc>().add(const EditEventEndedEdition());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usunięto dzien')),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mój plan",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder(
                    future: _getDaysUntilEnd(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final daysUntilEnd = snapshot.data;
                        return Text(
                          (daysUntilEnd != null && hasPlan)
                              ? '$daysUntilEnd dni do końca'
                              : '',
                          style: const TextStyle(fontSize: 14.0),
                        );
                      } else {
                        return const SizedBox(height: 0);
                      }
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<TrainingDayData>>(
                future: _fetchTrainingDays(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final trainingPlanDays = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trainingPlanDays.length,
                        itemBuilder: (context, index) {
                          return _buildExerciseDayTile(
                              trainingPlanDays[index], context, true);
                        },
                      );
                    } else {
                      return const SizedBox(height: 0);
                    }
                  } else {
                    return const SizedBox(height: 0);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              hasPlan
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTextButton(
                          "Zastąp",
                          Icons.autorenew,
                          () {
                            context
                                .read<ConfigBloc>()
                                .add(const ConfigEventChangePlanFromMainView());
                          },
                        ),
                        _buildTextButton(
                          "Usuń",
                          Icons.delete,
                          () async {
                            final delete =
                                await showAreYouSureToDeletePlan(context);
                            if (delete && context.mounted) {
                              context
                                  .read<EditBloc>()
                                  .add(const EditEventPushDeletePlanButton());
                            }
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTextButton(
                          "Dodaj plan",
                          Icons.add,
                          () {
                            context
                                .read<ConfigBloc>()
                                .add(const ConfigEventAddPlanFromMainView());
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextButton(
      String title, IconData icon, void Function() onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                    color: Colors.grey,
                  )),
              minimumSize: const Size(double.infinity, 0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseDayTile(
      TrainingDayData day, BuildContext context, bool isFromPlan) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getPolishDayAbbreviation(day.name),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    if (isFromPlan) {
                      context
                          .read<EditBloc>()
                          .add(EditEventEditTrainingDayFromPlan(
                            context,
                            day,
                          ));
                    } else {
                      context
                          .read<EditBloc>()
                          .add(EditEventEditOtherTrainingDay(
                            context,
                            day,
                          ));
                    }
                  } else if (value == 'delete') {
                    context
                        .read<EditBloc>()
                        .add(EditEventDeleteTrainingDay(day));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edytuj'),
                    ),
                    if (!isFromPlan)
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Usuń'),
                      ),
                  ];
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            _writeExercises(day.exercises),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class RoutinesTab extends StatefulWidget {
  const RoutinesTab({super.key});

  @override
  State<RoutinesTab> createState() => _RoutinesTabState();
}

class _RoutinesTabState extends State<RoutinesTab> {
  bool maximumOfOtherTrainingDays = false;

  Future<List<TrainingDayData>> _fetchTrainingDays() async {
    final exerciseService = ExerciseService();
    final trainingDays = await exerciseService.getTrainingDaysNotFromPlanData();
    return trainingDays;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBloc, EditState>(
      listener: (context, state) {
        if (state is EditStateDayUpdated) {
          setState(() {
            _fetchTrainingDays();
          });
          context.read<EditBloc>().add(const EditEventEndedEdition());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Zaktualizowane dane')),
            );
          }
        }
        if (state is EditStateDayDeleted) {
          setState(() {
            _fetchTrainingDays();
          });
          context.read<EditBloc>().add(const EditEventEndedEdition());
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usunięto dzien')),
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Moje rutyny",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<TrainingDayData>>(
                future: _fetchTrainingDays(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final otherDays = snapshot.data!;
                      if (otherDays.length >= 4) {
                        maximumOfOtherTrainingDays = true;
                      } else {
                        maximumOfOtherTrainingDays = false;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: otherDays.length,
                        itemBuilder: (context, index) {
                          return _buildExerciseDayTile(
                              otherDays[index], context, false);
                        },
                      );
                    } else {
                      return const SizedBox(height: 0);
                    }
                  } else {
                    return const SizedBox(height: 0);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (!maximumOfOtherTrainingDays) {
                    context
                        .read<EditBloc>()
                        .add(EditEventAddOtherTrainingDay(context));
                  } else {
                    showErrorDialog(context);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      )),
                  child: Center(
                    child: Text(
                      "+ Dodaj rutynę",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseDayTile(
      TrainingDayData day, BuildContext context, bool isFromPlan) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getPolishDayAbbreviation(day.name),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'edit') {
                    if (isFromPlan) {
                      context
                          .read<EditBloc>()
                          .add(EditEventEditTrainingDayFromPlan(
                            context,
                            day,
                          ));
                    } else {
                      context
                          .read<EditBloc>()
                          .add(EditEventEditOtherTrainingDay(
                            context,
                            day,
                          ));
                    }
                  } else if (value == 'delete') {
                    context
                        .read<EditBloc>()
                        .add(EditEventDeleteTrainingDay(day));
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edytuj'),
                    ),
                    if (!isFromPlan)
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Usuń'),
                      ),
                  ];
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            _writeExercises(day.exercises),
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

String _writeExercises(List<ExerciseData> exercises) {
  String exercisesText = "";
  String pointer = "";
  for (var i = 0; i < exercises.length; i++) {
    if (i > 0) {
      pointer = ", ";
    }
    exercisesText = "$exercisesText$pointer${exercises.elementAt(i).name}";
  }

  return exercisesText;
}

String _getPolishDayAbbreviation(String dayOfWeek) {
  switch (dayOfWeek) {
    case 'Monday':
      return 'Poniedziałek';
    case 'Tuesday':
      return 'Wtorek';
    case 'Wednesday':
      return 'Środa';
    case 'Thursday':
      return 'Czwartek';
    case 'Friday':
      return 'Piątek';
    case 'Saturday':
      return 'Sobota';
    case 'Sunday':
      return 'Niedziela';
    default:
      return dayOfWeek;
  }
}
