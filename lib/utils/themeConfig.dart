import 'package:flutter/material.dart';

class ThemeConfig {
  //Colors for theme
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = const Color(0xff1f1f1f);
  static Color lightAccent = Colors.blue;
  static Color darkAccent = Colors.lightBlue;
  static Color lightBackground = const Color(0xfffcfcff);
  static Color darkBackground = const Color(0xff121212);
  static Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBackground,
    primaryColor: lightPrimary,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
    ).copyWith(
      secondary: lightAccent,
      primary: Colors.blue,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
        color: darkBackground,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBackground,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBackground,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );
}
