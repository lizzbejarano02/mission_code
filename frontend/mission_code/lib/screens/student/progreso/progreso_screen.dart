import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/progreso_model.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../widgets/gamification/xp_bar.dart';
import '../../../widgets/gamification/stat_card.dart';

class ProgresoScreen extends ConsumerWidget {
  const ProgresoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progresoAsync = ref.watch(progresoProvider);
    final statsAsync = ref.watch(estadisticasProvider);
    final authState = ref.watch(authProvider);
    final puntos = authState is AuthAuthenticated
        ? authState.usuario.puntosTotales
        : 0;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            title: const Text('Mi Progreso',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.textSecondary),
              onPressed: () => context.pop(),
            ),
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // XP y nivel
                  _buildXpNivelCard(puntos),
                  const SizedBox(height: 20),
                  // Stats grid
                  statsAsync.when(
                    data: (stats) => _buildStatsGrid(stats),
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.neonGreen)),
                    error: (e, _) => Text('Error: $e',
                        style: const TextStyle(
                            color: AppColors.danger)),
                  ),
                  const SizedBox(height: 24),
                  // Historial de progreso
                  const Text('Historial de misiones',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  progresoAsync.when(
                    data: (progreso) =>
                        _buildProgresoList(progreso),
                    loading: () => _buildSkeleton(),
                    error: (e, _) => Text('Error: $e',
                        style: const TextStyle(
                            color: AppColors.danger)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXpNivelCard(int puntos) {
    final nivel = (puntos / 100).floor() + 1;
    final xpActual = puntos % 100;
    final xpSiguiente = nivel * 100;

    return MissionCard(
      borderColor: AppColors.neonGreen.withOpacity(0.3),
      glow: true,
      child: Column(
        children: [
          Row(children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    AppColors.neonGreen,
                    AppColors.neonBlue
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.neonGreen.withOpacity(0.4),
                      blurRadius: 16)
                ],
              ),
              child: Center(
                child: Text('$nivel',
                    style: const TextStyle(
                        fontFamily: 'Orbitron',
                        color: AppColors.bg800,
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nivel $nivel',
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('$puntos XP acumulados',
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13)),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 18),
          XpBar(currentXp: xpActual, maxXp: 100),
          const SizedBox(height: 6),
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('$xpActual XP',
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11)),
                Text('$xpSiguiente XP → Nivel ${nivel + 1}',
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11)),
              ]),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05);
  }

  Widget _buildStatsGrid(stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.8,
      children: [
        StatCard(
          label: 'Respuestas correctas',
          value: '${stats.totalRespuestasCorrectas}',
          icon: Icons.check_circle_outline,
          color: AppColors.neonGreen,
          subtitle: '${stats.porcentajeAcierto.toStringAsFixed(0)}%',
        ).animate().fadeIn(delay: 100.ms),
        StatCard(
          label: 'Misiones completadas',
          value: '${stats.totalMisionesCompletadas}',
          icon: Icons.flag_outlined,
          color: AppColors.neonPurple,
        ).animate().fadeIn(delay: 200.ms),
        StatCard(
          label: 'Racha actual',
          value: '${stats.rachaActual} 🔥',
          icon: Icons.local_fire_department_outlined,
          color: AppColors.amber,
          subtitle: 'Máx: ${stats.rachaMaxima}',
        ).animate().fadeIn(delay: 300.ms),
        StatCard(
          label: 'Niveles completados',
          value: '${stats.totalNivelesCompletados}',
          icon: Icons.layers_outlined,
          color: AppColors.neonBlue,
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildProgresoList(List<ProgresoModel> progreso) {
    if (progreso.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.surface600,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          children: [
            Icon(Icons.bar_chart_outlined,
                color: AppColors.textMuted, size: 48),
            SizedBox(height: 12),
            Text('Sin historial de progreso aún',
                style:
                    TextStyle(color: AppColors.textMuted)),
            SizedBox(height: 6),
            Text('Completa misiones para ver tu progreso aquí.',
                style: TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ).animate().fadeIn();
    }

    return Column(
      children: progreso.asMap().entries.map((e) {
        final i = e.key;
        final p = e.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ProgresoCard(progreso: p),
        ).animate(delay: Duration(milliseconds: 50 * i)).fadeIn();
      }).toList(),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      children: List.generate(
          4,
          (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.surface600,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.border),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .shimmer(
                        color: AppColors.surface400,
                        duration: 1000.ms),
              )),
    );
  }
}

class _ProgresoCard extends StatelessWidget {
  final ProgresoModel progreso;
  const _ProgresoCard({required this.progreso});

  Color get _estadoColor => switch (progreso.estado) {
        'COMPLETADO' => AppColors.neonGreen,
        'EN_PROGRESO' => AppColors.amber,
        _ => AppColors.textMuted,
      };

  String get _estadoLabel => switch (progreso.estado) {
        'COMPLETADO' => 'Completado',
        'EN_PROGRESO' => 'En progreso',
        _ => 'No iniciado',
      };

  IconData get _estadoIcon => switch (progreso.estado) {
        'COMPLETADO' => Icons.check_circle_outline,
        'EN_PROGRESO' => Icons.hourglass_bottom_outlined,
        _ => Icons.radio_button_unchecked,
      };

  @override
  Widget build(BuildContext context) {
    final pct = progreso.porcentajeCompletado / 100;

    return MissionCard(
      borderColor: _estadoColor.withOpacity(0.25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(_estadoIcon, color: _estadoColor, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(progreso.misionNombre,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  Text(progreso.nivelNombre,
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11)),
                ],
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${progreso.puntosObtenidos} XP',
                  style: const TextStyle(
                      color: AppColors.amber,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _estadoColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(_estadoLabel,
                    style: TextStyle(
                        color: _estadoColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600)),
              ),
            ]),
          ]),
          if (progreso.estado == 'EN_PROGRESO') ...[
            const SizedBox(height: 10),
            XpBar(
              currentXp: (pct * 100).toInt(),
              maxXp: 100,
              label:
                  '${progreso.porcentajeCompletado.toStringAsFixed(0)}% completado',
              animated: false,
            ),
          ],
        ],
      ),
    );
  }
}