
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants{
  // Name
  static String appName = "Future Kids School";

  // Material Design Color
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color lightAccent = Colors.cyan;
  static Color lightBackground = const Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Colors.cyan;
  static Color darkBackground = Colors.black;

  static Color grey = const Color(0xff707070);
  static Color textPrimary = const Color(0xFF486581);
  static Color textDark = const Color(0xFF102A43);

  static Color backgroundColor = const Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = const Color(0xFF3ABD6F);
  static Color lightGreen = const Color(0xFFA1ECBF);

  // Yellow
  static Color darkYellow = const Color(0xFF3ABD6F);
  static Color lightYellow = const Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Colors.cyan;
  static Color lightBlue = const Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = const Color(0xFFFFB74D);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: lightAccent,
        ), toolbarTextStyle: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).bodyMedium, titleTextStyle: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).titleLarge,
      ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightAccent),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 30.0;
}