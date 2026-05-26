import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Fondos
  static const Color bg900 = Color(0xFF0B1120);
  static const Color bg800 = Color(0xFF0F172A);
  static const Color bg700 = Color(0xFF111827);

  // Superficies/Tarjetas
  static const Color surface600 = Color(0xFF1E293B);
  static const Color surface500 = Color(0xFF1F2937);
  static const Color surface400 = Color(0xFF243447);

  // Primarios
  static const Color neonGreen    = Color(0xFF22C55E);
  static const Color neonBlue     = Color(0xFF38BDF8);
  static const Color neonPurple   = Color(0xFF8B5CF6);

  // Secundarios
  static const Color amber        = Color(0xFFF59E0B);
  static const Color danger       = Color(0xFFEF4444);

  // Texto
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted     = Color(0xFF64748B);

  // Bordes
  static const Color border       = Color(0xFF1E293B);
  static const Color borderLight  = Color(0xFF334155);

  // Glows (con opacidad)
  static Color greenGlow  = neonGreen.withOpacity(0.25);
  static Color blueGlow   = neonBlue.withOpacity(0.25);
  static Color purpleGlow = neonPurple.withOpacity(0.25);
  static Color amberGlow  = amber.withOpacity(0.25);

  // XP Bar
  static const Color xpFill  = neonGreen;
  static const Color xpTrack = Color(0xFF1E293B);

  // Roles
  static const Color roleAdmin    = neonPurple;
  static const Color roleDocente  = neonBlue;
  static const Color roleEstudiante = neonGreen;

  // Correcta / Incorrecta
  static const Color correct   = neonGreen;
  static const Color incorrect = danger;
}