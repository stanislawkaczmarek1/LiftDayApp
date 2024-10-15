import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showEntryExerciseNameAndMuscleDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wpisz nazwę ćwiczenia i wybierz główną grupę mięśniową",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
