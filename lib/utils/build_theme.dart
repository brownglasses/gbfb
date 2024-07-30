import 'package:flutter/material.dart';
import 'package:gfbf/utils/colors.dart';
import 'package:gfbf/utils/text_style.dart';

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.cardBackground,
      dividerColor: AppColors.border,
      // textTheme: _buildTextTheme(base.textTheme),
      iconTheme: _buildIconTheme(base.iconTheme),
      buttonTheme: _buildButtonTheme(base.buttonTheme),
      appBarTheme: _buildAppBarTheme(base.appBarTheme));
}

AppBarTheme _buildAppBarTheme(AppBarTheme base) {
  return base.copyWith(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.primary,
    elevation: 0,
    titleTextStyle: AppTextStyles.headline1,
    iconTheme: base.iconTheme,
    actionsIconTheme: base.iconTheme,
  );
}

// TextTheme _buildTextTheme(TextTheme base) {
//   return base.copyWith(
//     displayLarge: base.displayLarge?.copyWith(color: AppColors.textPrimary),
//     displayMedium: base.displayMedium?.copyWith(color: AppColors.textPrimary),
//     displaySmall: base.displaySmall?.copyWith(color: AppColors.textPrimary),
//     headlineLarge: base.headlineLarge?.copyWith(color: AppColors.textPrimary),
//     headlineMedium: base.headlineMedium?.copyWith(color: AppColors.textPrimary),
//     headlineSmall: base.headlineSmall?.copyWith(color: AppColors.textPrimary),
//     titleLarge: base.titleLarge?.copyWith(color: AppColors.textPrimary),
//     titleMedium: base.titleMedium?.copyWith(color: AppColors.textPrimary),
//     titleSmall: base.titleSmall?.copyWith(color: AppColors.textSecondary),
//     bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textPrimary),
//     bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textSecondary),
//     bodySmall: base.bodySmall?.copyWith(color: AppColors.textSecondary),
//     labelLarge: base.labelLarge?.copyWith(color: AppColors.textPrimary),
//     labelMedium: base.labelMedium?.copyWith(color: AppColors.textSecondary),
//     labelSmall: base.labelSmall?.copyWith(color: AppColors.textSecondary),
//   );
// }

IconThemeData _buildIconTheme(IconThemeData base) {
  return base.copyWith(
    color: AppColors.textPrimary,
  );
}

ButtonThemeData _buildButtonTheme(ButtonThemeData base) {
  return base.copyWith(
    buttonColor: AppColors.primary,
    textTheme: ButtonTextTheme.primary,
  );
}
