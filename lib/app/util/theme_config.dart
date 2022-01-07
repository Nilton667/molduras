import 'package:flutter/material.dart';

mixin themeData {
  static Color themeColor = Colors.yellow.shade800;
  static Color whiteColor = Colors.white;
  static Color primaryColor = Colors.grey;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: themeColor,
    primaryColor: themeColor,
    appBarTheme: AppBarTheme(
      actionsIconTheme: IconThemeData(color: themeColor),
      iconTheme: IconThemeData(color: themeColor),
      titleTextStyle: TextStyle(
        color: themeColor,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      toolbarTextStyle: TextStyle(
        color: whiteColor,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
      color: whiteColor,
      elevation: 3.0,
    ),
    toggleableActiveColor: themeColor,
    scaffoldBackgroundColor: whiteColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryColor as MaterialColor,
    ).copyWith(secondary: themeColor),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: const Color(0xff121212),
    primaryColor: const Color(0xff1f1f1f),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xff121212),
      iconTheme: IconThemeData(color: whiteColor),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      ),
      toolbarTextStyle: TextStyle(
        color: whiteColor,
        fontWeight: FontWeight.bold,
        fontSize: 18.0,
      ),
    ),
    cardColor: const Color(0xff1f1f1f),
    scaffoldBackgroundColor: const Color(0xff121212),
    toggleableActiveColor: themeColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryColor as MaterialColor,
      brightness: Brightness.dark,
    ).copyWith(secondary: themeColor),
  );
}
