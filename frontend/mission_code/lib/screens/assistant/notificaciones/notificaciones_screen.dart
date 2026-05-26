import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/assistant_provider.dart';

class NotificacionesScreen extends ConsumerWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(notificacionesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            pinned: true,
            title: const Text(
              '🔔 Notificaciones',
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
            data: (notifs) => notifs.isEmpty
                ? SliverFillRemaining(child: _buildEmpty())
                : SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _NotificacionCard(
                            data: notifs[i], index: i),
                        childCount: notifs.length,
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.danger, size: 40),
                    const SizedBox(height: 12),
                    Text(e.toString(),
                        style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(notificacionesProvider),
                      child: const Text('Reintentar',
                          style: TextStyle(
                              color: AppColors.neonBlue)),
                    ),
                  ],
                ),
              ),
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
              color: AppColors.neonBlue.withOpacity(0.1),
            ),
            child: const Icon(Icons.notifications_none_outlined,
                color: AppColors.neonBlue, size: 40),
          ),
          const SizedBox(height: 20),
          const Text('Sin notificaciones',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text(
            'Cuando ganes logros o completes misiones\nverás tus notificaciones aquí.',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _NotificacionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;

  const _NotificacionCard({required this.data, required this.index});

  static const _tipoColors = {
    'LOGRO':    AppColors.amber,
    'MISION':   AppColors.neonGreen,
    'SISTEMA':  AppColors.neonBlue,
    'RANKING':  AppColors.neonPurple,
  };

  static const _tipoIcons = {
    'LOGRO':   Icons.military_tech_outlined,
    'MISION':  Icons.flag_outlined,
    'SISTEMA': Icons.info_outline,
    'RANKING': Icons.leaderboard_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final tipo = data['tipo'] as String? ?? 'SISTEMA';
    final color = _tipoColors[tipo] ?? AppColors.neonBlue;
    final icon = _tipoIcons[tipo] ?? Icons.notifications_outlined;
    final leida = data['leida'] as bool? ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: leida
            ? AppColors.surface600
            : AppColors.surface600,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: leida
              ? AppColors.border
              : color.withOpacity(0.35),
          width: leida ? 1 : 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
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
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  if (!leida)
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: color),
                    ),
                ]),
                const SizedBox(height: 4),
                Text(
                  data['mensaje'] as String? ?? '',
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn()
        .slideX(begin: 0.05);
  }
}