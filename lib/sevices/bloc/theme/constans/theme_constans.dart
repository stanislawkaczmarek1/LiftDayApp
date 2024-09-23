import 'package:flutter/material.dart';

const colorWhite = Colors.white;
const colorBlack = Colors.black;
const colorLightGrey = Color.fromARGB(255, 242, 242, 242);
const colorDarkGrey = Color.fromARGB(255, 53, 53, 53);
const colorGray = Colors.grey;
const colorBabyBlue = Color.fromARGB(255, 92, 225, 230);
const colorTurquoise = Color.fromARGB(255, 2, 127, 132);
const colorCeladon = Color.fromARGB(255, 192, 241, 243);

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    background: colorWhite,
    onBackground: colorBlack,
    primary: colorBlack,
    onPrimary: colorWhite,
    secondary: colorBabyBlue,
    tertiary: colorLightGrey,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: colorWhite,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    background: colorBlack,
    onBackground: colorWhite,
    primary: colorWhite,
    onPrimary: colorBlack,
    secondary: colorWhite,
    tertiary: colorDarkGrey,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: colorBlack,
  ),
);
