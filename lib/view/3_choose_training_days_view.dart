import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liftday/constants/colors.dart';
import 'package:liftday/sevices/bloc/app_bloc.dart';
import 'package:liftday/sevices/bloc/app_event.dart';
import 'package:liftday/view/ui_elements.dart';

class ChooseTrainingDaysView extends StatefulWidget {
  const ChooseTrainingDaysView({super.key});

  @override
  State<ChooseTrainingDaysView> createState() => _ChooseTrainingDaysViewState();
}

class _ChooseTrainingDaysViewState extends State<ChooseTrainingDaysView> {
  final List<String> daysOfWeek = [
    'Pon',
    'Wt',
    'Śr',
    'Czw',
    'Pt',
    'Sob',
    'Nd',
  ];

  final List<bool> selectedDays = List<bool>.filled(7, false);

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
          context.read<AppBloc>().add(const AppEventGoBack());
        }
      },
      child: Scaffold(
        appBar: appBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Wybierz swoje dni treningowe',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                        color: selectedDays[index] ? colorAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color:
                              selectedDays[index] ? colorAccent : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          daysOfWeek[index],
                          style: TextStyle(
                            color: selectedDays[index]
                                ? Colors.white
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
              "Dalej",
              () {
                context
                    .read<AppBloc>()
                    .add(const AppEventConfirmTrainingDays());
              },
            )
          ],
        ),
      ),
    );
  }
}
