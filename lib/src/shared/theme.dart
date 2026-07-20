import 'package:flutter/material.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: Colors.deepPurple,
  brightness: Brightness.light,
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: colorScheme,
  appBarTheme: AppBarTheme(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
    elevation: 0.0, // Modern M3 apps usually have flat app bars
  ),
  cardTheme: CardThemeData(
    elevation: 2.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Slightly rounder for M3
    ),
    clipBehavior: Clip.antiAlias, // Ensures content doesn't overflow card borders
  ),
);
