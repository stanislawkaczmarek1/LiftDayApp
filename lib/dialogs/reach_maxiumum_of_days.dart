import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showReachMaxiumumOfRoutinesDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Wprowadzono maksymalną liczbę rutyn",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
