import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/usuario_model.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/gamification/xp_bar.dart';
import '../../../widgets/common/role_badge.dart';
import '../../../widgets/common/mission_snackbar.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  bool _editando = false;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _carreraCtrl;
  late final TextEditingController _codigoCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final auth = ref.read(authProvider);
    final u = auth is AuthAuthenticated ? auth.usuario : null;
    _nombreCtrl =
        TextEditingController(text: u?.nombreCompleto ?? '');
    _carreraCtrl = TextEditingController(text: u?.carrera ?? '');
    _codigoCtrl = TextEditingController(
        text: u?.codigoUniversitario ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _carreraCtrl.dispose();
    _codigoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final auth = ref.read(authProvider);
    if (auth is! AuthAuthenticated) return;
    try {
      final data = <String, dynamic>{
        'nombre_completo': _nombreCtrl.text.trim(),
      };
      if (auth.usuario.esEstudiante) {
        data['carrera'] = _carreraCtrl.text.trim();
        data['codigo_universitario'] = _codigoCtrl.text.trim();
      }
      await ref.read(userServiceProvider).editarPerfil(data);
      if (mounted) {
        setState(() => _editando = false);
        MissionSnackbar.show(context,
            message: 'Perfil actualizado correctamente.');
      }
    } catch (e) {
      if (mounted) {
        MissionSnackbar.show(context,
            message: e.toString(), isError: true);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) {
      return const Scaffold(
        backgroundColor: AppColors.bg800,
        body: Center(
            child: CircularProgressIndicator(
                color: AppColors.neonGreen)),
      );
    }
    final u = authState.usuario;
    final statsAsync = ref.watch(estadisticasProvider);
    final nivel = (u.puntosTotales / 100).floor() + 1;
    final xpActual = u.puntosTotales % 100;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            title: const Text('Mi Perfil',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.textSecondary),
              onPressed: () => context.pop(),
            ),
            actions: [
              if (!_editando)
                TextButton.icon(
                  onPressed: () =>
                      setState(() => _editando = true),
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.neonBlue, size: 16),
                  label: const Text('Editar',
                      style: TextStyle(
                          color: AppColors.neonBlue,
                          fontSize: 13)),
                ),
            ],
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  // Card principal de perfil
                  _buildProfileCard(u, nivel, xpActual),
                  const SizedBox(height: 20),
                  // Formulario de edición o info estática
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _editando
                        ? _buildEditForm(u)
                        : _buildProfileInfo(u),
                  ),
                  const SizedBox(height: 20),
                  // Estadísticas
                  statsAsync.when(
                    data: (s) => _buildStatsSection(s),
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.neonGreen)),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 24),
                  // Botón logout
                  MissionButton(
                    label: 'Cerrar sesión',
                    icon: Icons.logout_outlined,
                    fullWidth: true,
                    variant: MissionButtonVariant.danger,
                    onPressed: () async {
                      await ref
                          .read(authProvider.notifier)
                          .logout();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
      UsuarioModel u, int nivel, int xpActual) {
    return MissionCard(
      borderColor: _rolColor(u.rol).withOpacity(0.3),
      glow: true,
      child: Column(
        children: [
          // Avatar + info principal
          Row(children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _rolColor(u.rol),
                        _rolColor(u.rol).withOpacity(0.4),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: _rolColor(u.rol)
                              .withOpacity(0.3),
                          blurRadius: 16),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      u.nombreCompleto.isNotEmpty
                          ? u.nombreCompleto[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.bg800,
                      border: Border.all(
                          color: _rolColor(u.rol), width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$nivel',
                        style: TextStyle(
                            color: _rolColor(u.rol),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Orbitron'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.nombreCompleto,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(u.email,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12)),
                  const SizedBox(height: 8),
                  Row(children: [
                    RoleBadge(rol: u.rol),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${u.puntosTotales} XP',
                          style: const TextStyle(
                              color: AppColors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Orbitron')),
                    ),
                  ]),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 18),
          XpBar(currentXp: xpActual, maxXp: 100, label: 'XP · Nivel $nivel'),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildProfileInfo(UsuarioModel u) {
    return MissionCard(
      key: const ValueKey('info'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Información del perfil',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          if (u.codigoUniversitario != null)
            _InfoRow(
                icon: Icons.badge_outlined,
                label: 'Código universitario',
                value: u.codigoUniversitario!),
          if (u.carrera != null)
            _InfoRow(
                icon: Icons.computer,
                label: 'Carrera',
                value: u.carrera!),
          _InfoRow(
              icon: Icons.star_outline,
              label: 'Puntos totales',
              value: '${u.puntosTotales} XP',
              valueColor: AppColors.neonGreen),
        ],
      ),
    );
  }

  Widget _buildEditForm(UsuarioModel u) {
    return Container(
      key: const ValueKey('form'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.neonBlue.withOpacity(0.3)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Editar perfil',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            MissionInput(
              label: 'NOMBRE COMPLETO',
              controller: _nombreCtrl,
              validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Campo requerido'
                      : null,
            ),
            if (u.esEstudiante) ...[
              const SizedBox(height: 14),
              MissionInput(
                label: 'CÓDIGO UNIVERSITARIO',
                controller: _codigoCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              MissionInput(
                label: 'CARRERA',
                controller: _carreraCtrl,
              ),
            ],
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: MissionButton(
                      label: 'Cancelar',
                      onPressed: () =>
                          setState(() => _editando = false),
                      variant: MissionButtonVariant.ghost)),
              const SizedBox(width: 12),
              Expanded(
                  child: MissionButton(
                      label: 'Guardar',
                      icon: Icons.save_outlined,
                      loading: _saving,
                      onPressed: _guardarCambios)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(stats) {
    return MissionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mis estadísticas',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _MiniStat(
                  label: 'Preguntas',
                  value:
                      '${stats.totalPreguntasRespondidas}',
                  color: AppColors.neonBlue),
              _MiniStat(
                  label: 'Aciertos',
                  value:
                      '${stats.porcentajeAcierto.toStringAsFixed(0)}%',
                  color: AppColors.neonGreen),
              _MiniStat(
                  label: 'Racha',
                  value: '${stats.rachaActual} 🔥',
                  color: AppColors.amber),
              _MiniStat(
                  label: 'Misiones',
                  value:
                      '${stats.totalMisionesCompletadas}',
                  color: AppColors.neonPurple),
            ],
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn();
  }

  Color _rolColor(String rol) => switch (rol) {
        'ADMINISTRADOR' => AppColors.neonPurple,
        'DOCENTE' => AppColors.neonBlue,
        _ => AppColors.neonGreen,
      };
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(children: [
        Icon(icon, color: AppColors.textMuted, size: 16),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 13)),
        const Spacer(),
        Text(value,
            style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(
      {required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Orbitron')),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}