import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );

  static TextStyle bodyLight = TextStyle(
    fontSize: 16,
    color: AppColors.textLight,
  );

  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.textLight,
  );
} 