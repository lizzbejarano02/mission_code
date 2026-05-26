import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors/app_colors.dart';
import '../../providers/auth_provider.dart';

class StudentSidebar extends ConsumerWidget {
  const StudentSidebar({super.key});

  static final _items = [
    _SidebarItem(Icons.dashboard_outlined,  'Dashboard',  '/student'),
    _SidebarItem(Icons.layers_outlined,     'Niveles',    '/student/niveles'),
    _SidebarItem(Icons.leaderboard_outlined,'Ranking',    '/student/ranking'),
    _SidebarItem(Icons.bar_chart_outlined,  'Progreso',   '/student/progreso'),
    _SidebarItem(Icons.smart_toy_outlined,  'Asistente',  '/chat'),
    _SidebarItem(Icons.person_outlined,     'Perfil',     '/student/perfil'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 220,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.bg900,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [AppColors.neonGreen, AppColors.neonBlue],
                  ),
                ),
                child: const Icon(Icons.code, color: AppColors.bg800, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('MISSION\nCODE', style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1.2,
              )),
            ]),
          ),

          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),

          // Navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _items.map((item) {
                final isActive = location == item.route ||
                    (item.route != '/student' && location.startsWith(item.route));
                return _SidebarTile(item: item, isActive: isActive);
              }).toList(),
            ),
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.all(12),
            child: _SidebarTile(
              item: _SidebarItem(Icons.logout_outlined, 'Cerrar sesión', ''),
              isActive: false,
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
              },
              color: AppColors.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  final String route;
  _SidebarItem(this.icon, this.label, this.route);
}

class _SidebarTile extends StatefulWidget {
  final _SidebarItem item;
  final bool isActive;
  final VoidCallback? onTap;
  final Color? color;

  const _SidebarTile({
    required this.item, required this.isActive,
    this.onTap, this.color,
  });

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? (widget.isActive ? AppColors.neonGreen : AppColors.textMuted);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () {
          if (widget.item.route.isNotEmpty) context.go(widget.item.route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.neonGreen.withOpacity(0.12)
                : _hovered ? AppColors.surface600 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isActive
                ? Border.all(color: AppColors.neonGreen.withOpacity(0.3))
                : null,
          ),
          child: Row(children: [
            Icon(widget.item.icon, color: color, size: 18),
            const SizedBox(width: 10),
            Text(widget.item.label, style: TextStyle(
              color: color, fontSize: 13,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
            )),
            if (widget.isActive) ...[
              const Spacer(),
              Container(
                width: 4, height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.neonGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}