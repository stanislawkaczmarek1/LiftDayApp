import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showHaveToChoosePlanDurationDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wybierz okres trwania planu",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
