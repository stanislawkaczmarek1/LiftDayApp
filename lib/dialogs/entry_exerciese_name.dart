import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showEntryExerciseNameDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wpisz nazwę ćwiczenia",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
