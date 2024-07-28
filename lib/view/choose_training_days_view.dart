import 'package:flutter/material.dart';

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
    double spacing = 10.0;
    // Ustal stały rozmiar kwadratów
    double squareSize =
        (screenWidth - (spacing * (daysOfWeek.length - 1))) / daysOfWeek.length;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/liftday_logo.png",
          height: 25,
        ),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    height: squareSize,
                    decoration: BoxDecoration(
                      color: selectedDays[index]
                          ? const Color.fromARGB(255, 92, 225, 230)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: selectedDays[index]
                            ? const Color.fromARGB(255, 92, 225, 230)
                            : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        daysOfWeek[index],
                        style: TextStyle(
                          color:
                              selectedDays[index] ? Colors.white : Colors.black,
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
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              elevation: 3.0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(width: 2.0, color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Dalej",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
