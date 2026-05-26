import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';

class InsigniasScreen extends ConsumerWidget {
  const InsigniasScreen({super.key});

  static const _insignias = [
    _InsigniaData('Primera Respuesta', '🎯', 'Responde tu primera pregunta', AppColors.neonGreen, false),
    _InsigniaData('Racha de 3 días', '🔥', 'Mantén una racha de 3 días', AppColors.amber, false),
    _InsigniaData('Nivel 1 completado', '⭐', 'Completa el nivel 1', AppColors.neonBlue, false),
    _InsigniaData('Perfeccionista', '💎', 'Responde 10 preguntas correctas', AppColors.neonPurple, false),
    _InsigniaData('Explorador', '🗺️', 'Visita todos los niveles', AppColors.neonGreen, false),
    _InsigniaData('Maestro del código', '🏆', 'Alcanza 1000 XP', AppColors.amber, false),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.bg900,
            pinned: true,
            title: const Text('🏅 Mis Insignias',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: AppColors.textSecondary),
              onPressed: () => context.pop(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _InsigniaCard(
                    data: _insignias[i], index: i),
                childCount: _insignias.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsigniaData {
  final String nombre;
  final String emoji;
  final String descripcion;
  final Color color;
  final bool desbloqueada;

  const _InsigniaData(this.nombre, this.emoji,
      this.descripcion, this.color, this.desbloqueada);
}

class _InsigniaCard extends StatelessWidget {
  final _InsigniaData data;
  final int index;

  const _InsigniaCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.desbloqueada
              ? data.color.withOpacity(0.4)
              : AppColors.border,
          width: data.desbloqueada ? 1.5 : 1,
        ),
        boxShadow: data.desbloqueada
            ? [
                BoxShadow(
                    color: data.color.withOpacity(0.12),
                    blurRadius: 12,
                    spreadRadius: 1),
              ]
            : null,
      ),
      child: Stack(
        children: [
          if (!data.desbloqueada)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                    color: AppColors.bg800.withOpacity(0.6)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data.emoji,
                    style: TextStyle(
                        fontSize: 40,
                        color: data.desbloqueada
                            ? null
                            : Colors.white.withOpacity(0.3))),
                const SizedBox(height: 12),
                Text(
                  data.nombre,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: data.desbloqueada
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.descripcion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      height: 1.4),
                ),
              ],
            ),
          ),
          if (!data.desbloqueada)
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.lock_outline,
                  color: AppColors.textMuted, size: 14),
            ),
          if (data.desbloqueada)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.color,
                    boxShadow: [
                      BoxShadow(
                          color: data.color.withOpacity(0.6),
                          blurRadius: 4),
                    ]),
              ),
            ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9));
  }
}