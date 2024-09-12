import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/dialogs/are_you_sure_to_delate_plan.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/edit_bloc.dart';
import 'package:liftday/sevices/crud/training_day.dart';
import 'package:liftday/sevices/crud/exercise_service.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  bool isTrainingPlanExpanded = true;
  bool isOtherDaysExpanded = true;

  Future<List<TrainingDay>> _fetchTrainingDays() async {
    final exerciseService = ExerciseService();
    return await exerciseService.getTrainingDays();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: colorLightGrey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
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
                      const Text(
                        "Mój plan",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTextButton("Zastąp", Icons.autorenew, () {}),
                          _buildTextButton("Usuń", Icons.delete, () {
                            showAreYouSureToDeletePlan(context);
                          }),
                          _buildTextButton("Udostępnij", Icons.share, () {
                            //_captureAndSharePng();
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
                      normalButton("+ Dodaj inny dzień", () {}),
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
            children:
                days.map((day) => _buildExerciseDayTile(day, context)).toList(),
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

Widget _buildExerciseDayTile(TrainingDay day, BuildContext context) {
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
            IconButton(
              onPressed: () {
                context
                    .read<EditBloc>()
                    .add(EditEventPushEditIconOnPlansPage(context, day));
              },
              icon: const Icon(
                Icons.edit,
                size: 20.0,
              ),
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
