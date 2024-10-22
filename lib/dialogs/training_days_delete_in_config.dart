import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_title_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> showAreYouSureToGoBackInConfigDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: AppLocalizations.of(context)!.confirm_undo,
    content: AppLocalizations.of(context)!.unsaved_workouts_warning,
    optionBuilder: () => {
      AppLocalizations.of(context)!.stay: false,
      AppLocalizations.of(context)!.cancel: true,
    },
  ).then((value) => value ?? false);
}
