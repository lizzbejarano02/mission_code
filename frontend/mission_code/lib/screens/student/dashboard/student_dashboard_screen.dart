import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/game_provider.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../widgets/gamification/xp_bar.dart';
import '../../../widgets/gamification/stat_card.dart';
import '../../../widgets/navigation/student_sidebar.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final usuario = authState is AuthAuthenticated ? authState.usuario : null;
    final statsAsync = ref.watch(estadisticasProvider);
    final nivelesAsync = ref.watch(nivelesProvider);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: Row(
        children: [
          // Sidebar
          if (isWide) const StudentSidebar(),
          // Contenido principal
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(context, usuario?.nombreCompleto ?? '', ref),
                ),
                // Stats grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverToBoxAdapter(
                    child: statsAsync.when(
                      data: (stats) => _buildStatsGrid(stats),
                      loading: () => _buildStatsGridSkeleton(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                ),
                // XP section
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildXpSection(usuario?.puntosTotales ?? 0),
                  ),
                ),
                // Niveles disponibles
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: nivelesAsync.when(
                      data: (niveles) => _buildNivelesSection(context, niveles),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Error: $e'),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String nombre, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¡Bienvenido de nuevo!',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
              const SizedBox(height: 4),
              Text(nombre,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24, fontWeight: FontWeight.w700,
                )).animate().fadeIn().slideX(begin: -0.1),
            ],
          ),
          const Spacer(),
          // Botón chat asistente
          _ActionButton(
            icon: Icons.smart_toy_outlined,
            label: 'Asistente',
            color: AppColors.neonPurple,
            onTap: () => context.push('/chat'),
          ),
          const SizedBox(width: 12),
          // Botón ranking
          _ActionButton(
            icon: Icons.leaderboard_outlined,
            label: 'Ranking',
            color: AppColors.amber,
            onTap: () => context.push('/student/ranking'),
          ),
          const SizedBox(width: 12),
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.neonGreen.withOpacity(0.2),
            child: const Icon(Icons.person, color: AppColors.neonGreen, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: [
        StatCard(
          label: 'Preguntas respondidas',
          value: '${stats.totalPreguntasRespondidas}',
          icon: Icons.quiz_outlined,
          color: AppColors.neonBlue,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        StatCard(
          label: 'Porcentaje de acierto',
          value: '${stats.porcentajeAcierto.toStringAsFixed(0)}%',
          icon: Icons.trending_up_outlined,
          color: AppColors.neonGreen,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        StatCard(
          label: 'Misiones completadas',
          value: '${stats.totalMisionesCompletadas}',
          icon: Icons.flag_outlined,
          color: AppColors.neonPurple,
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
        StatCard(
          label: 'Racha actual',
          value: '${stats.rachaActual} 🔥',
          icon: Icons.local_fire_department_outlined,
          color: AppColors.amber,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
      ],
    );
  }

  Widget _buildStatsGridSkeleton() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.6,
      children: List.generate(4, (i) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface600,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
      ).animate(onPlay: (c) => c.repeat()).shimmer(
        color: AppColors.surface400, duration: 1200.ms,
      )),
    );
  }

  Widget _buildXpSection(int puntos) {
    final level = (puntos / 100).floor() + 1;
    final xpActual = puntos % 100;

    return MissionCard(
      borderColor: AppColors.neonGreen.withOpacity(0.3),
      glow: true,
      child: Row(
        children: [
          // Badge de nivel
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.neonGreen, AppColors.neonBlue],
              ),
            ),
            child: Center(
              child: Text('$level',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  color: AppColors.bg800,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                )),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('Nivel ', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  Text('$level', style: const TextStyle(
                    color: AppColors.neonGreen, fontSize: 12, fontWeight: FontWeight.w700,
                  )),
                  const Spacer(),
                  Text('$puntos XP total',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                ]),
                const SizedBox(height: 10),
                XpBar(currentXp: xpActual, maxXp: 100, label: 'XP'),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildNivelesSection(BuildContext context, List niveles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Niveles disponibles', style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18, fontWeight: FontWeight.w700,
            )),
            TextButton(
              onPressed: () => context.push('/student/niveles'),
              child: const Text('Ver todos', style: TextStyle(color: AppColors.neonBlue, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...niveles.take(3).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final nivel = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _NivelCard(nivel: nivel, index: i),
          );
        }),
      ],
    );
  }
}

class _NivelCard extends StatelessWidget {
  final dynamic nivel;
  final int index;

  const _NivelCard({required this.nivel, required this.index});

  static const _diffColors = {
    'BASICO':      AppColors.neonGreen,
    'INTERMEDIO':  AppColors.amber,
    'AVANZADO':    AppColors.danger,
  };

  @override
  Widget build(BuildContext context) {
    final color = _diffColors[nivel.dificultad] ?? AppColors.neonGreen;

    return MissionCard(
      borderColor: color.withOpacity(0.2),
      onTap: () => context.push('/student/niveles'),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text('${nivel.orden}',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  color: color, fontSize: 20, fontWeight: FontWeight.w700,
                )),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nivel.nombre, style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.flag_outlined, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${nivel.totalMisiones} misiones',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(nivel.dificultad, style: TextStyle(
                      color: color, fontSize: 10, fontWeight: FontWeight.w600,
                    )),
                  ),
                ]),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.textMuted, size: 14),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().slideX(begin: 0.1);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon, required this.label,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}