import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../models/usuario_model.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../widgets/gamification/stat_card.dart';
import '../../../widgets/common/role_badge.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final nombre = authState is AuthAuthenticated
        ? authState.usuario.nombreCompleto
        : '';
    final estudiantesState = ref.watch(estudiantesProvider);
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: _buildHeader(context, nombre, ref)),
          SliverPadding(
            padding: EdgeInsets.all(isWide ? 28 : 16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats rápidas
                  _buildQuickStats(estudiantesState),
                  const SizedBox(height: 28),
                  // Lista de estudiantes
                  _buildEstudiantesSection(
                      context, estudiantesState, isWide),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, String nombre, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 22),
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.neonBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('DOCENTE',
                      style: TextStyle(
                          color: AppColors.neonBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                ),
              ]),
              const SizedBox(height: 8),
              Text(nombre,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
              const Text('Panel docente · Mission Code',
                  style: TextStyle(
                      color: AppColors.textMuted, fontSize: 13)),
            ],
          ),
          const Spacer(),
          _QuickAction(
              icon: Icons.smart_toy_outlined,
              label: 'Asistente',
              color: AppColors.neonPurple,
              onTap: () => context.push('/chat')),
          const SizedBox(width: 10),
          _QuickAction(
              icon: Icons.logout_outlined,
              label: 'Salir',
              color: AppColors.danger,
              onTap: () =>
                  ref.read(authProvider.notifier).logout()),
        ],
      ),
    );
  }

  Widget _buildQuickStats(EstudiantesState state) {
    final total = state.items.length;
    final activos =
        state.items.where((u) => u.rol == 'ESTUDIANTE').length;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.0,
      children: [
        StatCard(
          label: 'Estudiantes totales',
          value: '$total',
          icon: Icons.school_outlined,
          color: AppColors.neonBlue,
        ).animate().fadeIn(delay: 100.ms),
        StatCard(
          label: 'Estudiantes activos',
          value: '$activos',
          icon: Icons.people_outline,
          color: AppColors.neonGreen,
        ).animate().fadeIn(delay: 200.ms),
        StatCard(
          label: 'Niveles disponibles',
          value: '—',
          icon: Icons.layers_outlined,
          color: AppColors.neonPurple,
        ).animate().fadeIn(delay: 300.ms),
      ],
    );
  }

  Widget _buildEstudiantesSection(
      BuildContext context, EstudiantesState state, bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Estudiantes registrados',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            if (state.loading)
              const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.neonGreen)),
          ],
        ),
        const SizedBox(height: 16),
        if (state.error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.danger.withOpacity(0.3)),
            ),
            child: Text(state.error!,
                style: const TextStyle(
                    color: AppColors.danger, fontSize: 13)),
          )
        else if (state.items.isEmpty && !state.loading)
          _buildEmptyEstudiantes()
        else
          _buildEstudiantesList(state.items, isWide),
      ],
    );
  }

  Widget _buildEmptyEstudiantes() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.school_outlined,
              color: AppColors.textMuted, size: 48),
          SizedBox(height: 12),
          Text('No hay estudiantes registrados',
              style: TextStyle(color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildEstudiantesList(
      List<UsuarioModel> estudiantes, bool isWide) {
    if (isWide) {
      return _EstudiantesTable(estudiantes: estudiantes);
    }
    return Column(
      children: estudiantes.take(10).toList().asMap().entries.map((e) {
        final i = e.key;
        final u = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MissionCard(
            child: Row(children: [
              CircleAvatar(
                radius: 20,
                backgroundColor:
                    AppColors.neonGreen.withOpacity(0.15),
                child: Text(
                  u.nombreCompleto.isNotEmpty
                      ? u.nombreCompleto[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.nombreCompleto,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  Text(u.email,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11)),
                ],
              )),
              Text('${u.puntosTotales} XP',
                  style: const TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Orbitron')),
            ]),
          ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn(),
        );
      }).toList(),
    );
  }
}

class _EstudiantesTable extends StatelessWidget {
  final List<UsuarioModel> estudiantes;
  const _EstudiantesTable({required this.estudiantes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cabecera
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.bg900,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(children: [
            SizedBox(width: 44),
            Expanded(
                flex: 3,
                child: Text('ESTUDIANTE',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
            Expanded(
                flex: 2,
                child: Text('CÓDIGO',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
            SizedBox(
                width: 80,
                child: Text('XP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
          ]),
        ),
        // Filas
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Column(
              children: estudiantes.asMap().entries.map((e) {
                final i = e.key;
                final u = e.value;
                return _TeacherEstudianteRow(
                  usuario: u,
                  isLast: i == estudiantes.length - 1,
                  index: i,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TeacherEstudianteRow extends StatefulWidget {
  final UsuarioModel usuario;
  final bool isLast;
  final int index;
  const _TeacherEstudianteRow(
      {required this.usuario,
      required this.isLast,
      required this.index});

  @override
  State<_TeacherEstudianteRow> createState() =>
      _TeacherEstudianteRowState();
}

class _TeacherEstudianteRowState
    extends State<_TeacherEstudianteRow> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: _h ? AppColors.surface400 : AppColors.surface600,
          border: widget.isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(children: [
          SizedBox(
            width: 44,
            child: CircleAvatar(
              radius: 16,
              backgroundColor:
                  AppColors.neonGreen.withOpacity(0.15),
              child: Text(
                u.nombreCompleto.isNotEmpty
                    ? u.nombreCompleto[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.nombreCompleto,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  Text(u.email,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11)),
                ],
              )),
          Expanded(
              flex: 2,
              child: Text(u.codigoUniversitario ?? '—',
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12))),
          SizedBox(
              width: 80,
              child: Text('${u.puntosTotales}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Orbitron'))),
        ]),
      ).animate(
              delay: Duration(milliseconds: 25 * widget.index))
          .fadeIn(),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}