import 'package:flutter/material.dart';

const colorWhite = Colors.white;
const colorWhiteGray = Color.fromARGB(255, 244, 244, 244);
const colorLightGrey = Color.fromARGB(255, 237, 237, 237);
const colorBlack = Colors.black;
const colorBlackGray = Color.fromARGB(255, 37, 37, 37);
const colorDarkGrey = Color.fromARGB(255, 53, 53, 53);

const colorGray = Colors.grey;
const colorBabyBlue = Color.fromARGB(255, 92, 225, 230);
const colorTurquoise = Color.fromARGB(255, 2, 127, 132);
const colorCeladon = Color.fromARGB(255, 192, 241, 243);
const colorPurple = Color.fromARGB(255, 186, 72, 255);
const colorLightGreen = Color.fromRGBO(82, 255, 25, 1);

ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    background: colorWhite,
    onBackground: colorBlack,
    primary: colorBlack,
    onPrimary: colorWhite,
    secondary: colorBabyBlue,
    tertiary: colorLightGrey,
    onTertiary: colorWhiteGray,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: colorWhite,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: colorWhite,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    background: colorBlack,
    onBackground: colorWhite,
    primary: colorWhite,
    onPrimary: colorBlack,
    secondary: colorBabyBlue,
    tertiary: colorDarkGrey,
    onTertiary: colorBlackGray,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: colorBlack,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    surfaceTintColor: colorBlack,
  ),
);
