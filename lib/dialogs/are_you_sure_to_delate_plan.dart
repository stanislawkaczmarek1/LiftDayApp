import 'package:flutter/material.dart';

import 'package:liftday/dialogs/generic/generic_title_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> showAreYouSureToDeletePlanDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: AppLocalizations.of(context)!.confirm_plan_removal,
    content: AppLocalizations.of(context)!.future_workouts_warning,
    optionBuilder: () => {
      AppLocalizations.of(context)!.no: false,
      AppLocalizations.of(context)!.yes: true,
    },
  ).then((value) => value ?? false);
}
