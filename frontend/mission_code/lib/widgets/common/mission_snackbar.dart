import 'package:flutter/material.dart';
import '../../theme/colors/app_colors.dart';

class MissionSnackbar {
  MissionSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    bool isWarning = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    final color = isError
        ? AppColors.danger
        : isWarning
            ? AppColors.amber
            : AppColors.neonGreen;
    final icon = isError
        ? Icons.error_outline
        : isWarning
            ? Icons.warning_amber_outlined
            : Icons.check_circle_outline;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface600,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}