import 'package:liftday/sevices/settings/settings_service.dart';

class ConversionService {
  static String getPolishDayOrReturn(String dayOfWeek) {
    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      switch (dayOfWeek) {
        case 'Monday':
          return 'Poniedziałek';
        case 'Tuesday':
          return 'Wtorek';
        case 'Wednesday':
          return 'Środa';
        case 'Thursday':
          return 'Czwartek';
        case 'Friday':
          return 'Piątek';
        case 'Saturday':
          return 'Sobota';
        case 'Sunday':
          return 'Niedziela';
        default:
          return dayOfWeek;
      }
    } else {
      return dayOfWeek;
    }
  }

  static String getPolishMuscleNameOrReturn(String muscleName) {
    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      switch (muscleName) {
        case 'chest':
          return 'klatka';
        case 'back':
          return 'plecy';
        case 'arms':
          return 'ramiona';
        case 'shoulders':
          return 'barki';
        case 'legs':
          return 'nogi';
        case 'core':
          return 'brzuch';
        case 'other':
          return 'inne';
        default:
          return muscleName;
      }
    } else {
      return muscleName;
    }
  }

  static String getDayOfWeekOneLetter(String day) {
    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      switch (day) {
        case "1":
          return 'P';
        case "2":
          return 'W';
        case "3":
          return 'Ś';
        case "4":
          return 'C';
        case "5":
          return 'P';
        case "6":
          return 'S';
        case "7":
          return 'N';
        default:
          return '';
      }
    } else {
      switch (day) {
        case "1":
          return 'M';
        case "2":
          return 'T';
        case "3":
          return 'W';
        case "4":
          return 'T';
        case "5":
          return 'F';
        case "6":
          return 'S';
        case "7":
          return 'S';
        default:
          return '';
      }
    }
  }

  static String getDayOfMonthThreeLetters(String month) {
    SettingsService settingsService = SettingsService();
    if (settingsService.language() == "pl") {
      switch (month) {
        case "1":
          return 'Sty';
        case "2":
          return 'Lut';
        case "3":
          return 'Mar';
        case "4":
          return 'Kwi';
        case "5":
          return 'Maj';
        case "6":
          return 'Cze';
        case "7":
          return 'Lip';
        case "8":
          return 'Sie';
        case "9":
          return 'Wrz';
        case "10":
          return 'Paź';
        case "11":
          return 'Lis';
        case "12":
          return 'Gru';
        default:
          return '';
      }
    } else {
      switch (month) {
        case "1":
          return 'Jan';
        case "2":
          return 'Feb';
        case "3":
          return 'Mar';
        case "4":
          return 'Apr';
        case "5":
          return 'May';
        case "6":
          return 'Jun';
        case "7":
          return 'Jul';
        case "8":
          return 'Aug';
        case "9":
          return 'Sep';
        case "10":
          return 'Oct';
        case "11":
          return 'Nov';
        case "12":
          return 'Dec';
        default:
          return '';
      }
    }
  }

  static List<String> transformList(List<String> input) {
    //changes "a", "b" , "", "" , "c", "" in->>>> "", "b" , "", "" , "c", ""
    for (int i = 0; i < input.length - 1; i++) {
      if (input[i] != "" && input[i + 1] != "") {
        input[i] = "";
      }
    }
    return input;
  }

  static List<String> removeDuplicates(List<String> list) {
    //changes ["tom", "tom", "max", "max", "max", "max", "eliza"] in ->>>> [tom, "", max, "", "", "", eliza]
    List<String> result = [];
    Set<String> seen = {};

    for (String s in list) {
      if (seen.contains(s)) {
        result.add("");
      } else {
        result.add(s);
        seen.add(s);
      }
    }

    return result;
  }

  static String formatNumberInYAxis(double number) {
    if (number < 1000) {
      return number.toStringAsFixed(0);
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(number / 1000000).toStringAsFixed(1)}m';
    }
  }

  static String formatWeight(double weight) {
    if (weight == weight.toInt()) {
      return weight.toInt().toString();
    } else if (weight == double.parse(weight.toStringAsFixed(1))) {
      return weight.toStringAsFixed(1);
    } else if (weight == double.parse(weight.toStringAsFixed(2))) {
      return weight.toStringAsFixed(2);
    } else {
      return weight.toStringAsFixed(3);
    }
  }

  static int convertTimeToSeconds(String time) {
    if (!time.contains(':')) return 0;

    List<String> parts = time.split(':');
    if (parts.length != 2) return 0;

    int minutes = int.tryParse(parts[0]) ?? 0;
    int seconds = int.tryParse(parts[1]) ?? 0;

    return (minutes * 60) + seconds;
  }

  static String convertSecondsToTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    return '$formattedMinutes:$formattedSeconds';
  }
}
