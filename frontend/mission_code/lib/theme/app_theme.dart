import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg800,
      colorScheme: const ColorScheme.dark(
        primary:    AppColors.neonGreen,
        secondary:  AppColors.neonBlue,
        tertiary:   AppColors.neonPurple,
        surface:    AppColors.surface600,
        error:      AppColors.danger,
        onPrimary:  AppColors.bg800,
        onSecondary: AppColors.bg800,
        onSurface:  AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.orbitron(
          fontSize: 32, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary, letterSpacing: 2,
        ),
        displayMedium: GoogleFonts.orbitron(
          fontSize: 24, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 18, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 13, fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w500,
          color: AppColors.textMuted, letterSpacing: 0.8,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface600,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface600,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neonGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        labelStyle: const TextStyle(color: AppColors.textMuted),
        hintStyle: const TextStyle(color: AppColors.textMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg800,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
    );
  }
}