import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/game_provider.dart';
import '../../../models/nivel_model.dart';
import '../../../design_system/cards/mission_card.dart';

class NivelesScreen extends ConsumerWidget {
  const NivelesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nivelesAsync = ref.watch(nivelesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            pinned: true,
            title: const Text('Niveles disponibles',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            leading: Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu,
                    color: AppColors.textSecondary),
                onPressed: () {},
              ),
            ),
          ),
          nivelesAsync.when(
            data: (niveles) => niveles.isEmpty
                ? const SliverFillRemaining(
                    child: Center(
                        child: Text('No hay niveles disponibles',
                            style: TextStyle(
                                color: AppColors.textMuted))))
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: 14),
                          child: _NivelCard(
                              nivel: niveles[i], index: i),
                        ),
                        childCount: niveles.length,
                      ),
                    ),
                  ),
            loading: () => const SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(
                      color: AppColors.neonGreen)),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                  child: Text('Error: $e',
                      style: const TextStyle(
                          color: AppColors.danger))),
            ),
          ),
        ],
      ),
    );
  }
}

class _NivelCard extends StatelessWidget {
  final NivelModel nivel;
  final int index;

  const _NivelCard({required this.nivel, required this.index});

  static const _diffColors = {
    'BASICO':     AppColors.neonGreen,
    'INTERMEDIO': AppColors.amber,
    'AVANZADO':   AppColors.danger,
  };

  @override
  Widget build(BuildContext context) {
    final color =
        _diffColors[nivel.dificultad] ?? AppColors.textMuted;

    return MissionCard(
      borderColor: color.withOpacity(0.25),
      onTap: () => context.push('/student/niveles'),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${nivel.orden}',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nivel.nombre,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(nivel.descripcion,
                    style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: color.withOpacity(0.3))),
                    child: Text(nivel.dificultad,
                        style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  Text('${nivel.totalMisiones} misiones',
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11)),
                  const SizedBox(width: 8),
                  Text('${nivel.puntosRequeridos} XP req.',
                      style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11)),
                ]),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              color: AppColors.textMuted, size: 14),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 80 * index))
        .fadeIn()
        .slideX(begin: 0.06);
  }
}