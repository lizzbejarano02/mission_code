import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/ranking_model.dart';

class RankingScreen extends ConsumerWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingAsync = ref.watch(rankingProvider);
    final authState    = ref.watch(authProvider);
    final userId = authState is AuthAuthenticated ? authState.usuario.id : -1;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            title: const Text('🏆 Ranking Global', style: TextStyle(
              fontFamily: 'Orbitron', color: AppColors.textPrimary,
              fontSize: 18, fontWeight: FontWeight.w700,
            )),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
              onPressed: () => context.pop(),
            ),
            pinned: true,
          ),
          rankingAsync.when(
            data: (ranking) {
              if (ranking.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No hay datos de ranking',
                    style: TextStyle(color: AppColors.textMuted))),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    if (i == 0 && ranking.length >= 3) {
                      return _TopThreePodium(top3: ranking.take(3).toList())
                          .animate().fadeIn();
                    }
                    final rankIndex = i + (ranking.length >= 3 ? -1 : 0);
                    final item = ranking[rankIndex >= 0 ? rankIndex : i];
                    return _RankingTile(
                      item: item,
                      isCurrentUser: item.usuario == userId,
                      index: i,
                    );
                  },
                  childCount: ranking.length + (ranking.length >= 3 ? 1 : 0),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppColors.neonGreen)),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Error: $e',
                style: const TextStyle(color: AppColors.danger))),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopThreePodium extends StatelessWidget {
  final List<RankingModel> top3;
  const _TopThreePodium({required this.top3});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [AppColors.amber.withOpacity(0.1), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.amber.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (top3.length > 1) _PodiumItem(item: top3[1], medal: '🥈', height: 80),
          if (top3.isNotEmpty) _PodiumItem(item: top3[0], medal: '🥇', height: 100),
          if (top3.length > 2) _PodiumItem(item: top3[2], medal: '🥉', height: 65),
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final RankingModel item;
  final String medal;
  final double height;

  const _PodiumItem({required this.item, required this.medal, required this.height});

  @override
  Widget build(BuildContext context) {
    final isFirst = medal == '🥇';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(medal, style: TextStyle(fontSize: isFirst ? 36 : 28)),
        const SizedBox(height: 8),
        CircleAvatar(
          radius: isFirst ? 30 : 24,
          backgroundColor: AppColors.surface400,
          child: Text(
            item.usuarioNombre.isNotEmpty ? item.usuarioNombre[0].toUpperCase() : '?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: isFirst ? 22 : 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.usuarioNombre.split(' ').first,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isFirst ? 13 : 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text('${item.puntos} XP',
          style: TextStyle(
            color: AppColors.amber,
            fontSize: isFirst ? 12 : 10,
            fontWeight: FontWeight.w700,
          )),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.amber.withOpacity(isFirst ? 0.2 : 0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}

class _RankingTile extends StatelessWidget {
  final RankingModel item;
  final bool isCurrentUser;
  final int index;

  const _RankingTile({required this.item, required this.isCurrentUser, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.neonGreen.withOpacity(0.08)
            : AppColors.surface600,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser ? AppColors.neonGreen.withOpacity(0.4) : AppColors.border,
          width: isCurrentUser ? 1.5 : 1,
        ),
      ),
      child: Row(children: [
        // Posición
        SizedBox(
          width: 32,
          child: Text('#${item.posicion}', style: TextStyle(
            color: item.posicion <= 3 ? AppColors.amber : AppColors.textMuted,
            fontSize: 13, fontWeight: FontWeight.w700,
            fontFamily: 'Orbitron',
          )),
        ),
        const SizedBox(width: 12),
        // Avatar
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.surface400,
          child: Text(
            item.usuarioNombre.isNotEmpty ? item.usuarioNombre[0].toUpperCase() : '?',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ),
        const SizedBox(width: 12),
        // Nombre
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(item.usuarioNombre, style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500,
              )),
              if (isCurrentUser) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Tú', style: TextStyle(
                    color: AppColors.neonGreen, fontSize: 9, fontWeight: FontWeight.w700,
                  )),
                ),
              ],
            ]),
            if (item.nivelNombre != null)
              Text(item.nivelNombre!, style: const TextStyle(
                color: AppColors.textMuted, fontSize: 11,
              )),
          ]),
        ),
        // Puntos
        Text('${item.puntos}', style: const TextStyle(
          color: AppColors.neonGreen, fontSize: 15,
          fontWeight: FontWeight.w700, fontFamily: 'Orbitron',
        )),
        const SizedBox(width: 4),
        const Text('XP', style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ]),
    ).animate(delay: Duration(milliseconds: 40 * index)).fadeIn().slideX(begin: 0.05);
  }
}