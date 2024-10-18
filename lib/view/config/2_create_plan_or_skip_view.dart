import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_bloc.dart';
import 'package:liftday/sevices/bloc/config/config_event.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

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
              const Center(
                child: Text(
                  'Wybierz formę w jakiej\nchcesz dodawać treningi',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 14.0,
              ),
              const Center(
                child: Text(
                  '(Zawsze możesz zmienić\nformę dodawania treningów później)',
                  style: TextStyle(
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
                child: Stack(
                  children: [
                    _roundedRectangleWithButton(
                      text:
                          "Automatyczne\nprzypisanie dni treningowych\ndo dni tygodnia",
                      buttonText: "Wybieram",
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
                    Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Text(
                          'Zalecane',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 34.0,
              ),
              Center(
                child: _roundedRectangleWithButton(
                  text: """Ręczne wybieranie\ndanego dnia treningowego\n
                      w dany dzień tygodnia""",
                  buttonText: "Wybieram",
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
                  text: "Ręczne dodawanie ćwiczeń\nkażdego dnia",
                  buttonText: "Wybieram",
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
