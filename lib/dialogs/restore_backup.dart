import 'package:flutter/material.dart';
import 'package:liftday/constants/database.dart';

import 'package:liftday/dialogs/generic/generic_title_dialog.dart';

Future<bool> showRestoreBackupDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: "Wczytaj kopie zapasową",
    content:
        """Po kliknięciu "Wczytaj" wybierz wcześniej zapisany plik o nazwie" $dbName""",
    optionBuilder: () => {
      "Cofnij": false,
      "Wczytaj": true,
    },
  ).then((value) => value ?? false);
}
