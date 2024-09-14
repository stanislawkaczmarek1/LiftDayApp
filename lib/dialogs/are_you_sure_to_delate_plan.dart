import 'package:flutter/material.dart';

import 'package:liftday/dialogs/generic_title_dialog.dart';

Future<bool> showAreYouSureToDeletePlan(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: "Czy jestes pewny/a że chcesz usunąć swój plan?",
    content:
        "Co się zmieni?\n\nPrzyszłe treningi z obecnego planu zostaną usunięte z kalendarza\n\nDni z planu treningowego w zakładce dni treningowe zostaną usunięte\n\n\nTwoje historyczne treningi pozostaną w kalendarzu",
    optionBuilder: () => {
      "Nie": false,
      "Tak": true,
    },
  ).then((value) => value ?? false);
}
