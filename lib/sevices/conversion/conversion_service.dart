class ConversionService {
  static final ConversionService _shared = ConversionService._sharedInstance();
  ConversionService._sharedInstance();
  factory ConversionService() => _shared;

  String getDayOfWeekOneLetter(String day) {
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

  String getDayOfMonthThreeLetters(String month) {
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

  List<String> transformList(List<String> input) {
    //zamienia "a", "b" , "", "" , "c", "" na->>>> "", "b" , "", "" , "c", ""
    for (int i = 0; i < input.length - 1; i++) {
      if (input[i] != "" && input[i + 1] != "") {
        input[i] = "";
      }
    }
    return input;
  }

  List<String> removeDuplicates(List<String> list) {
    //zamienia ["tom", "tom", "max", "max", "max", "max", "eliza"] na ->>>> [tom, "", max, "", "", "", eliza]
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

  String formatNumberInYAxis(double number) {
    if (number < 1000) {
      return number.toStringAsFixed(0);
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(number / 1000000).toStringAsFixed(1)}m';
    }
  }
}
