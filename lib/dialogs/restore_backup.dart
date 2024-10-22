import 'package:flutter/material.dart';
import 'package:liftday/constants/database.dart';
import 'package:liftday/dialogs/generic/generic_title_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> showRestoreBackupDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: AppLocalizations.of(context)!.load_backup,
    content: "${AppLocalizations.of(context)!.load_backup_message}$dbName",
    optionBuilder: () => {
      AppLocalizations.of(context)!.cancel: false,
      AppLocalizations.of(context)!.load: true,
    },
  ).then((value) => value ?? false);
}
