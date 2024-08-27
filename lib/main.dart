import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/ui_constants/colors.dart';
import 'package:liftday/sevices/bloc/app_bloc.dart';
import 'package:liftday/sevices/bloc/app_state.dart';
import 'package:liftday/sevices/provider/appbar_title_provider.dart';
import 'package:liftday/view/config/4_add_first_week_plan_view.dart';
import 'package:liftday/view/config/3_choose_training_days_view.dart';
import 'package:liftday/view/config/2_create_plan_or_skip_view.dart';
import 'package:liftday/view/config/1_start_view.dart';
import 'package:liftday/view/config/5_choose_duration_of_plan_view.dart';
import 'package:liftday/view/main_view.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) {
    runApp(
      MultiProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (context) {
              final bloc = AppBloc();
              bloc.add(const AppEventChceckAppConfigured());
              return bloc;
            },
          ),
          ChangeNotifierProvider<AppBarTitleProvider>(
            create: (context) => AppBarTitleProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Lift Day',
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              background: colorMainBackgroud,
              onBackground: colorElements,
              primary: colorElements,
              onPrimary: colorMainBackgroud,
            ),
          ),
          home: const HomePage(),
        ),
      ),
    );
  });
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
        } else if (state is AppStateChooseDurationOfPlan) {
          return const PlanDurationView();
        } else if (state is AppStateMainView) {
          return const MainView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
