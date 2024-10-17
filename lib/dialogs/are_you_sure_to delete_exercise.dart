import 'package:flutter/material.dart';

import 'package:liftday/dialogs/generic/generic_title_dialog.dart';

Future<bool> showAreYouSureToDeleteExerciseDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: "Usuń ćwiczenie",
    content: "Czy na pewno chcesz usunąć to ćwiczenie?",
    optionBuilder: () => {
      "Nie": false,
      "Tak": true,
    },
  ).then((value) => value ?? false);
}
