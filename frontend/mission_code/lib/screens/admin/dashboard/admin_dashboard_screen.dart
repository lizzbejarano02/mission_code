import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../design_system/cards/mission_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  static final _modules = [
    _AdminModule(Icons.people_outline,     'Usuarios',   'Gestión completa de usuarios', '/admin/usuarios',  AppColors.neonBlue),
    _AdminModule(Icons.layers_outlined,    'Niveles',    'Configurar niveles del juego',  '/admin/niveles',   AppColors.neonGreen),
    _AdminModule(Icons.quiz_outlined,      'Preguntas',  'Banco de preguntas',            '/admin/preguntas', AppColors.neonPurple),
    _AdminModule(Icons.leaderboard_outlined,'Ranking',    'Ver ranking global',            '/student/ranking', AppColors.amber),
    _AdminModule(Icons.smart_toy_outlined, 'Asistente',  'Chat con el asistente',         '/chat',            AppColors.neonBlue),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final nombre = authState is AuthAuthenticated ? authState.usuario.nombreCompleto : '';

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, nombre, ref)),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => _AdminModuleCard(module: _modules[i], index: i),
                childCount: _modules.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String nombre, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.neonPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('ADMIN', style: TextStyle(
                    color: AppColors.neonPurple, fontSize: 10, fontWeight: FontWeight.w700,
                  )),
                ),
              ]),
              const SizedBox(height: 8),
              Text(nombre, style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.w700,
              )),
              const Text('Panel de administración',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            ],
          ),
          const Spacer(),
          // Botón logout
          TextButton.icon(
            onPressed: () async => ref.read(authProvider.notifier).logout(),
            icon: const Icon(Icons.logout_outlined, color: AppColors.danger, size: 16),
            label: const Text('Salir', style: TextStyle(color: AppColors.danger, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _AdminModule {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final String route;
  final Color color;
  _AdminModule(this.icon, this.titulo, this.subtitulo, this.route, this.color);
}

class _AdminModuleCard extends StatelessWidget {
  final _AdminModule module;
  final int index;

  const _AdminModuleCard({required this.module, required this.index});

  @override
  Widget build(BuildContext context) {
    return MissionCard(
      borderColor: module.color.withOpacity(0.3),
      onTap: () => context.push(module.route),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: module.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(module.icon, color: module.color, size: 22),
          ),
          const Spacer(),
          Text(module.titulo, style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700,
          )),
          const SizedBox(height: 4),
          Text(module.subtitulo, style: const TextStyle(
            color: AppColors.textMuted, fontSize: 11,
          )),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 80 * index))
     .fadeIn().slideY(begin: 0.15);
  }
}