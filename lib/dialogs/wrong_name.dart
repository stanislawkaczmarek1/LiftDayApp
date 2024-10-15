import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showWrongNameDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Proszę wprowadź inną nazwę",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
