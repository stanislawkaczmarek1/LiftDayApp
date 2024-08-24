import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic_dialog.dart';

Future<void> showHaveToChooseTrainingDays(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wybierz dni treningowe",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
