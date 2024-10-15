import 'package:flutter/material.dart';

typedef OnPressedFunction = void Function();

TextButton normalButton(
  String text,
  OnPressedFunction onPressed,
  Color backgroundColor,
  Color foregroundColor,
) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      elevation: 3.0,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
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

AppBar appBar(BuildContext context) {
  return AppBar(
    title: Theme.of(context).brightness == Brightness.dark
        ? Image.asset('assets/liftday_logo_dark.png', height: 25.0)
        : Image.asset('assets/liftday_logo.png', height: 25.0),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    elevation: 0,
    scrolledUnderElevation: 0.0,
  );
}

AppBar appBarWithButton(
  BuildContext context,
  String text,
  void Function() onPressed,
) {
  return AppBar(
    title: Theme.of(context).brightness == Brightness.dark
        ? Image.asset('assets/liftday_logo_dark.png', height: 25.0)
        : Image.asset('assets/liftday_logo.png', height: 25.0),
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    actions: [
      TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18.0),
        ),
      )
    ],
  );
}
