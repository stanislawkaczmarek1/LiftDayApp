import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';

Future<void> showUnavailableOperationDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: "Przepraszamy ta operacja jest niedostępna",
    optionBuilder: () => {
      "Ok": null,
    },
  );
}
