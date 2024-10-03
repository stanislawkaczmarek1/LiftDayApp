import 'package:flutter/material.dart';
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
import 'package:liftday/view/widgets/ui_elements.dart';
//caly plans page sie rozjechal podczas testow, reszta wydaje sie ok
//TO DO

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool isTrainingPlanExpanded = true;
  bool isOtherDaysExpanded = true;
  late SettingsService _settingsService;
  late bool hasPlan;

  bool maximumOfOtherTrainingDays = false;

  Future<List<TrainingDayData>> _fetchTrainingDays() async {
    final exerciseService = ExerciseService();
    final trainingDays = await exerciseService.getTrainingDaysData();
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
        color: Theme.of(context).colorScheme.tertiary,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                              switch (snapshot.connectionState) {
                                case ConnectionState.done:
                                  final daysUntilEnd = snapshot.data;
                                  return Text(
                                    (daysUntilEnd != null && hasPlan)
                                        ? '$daysUntilEnd dni do końca'
                                        : 'Brak planu',
                                    style: const TextStyle(fontSize: 14.0),
                                  );

                                default:
                                  return const SizedBox(height: 0);
                              }
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      hasPlan
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTextButton("Zastąp", Icons.autorenew, () {
                                  context.read<ConfigBloc>().add(
                                      const ConfigEventChangePlanFromMainView());
                                }),
                                _buildTextButton("Usuń", Icons.delete,
                                    () async {
                                  final delete =
                                      await showAreYouSureToDeletePlan(context);
                                  if (delete && context.mounted) {
                                    context.read<EditBloc>().add(
                                        const EditEventPushDeletePlanButton());
                                  }
                                }),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTextButton("Dodaj plan", Icons.add, () {
                                  context.read<ConfigBloc>().add(
                                      const ConfigEventAddPlanFromMainView());
                                }),
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dni treningowe",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      FutureBuilder<List<TrainingDayData>>(
                          future: _fetchTrainingDays(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                if (snapshot.hasData && snapshot.data != null) {
                                  final trainingPlanDays = snapshot.data!
                                      .where((day) => day.isFromPlan == 1)
                                      .toList();
                                  return _buildDropdownTile(
                                    title: "Dni z planu treningowego",
                                    isExpanded: isTrainingPlanExpanded,
                                    days: trainingPlanDays,
                                    isFromPlan: true,
                                    onExpand: () {
                                      setState(() {
                                        isTrainingPlanExpanded =
                                            !isTrainingPlanExpanded;
                                      });
                                    },
                                  );
                                } else {
                                  return const SizedBox(height: 0);
                                }
                              default:
                                return const SizedBox(height: 0);
                            }
                          }),
                      FutureBuilder<List<TrainingDayData>>(
                          future: _fetchTrainingDays(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                if (snapshot.hasData && snapshot.data != null) {
                                  final otherDays = snapshot.data!
                                      .where((day) => day.isFromPlan == 0)
                                      .toList();
                                  if (otherDays.length >= 4) {
                                    maximumOfOtherTrainingDays = true;
                                  } else {
                                    maximumOfOtherTrainingDays = false;
                                  }
                                  return _buildDropdownTile(
                                    title: "Inne dni",
                                    isExpanded: isOtherDaysExpanded,
                                    days: otherDays,
                                    isFromPlan: false,
                                    onExpand: () {
                                      setState(() {
                                        isOtherDaysExpanded =
                                            !isOtherDaysExpanded;
                                      });
                                    },
                                  );
                                } else {
                                  return const SizedBox(height: 0);
                                }
                              default:
                                return const SizedBox(height: 0);
                            }
                          }),
                      const SizedBox(height: 10),
                      normalButton(
                        context,
                        "+ Dodaj inny dzień",
                        () {
                          if (!maximumOfOtherTrainingDays) {
                            context
                                .read<EditBloc>()
                                .add(EditEventAddOtherTrainingDay(context));
                          } else {
                            showErrorDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required bool isExpanded,
    required List<TrainingDayData> days,
    required bool isFromPlan,
    VoidCallback? onExpand,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
          ),
          onTap: onExpand,
        ),
        if (isExpanded)
          Column(
            children: days
                .map((day) => _buildExerciseDayTile(day, context, isFromPlan))
                .toList(),
          ),
      ],
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
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildExerciseDayTile(
    TrainingDayData day, BuildContext context, bool isFromPlan) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.tertiary,
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
                    context.read<EditBloc>().add(EditEventEditOtherTrainingDay(
                          context,
                          day,
                        ));
                  }
                } else if (value == 'delete') {
                  context.read<EditBloc>().add(EditEventDeleteTrainingDay(day));
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
              icon: const Icon(Icons.more_vert),
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
