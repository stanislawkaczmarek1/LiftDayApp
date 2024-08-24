import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic_dialog.dart';

Future<void> showHaveToChoosePlanDuration(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wybierz okres trwania planu",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
