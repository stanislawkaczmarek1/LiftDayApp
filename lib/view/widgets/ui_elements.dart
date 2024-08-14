import 'package:flutter/material.dart';
import 'package:liftday/constants/colors.dart';

typedef OnPressedFunction = void Function();

TextButton normalButton(String text, OnPressedFunction onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
        elevation: 3.0,
        backgroundColor: colorPrimaryButton,
        foregroundColor: colorSecondaryButton,
        side: const BorderSide(width: 2.0, color: colorSecondaryButton),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
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
  );
}
