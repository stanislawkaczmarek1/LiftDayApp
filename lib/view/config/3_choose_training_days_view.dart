import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/sevices/bloc/config_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/dialogs/have_to_choose_training_days.dart';
import 'package:liftday/view/widgets/ui_elements.dart';

class ChooseTrainingDaysView extends StatefulWidget {
  const ChooseTrainingDaysView({super.key});

  @override
  State<ChooseTrainingDaysView> createState() => _ChooseTrainingDaysViewState();
}

class _ChooseTrainingDaysViewState extends State<ChooseTrainingDaysView> {
  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> daysOfWeekToDisplay = [
    'Pon',
    'Wt',
    'Śr',
    'Czw',
    'Pt',
    'Sob',
    'Nd',
  ];

  final List<bool> selectedDays = List<bool>.filled(7, false);

  List<String> _convertDaysBoolToString() {
    List<String> confirmedDays = [];
    for (var i = 0; i < 7; i++) {
      if (selectedDays[i]) {
        confirmedDays.add(daysOfWeek[i]);
      }
    }
    return confirmedDays;
  }

  @override
  Widget build(BuildContext context) {
    // Pobierz szerokość ekranu
    double screenWidth = MediaQuery.of(context).size.width;
    // Ustal rozmiar przerwy między kwadratami
    double spacing = 8.0;
    // Ustal stały rozmiar kwadratów
    double listPadding = 16.0;
    // Ustal rozmiar marginesu listy
    double squareSize =
        (screenWidth - 2 * listPadding - (spacing * (daysOfWeek.length - 1))) /
            daysOfWeek.length;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.read<ConfigBloc>().add(const ConfigEventGoBack());
        }
      },
      child: Scaffold(
        appBar: appBar(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Wybierz swoje dni treningowe',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: listPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(daysOfWeek.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDays[index] =
                            !selectedDays[index]; // Zmiana stanu zaznaczenia
                      });
                    },
                    child: Container(
                      width: squareSize,
                      height: 1.5 * squareSize,
                      decoration: BoxDecoration(
                        color: selectedDays[index]
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: selectedDays[index]
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          daysOfWeekToDisplay[index],
                          style: TextStyle(
                            color: selectedDays[index]
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            normalButton(
              context,
              "Dalej",
              () {
                final List<String> confirmedDays = _convertDaysBoolToString();
                if (confirmedDays.isNotEmpty) {
                  context
                      .read<ConfigBloc>()
                      .add(ConfigEventConfirmTrainingDays(confirmedDays));
                } else {
                  showHaveToChooseTrainingDays(context);
                }
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
