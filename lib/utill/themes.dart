import 'package:automated_texbook_system/utill/colors.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  static ThemeData theme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColor.textColor),
      scaffoldBackgroundColor: AppColor.backgroundColor,
      useMaterial3: true,
      cardColor: AppColor.backgroundColor,
      appBarTheme: const AppBarTheme(backgroundColor: AppColor.backgroundColor),
      textTheme: const TextTheme(
          bodyMedium:
              TextStyle(color: AppColor.textColor, fontStyle: FontStyle.italic),
          titleMedium: TextStyle(
              color: AppColor.textColor, fontWeight: FontWeight.bold)),
      cardTheme: const CardTheme(color: AppColor.backgroundColor),
      iconTheme: const IconThemeData(color: AppColor.textColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColor.backgroundColor),
    );
  }
}
