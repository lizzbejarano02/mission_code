import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../models/usuario_model.dart';
import '../../../widgets/common/role_badge.dart';
import '../../../widgets/gamification/xp_bar.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../design_system/buttons/mission_button.dart';
import 'edit_user_screen.dart';

class UserDetailScreen extends StatelessWidget {
  final UsuarioModel usuario;
  const UserDetailScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final u = usuario;
    final nivel = (u.puntosTotales / 100).floor() + 1;
    final xpActual = u.puntosTotales % 100;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: SizedBox(
              width: 560,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surface600,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: AppColors.textSecondary, size: 18),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Detalle de usuario',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(),
                  const SizedBox(height: 28),

                  // Perfil principal
                  MissionCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    _rolColor(u.rol),
                                    _rolColor(u.rol).withOpacity(0.4),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  u.nombreCompleto.isNotEmpty
                                      ? u.nombreCompleto[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    u.nombreCompleto,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    u.email,
                                    style: const TextStyle(
                                        color: AppColors.textMuted,
                                        fontSize: 13),
                                  ),
                                  const SizedBox(height: 8),
                                  RoleBadge(rol: u.rol),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        XpBar(
                          currentXp: xpActual,
                          maxXp: 100,
                          label: 'Nivel $nivel • XP',
                        ),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.08),

                  const SizedBox(height: 16),

                  // Datos del perfil
                  MissionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información del perfil',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _DataRow(
                            label: 'Puntos totales',
                            value: '${u.puntosTotales} XP',
                            color: AppColors.neonGreen),
                        if (u.codigoUniversitario != null)
                          _DataRow(
                              label: 'Código universitario',
                              value: u.codigoUniversitario!),
                        if (u.carrera != null)
                          _DataRow(label: 'Carrera', value: u.carrera!),
                        _DataRow(
                          label: 'Estado',
                          value: 'Activo',
                          color: AppColors.neonGreen,
                        ),
                      ],
                    ),
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.08),

                  const SizedBox(height: 24),
                  MissionButton(
                    label: 'Editar usuario',
                    icon: Icons.edit_outlined,
                    fullWidth: true,
                    variant: MissionButtonVariant.outline,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              EditUserScreen(usuario: u)));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _rolColor(String rol) => switch (rol) {
        'ADMINISTRADOR' => AppColors.neonPurple,
        'DOCENTE' => AppColors.neonBlue,
        _ => AppColors.neonGreen,
      };
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _DataRow({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}