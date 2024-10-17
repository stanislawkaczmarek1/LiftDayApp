import 'package:flutter/material.dart';

import 'package:liftday/dialogs/generic/generic_title_dialog.dart';

Future<bool> showCreateBackupDialog(BuildContext context) {
  return showGenericTitleDialog<bool>(
    context: context,
    title: "Informacja o bazie danych",
    content: """
Treść przewijalna: 

Zanim zdecydujesz się na udostępnienie bazy danych, chcielibyśmy Cię poinformować, że:

*Aplikacja składuje dane na twoim urządzeniu więc wykonanie 
kopii zapasowej może być przydatne np. podczas wymiany urządzenia.
*Baze danych możesz np. przesłać na własnego maila lub wybrać inną dostępną opcje udostępnienia.
*Twoja baza danych zawiera wszystkie wprowadzone przez Ciebie dane 
(m.in treningi z kalendarza, plany, rutyny, własne ćwiczenia).
*Jako użytkownik masz pełną kontrolę nad tym, co robisz z tymi danymi po ich udostępnieniu.

Kliknięcie "Udostępnij" oznacza, że wyrażasz zgodę na udostępnienie swoich danych.""",
    optionBuilder: () => {
      "Cofnij": false,
      "Udostępnij": true,
    },
  ).then((value) => value ?? false);
}
