import 'package:flutter/material.dart';
import 'package:liftday/ui_constants/colors.dart';

typedef OnPressedFunction = void Function();

TextButton normalButton(String text, OnPressedFunction onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      elevation: 3.0,
      backgroundColor: colorPrimaryButton,
      foregroundColor: colorSecondaryButton,
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
  );
}
