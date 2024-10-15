import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showNoDaysToLoadDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Brak dni do wczytania",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
