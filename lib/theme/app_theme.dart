import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    fontFamily: "Inter",

    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.accent,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.secondary,
      onInverseSurface: AppColors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      shape: Border(
        bottom: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.6),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
    ),

    iconTheme: IconThemeData(color: AppColors.secondary, size: 24),
  );
}
