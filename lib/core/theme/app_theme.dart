import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.offWhite,
    primaryColor: AppColors.violet,
    colorScheme: const ColorScheme.light(
      primary: AppColors.violet,
      secondary: AppColors.cyan,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.offWhite,
      elevation: 0,
      foregroundColor: Colors.black,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    primaryColor: AppColors.indigo,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.indigo,
      secondary: AppColors.cyan,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBg,
      elevation: 0,
    ),
  );
}
