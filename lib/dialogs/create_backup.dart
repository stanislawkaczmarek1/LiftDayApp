import 'package:flutter/material.dart';

import 'package:liftday/dialogs/generic/generic_title_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> showCreateBackupDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: AppLocalizations.of(context)!.database_info,
    content: AppLocalizations.of(context)!.scrollable_content,
    optionBuilder: () => {
      AppLocalizations.of(context)!.cancel: false,
      AppLocalizations.of(context)!.share: true,
    },
  ).then((value) => value ?? false);
}
