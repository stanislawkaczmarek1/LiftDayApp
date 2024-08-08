import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/bloc/app_bloc.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/view/4_add_first_week_plan.dart';
import 'package:liftday/view/3_choose_training_days_view.dart';
import 'package:liftday/view/2_create_plan_or_skip_view.dart';
import 'package:liftday/view/1_start_view.dart';
//import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'My notes',
    theme: ThemeData(
        colorScheme: const ColorScheme.light(
            background: colorMainBackgroud,
            onBackground: colorElements,
            primary: colorElements,
            onPrimary: colorMainBackgroud)),
    home: BlocProvider<AppBloc>(
      create: (context) => AppBloc(),
      child: const HomePage(),
    ),
    routes: {},
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        /*
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? "Please wait a moment");
        } else {
          LoadingScreen().hide();
        }
        */
      },
      builder: (context, state) {
        if (state is AppStateStart) {
          return const StartView();
        } else if (state is AppStateCreatePlanOrSkip) {
          return const CreatePlanOrSkipView();
        } else if (state is AppStateChooseTrainingDays) {
          return const ChooseTrainingDaysView();
        } else if (state is AppStateAddFirstWeekPlan) {
          return const AddFirstWeekPlanView();
        }
        {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
