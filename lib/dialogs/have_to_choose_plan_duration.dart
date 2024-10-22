import 'package:flutter/material.dart';
import 'package:liftday/dialogs/generic/generic_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showHaveToChoosePlanDurationDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    content: AppLocalizations.of(context)!.select_plan_duration,
    optionBuilder: () => {
      AppLocalizations.of(context)!.ok: null,
    },
  );
}
