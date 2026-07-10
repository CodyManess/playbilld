import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF6200EE);
const Color primaryVariantColor = Color(0xFF3700B3);
const Color secondaryColor = Color(0xFF03DAC6);
const Color secondaryVariantColor = Color(0xFF018786);
const Color backgroundColor = Color(0xFFFFFFFF);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFB00020);

const ColorScheme colorScheme = ColorScheme(
  primary: primaryColor,
  primaryContainer: primaryVariantColor,
  secondary: secondaryColor,
  secondaryContainer: secondaryVariantColor,
  surface: surfaceColor,
  error: errorColor,
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

final ThemeData appTheme = ThemeData(
  colorScheme: colorScheme,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 4.0,
  ),
  cardTheme: CardThemeData(
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
    ),
  ),
);
