import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  // Pastel light theme
  const primary = Color(0xFF7C83FD);
  const secondary = Color(0xFF96BAFF);
  const background = Color(0xFFF7F8FF);

  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: secondary,
      background: background,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: 'ShantellSans',
  );

  return base.copyWith(
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: true,
      elevation: 0,
      backgroundColor: background,
      foregroundColor: Colors.black87,
    ),
    scaffoldBackgroundColor: background,
    cardTheme: base.cardTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1.5,
      margin: const EdgeInsets.all(0),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
    ),
  );
}
