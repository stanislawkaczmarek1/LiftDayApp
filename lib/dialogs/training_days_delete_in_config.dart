import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_title_dialog.dart';

Future<bool> showAreYouSureToGoBackInConfigDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: "Czy jestes pewny/a że chcesz cofnąć?",
    content:
        "Twoje wprowadzone treningi jeszcze nie zostały zapisane\n\nJeśli chcesz edytować poprzednie wprowadzone dni\nbędziesz mógł/mogła to zrobić później w aplikacji",
    optionBuilder: () => {
      "Zostań": false,
      "Cofnij": true,
    },
  ).then((value) => value ?? false);
}
