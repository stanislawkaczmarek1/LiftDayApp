import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/bloc/app_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/view/exercise_table.dart';

class AddFirstWeekPlanView extends StatefulWidget {
  const AddFirstWeekPlanView({super.key});

  @override
  State<AddFirstWeekPlanView> createState() => _AddFirstWeekPlanViewState();
}

class _AddFirstWeekPlanViewState extends State<AddFirstWeekPlanView> {
  String dayOfWeek = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is AppStateAddFirstWeekPlan) {
          dayOfWeek = state.dayOfWeek;
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) {
              context.read<AppBloc>().add(const AppEventGoBack());
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Image.asset(
                "assets/liftday_logo.png",
                height: 25,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    context
                        .read<AppBloc>()
                        .add(const AppEventConfirmExercisesInDay("some data"));
                  },
                  style: TextButton.styleFrom(foregroundColor: colorAccent),
                  child: const Text(
                    "Dalej",
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Dodaj trening w $dayOfWeek',
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const ExerciseTable(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
