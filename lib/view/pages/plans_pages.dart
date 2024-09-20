import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:liftday/dialogs/are_you_sure_to_delate_plan.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/bloc/config_bloc.dart';
import 'package:liftday/sevices/bloc/edit_bloc.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/settings/settings_service.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

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

  Future<List<TrainingDay>> _fetchTrainingDays() async {
    final exerciseService = ExerciseService();
    return await exerciseService.getTrainingDays();
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
        color: colorLightGrey,
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
                    color: colorWhite,
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
                                _buildTextButton("Udostępnij", Icons.share, () {
                                  //_captureAndSharePng();
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
                    color: colorWhite,
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
                      FutureBuilder<List<TrainingDay>>(
                          future: _fetchTrainingDays(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
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
                              default:
                                return const SizedBox(height: 0);
                            }
                          }),
                      FutureBuilder<List<TrainingDay>>(
                          future: _fetchTrainingDays(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.done:
                                final otherDays = snapshot.data!
                                    .where((day) => day.isFromPlan == 0)
                                    .toList();
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
                              default:
                                return const SizedBox(height: 0);
                            }
                          }),
                      const SizedBox(height: 10),
                      normalButton("+ Dodaj inny dzień", () {
                        context
                            .read<EditBloc>()
                            .add(EditEventAddOtherTrainingDay(context));
                      }),
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
    required List<TrainingDay> days,
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
              backgroundColor: colorLightGrey,
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
    TrainingDay day, BuildContext context, bool isFromPlan) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: colorLightGrey,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getPolishDayAbbreviation(day.day),
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
          day.exercises.join(', '),
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
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
