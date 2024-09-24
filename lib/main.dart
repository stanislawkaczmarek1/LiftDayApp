import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:liftday/constants/routes.dart';
import 'package:liftday/constants/themes.dart';
import 'package:liftday/l10n/l10n.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_bloc.dart';
import 'package:liftday/sevices/bloc/app_bar/app_bar_event.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/sevices/bloc/config/config_state.dart';
import 'package:liftday/sevices/bloc/edit/edit_bloc.dart';
import 'package:liftday/sevices/bloc/language/language_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_bloc.dart';
import 'package:liftday/sevices/bloc/theme/theme_state.dart';
import 'package:liftday/view/config/4_add_first_week_plan_view.dart';
import 'package:liftday/view/config/3_choose_training_days_view.dart';
import 'package:liftday/view/config/2_create_plan_or_skip_view.dart';
import 'package:liftday/view/config/1_start_view.dart';
import 'package:liftday/view/config/5_choose_duration_of_plan_view.dart';
import 'package:liftday/view/config/3_add_training_days_view.dart';
import 'package:liftday/view/main_view.dart';
import 'package:liftday/view/edit/training_day_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) {
    runApp(
      MultiProvider(
        providers: [
          BlocProvider<ConfigBloc>(
            create: (context) {
              final bloc = ConfigBloc();
              bloc.add(const ConfigEventChceckAppConfigured());
              return bloc;
            },
          ),
          BlocProvider<EditBloc>(
            create: (context) {
              return EditBloc();
            },
          ),
          BlocProvider<AppBarBloc>(
            create: (context) {
              return AppBarBloc();
            },
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider<LanguageBloc>(
            create: (context) => LanguageBloc(),
          ),
        ],
        child: BlocListener<ThemeBloc, ThemeState>(
          listener: (context, state) {
            context
                .read<AppBarBloc>()
                .add(AppBarEventUpdateTitleBasedOnTheme(state.themeMode));
          },
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return BlocBuilder<LanguageBloc, LanguageState>(
                builder: (context, languageState) {
                  return MaterialApp(
                    title: 'Lift Day',
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: themeState.themeMode,
                    home: const HomePage(),
                    supportedLocales: L10n.all,
                    locale: languageState.locale,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    routes: {
                      editTrainingDayRoute: (context) =>
                          const TrainingDayView(),
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConfigBloc, ConfigState>(
      builder: (context, state) {
        if (state is ConfigStateStart) {
          return const StartView();
        } else if (state is ConfigStateCreatePlanOrSkip) {
          return const CreatePlanOrSkipView();
        } else if (state is ConfigStateChooseTrainingDays) {
          return const ChooseTrainingDaysView();
        } else if (state is ConfigStateAddFirstWeekPlan) {
          return const AddFirstWeekPlanView();
        } else if (state is ConfigStateChooseDurationOfPlan) {
          return const PlanDurationView();
        } else if (state is ConfigStateMainView) {
          return const MainView();
        } else if (state is ConfigStateAddTrainingDays) {
          return const AddTrainingDaysView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
