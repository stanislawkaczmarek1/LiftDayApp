import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showEntryExerciseMuscleDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wybierz główną grupę mięśniową",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
