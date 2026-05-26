import 'package:flutter/material.dart';
import '../../theme/colors/app_colors.dart';

class RoleBadge extends StatelessWidget {
  final String rol;
  final double fontSize;

  const RoleBadge({super.key, required this.rol, this.fontSize = 10});

  Color get _color => switch (rol) {
        'ADMINISTRADOR' => AppColors.neonPurple,
        'DOCENTE' => AppColors.neonBlue,
        'ESTUDIANTE' => AppColors.neonGreen,
        _ => AppColors.textMuted,
      };

  String get _label => switch (rol) {
        'ADMINISTRADOR' => 'Admin',
        'DOCENTE' => 'Docente',
        'ESTUDIANTE' => 'Estudiante',
        _ => rol,
      };

  IconData get _icon => switch (rol) {
        'ADMINISTRADOR' => Icons.admin_panel_settings_outlined,
        'DOCENTE' => Icons.person_outlined,
        'ESTUDIANTE' => Icons.school_outlined,
        _ => Icons.person_outline,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: fontSize, vertical: fontSize * 0.4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, color: _color, size: fontSize + 2),
          SizedBox(width: fontSize * 0.4),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}