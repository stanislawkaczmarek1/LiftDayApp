import 'package:flutter/material.dart';

class CreatePlanOrSkipView extends StatefulWidget {
  const CreatePlanOrSkipView({super.key});

  @override
  State<CreatePlanOrSkipView> createState() => _CreatePlanOrSkipViewState();
}

class _CreatePlanOrSkipViewState extends State<CreatePlanOrSkipView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/liftday_logo.png",
          height: 25,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 92, 225, 230)),
            child: const Text("Pomiń"),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'W kilku krokach zautomatyzujemy twój kalendarz treningowy',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  elevation: 3.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(width: 2.0, color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  "Dodaj pierwszy plan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
