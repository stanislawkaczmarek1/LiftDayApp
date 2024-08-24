import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Błąd",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
