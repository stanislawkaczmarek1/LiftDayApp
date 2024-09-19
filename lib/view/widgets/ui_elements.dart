import 'package:flutter/material.dart';
import 'package:liftday/constants/colors.dart';

typedef OnPressedFunction = void Function();

TextButton normalButton(String text, OnPressedFunction onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      elevation: 3.0,
      backgroundColor: colorLightGrey,
      foregroundColor: colorBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
    ),
  );
}

AppBar appBar() {
  return AppBar(
    title: Image.asset(
      "assets/liftday_logo.png",
      height: 25,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0.0,
  );
}

AppBar appBarWithButton(String text, void Function() onPressed) {
  return AppBar(
    title: Image.asset(
      "assets/liftday_logo.png",
      height: 25,
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    actions: [
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: colorBabyBlue),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18.0),
        ),
      )
    ],
  );
}
