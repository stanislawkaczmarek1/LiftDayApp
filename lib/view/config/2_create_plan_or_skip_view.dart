import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePlanOrSkipView extends StatefulWidget {
  const CreatePlanOrSkipView({super.key});

  @override
  State<CreatePlanOrSkipView> createState() => _CreatePlanOrSkipViewState();
}

class _CreatePlanOrSkipViewState extends State<CreatePlanOrSkipView> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<ConfigBloc>().add(const ConfigEventGoBack());
        }
      },
      child: Scaffold(
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 24.0,
              ),
              Center(
                child: Text(
                  //TODO ogarnac \n w calym kodzie
                  AppLocalizations.of(context)!.choose_workout_addition_method,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 14.0,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.change_method_later,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 44.0,
              ),
              Center(
                child: _roundedRectangleWithButton(
                  text: AppLocalizations.of(context)!.auto_assign_days,
                  buttonText: AppLocalizations.of(context)!.i_choose,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  textColor: Theme.of(context).colorScheme.primary,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    context
                        .read<ConfigBloc>()
                        .add(const ConfigEventConfirmWeekAutomation());
                  },
                ),
              ),
              const SizedBox(
                height: 34.0,
              ),
              Center(
                child: _roundedRectangleWithButton(
                  text: AppLocalizations.of(context)!.manual_assign_days,
                  buttonText: AppLocalizations.of(context)!.i_choose,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  textColor: Theme.of(context).colorScheme.primary,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    context
                        .read<ConfigBloc>()
                        .add(const ConfigEventConfirmDaysCreation());
                  },
                ),
              ),
              const SizedBox(
                height: 34.0,
              ),
              Center(
                child: _roundedRectangleWithButton(
                  text: AppLocalizations.of(context)!.manual_add_exercises,
                  buttonText: AppLocalizations.of(context)!.i_choose,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  textColor: Theme.of(context).colorScheme.primary,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  buttonTextColor: Theme.of(context).colorScheme.onPrimary,
                  onPressed: () {
                    context
                        .read<ConfigBloc>()
                        .add(const ConfigEventConfirmAllByHand());
                  },
                ),
              ),
              const SizedBox(
                height: 34.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundedRectangleWithButton({
    required String text,
    required String buttonText,
    required Color backgroundColor,
    required Color textColor,
    required Color buttonColor,
    required Color buttonTextColor,
    required VoidCallback onPressed,
    bool useGradient = false, // Dodano parametr gradientu
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, // szerokość prostokąta
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: useGradient
            ? null
            : backgroundColor, // Ustaw tło, jeśli nie gradient
        gradient: useGradient
            ? LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.tertiary
                ], // Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 16.0, color: textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  backgroundColor: buttonColor),
              child: Text(
                buttonText,
                style: TextStyle(
                    fontSize: 14.0,
                    color: buttonTextColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
