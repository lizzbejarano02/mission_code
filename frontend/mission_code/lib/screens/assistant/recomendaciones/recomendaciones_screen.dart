import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/assistant_provider.dart';

class RecomendacionesScreen extends ConsumerWidget {
  const RecomendacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(recomendacionesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            pinned: true,
            title: const Text(
              '💡 Recomendaciones',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.textSecondary),
              onPressed: () => context.pop(),
            ),
          ),
          async.when(
            data: (recs) => recs.isEmpty
                ? SliverFillRemaining(child: _buildEmpty())
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _RecomendacionCard(
                          data: recs[i],
                          index: i,
                        ),
                        childCount: recs.length,
                      ),
                    ),
                  ),
            loading: () => const SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(
                      color: AppColors.neonGreen)),
            ),
            error: (e, _) => SliverFillRemaining(
              child: _buildError(ref, e.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonPurple.withOpacity(0.1),
            ),
            child: const Icon(Icons.lightbulb_outline,
                color: AppColors.neonPurple, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin recomendaciones aún',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Completa algunas misiones y el\nasistente te dará recomendaciones.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildError(WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline,
              color: AppColors.danger, size: 48),
          const SizedBox(height: 12),
          Text(error,
              style: const TextStyle(
                  color: AppColors.danger, fontSize: 13)),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () =>
                ref.invalidate(recomendacionesProvider),
            child: const Text('Reintentar',
                style:
                    TextStyle(color: AppColors.neonBlue)),
          ),
        ],
      ),
    );
  }
}

class _RecomendacionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;

  const _RecomendacionCard({required this.data, required this.index});

  static const _tipoColors = {
    'MISION':     AppColors.neonGreen,
    'REPASO':     AppColors.neonBlue,
    'MOTIVACION': AppColors.amber,
    'ALERTA':     AppColors.danger,
  };

  static const _tipoIcons = {
    'MISION':     Icons.flag_outlined,
    'REPASO':     Icons.replay_outlined,
    'MOTIVACION': Icons.emoji_events_outlined,
    'ALERTA':     Icons.warning_amber_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final tipo = data['tipo'] as String? ?? 'MOTIVACION';
    final color = _tipoColors[tipo] ?? AppColors.neonGreen;
    final icon = _tipoIcons[tipo] ?? Icons.lightbulb_outline;
    final leida = data['leida'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: leida
              ? AppColors.border
              : color.withOpacity(0.35),
          width: leida ? 1 : 1.5,
        ),
        boxShadow: leida
            ? null
            : [
                BoxShadow(
                    color: color.withOpacity(0.06),
                    blurRadius: 12,
                    spreadRadius: 1),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                    child: Text(
                      data['titulo'] as String? ?? '',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!leida)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        boxShadow: [
                          BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 4),
                        ],
                      ),
                    ),
                ]),
                const SizedBox(height: 6),
                Text(
                  data['contenido'] as String? ?? '',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    tipo.replaceAll('_', ' '),
                    style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn()
        .slideY(begin: 0.1);
  }
}