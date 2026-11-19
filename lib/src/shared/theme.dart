import 'package:material_ui/material_ui.dart';

ThemeData _buildTheme(
  Brightness brightness, {
  double contrastLevel = ContrastLevel.standard,
}) {
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: brightness,
    contrastLevel: contrastLevel,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      elevation: 0.0,
    ),
    cardTheme: CardThemeData(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
    ),
  );
}

final ThemeData appTheme = _buildTheme(Brightness.light);
final ThemeData darkAppTheme = _buildTheme(Brightness.dark);
final ThemeData highContrastAppTheme = _buildTheme(
  Brightness.light,
  contrastLevel: ContrastLevel.high,
);
final ThemeData highContrastDarkAppTheme = _buildTheme(
  Brightness.dark,
  contrastLevel: ContrastLevel.high,
);
