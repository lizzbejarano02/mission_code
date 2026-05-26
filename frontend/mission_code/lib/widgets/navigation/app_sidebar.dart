import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../models/usuario_model.dart';
import '../../routes/app_router.dart' show homeForRole;

// ─── Modelo de ítem de navegación ────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final Color accentColor;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.accentColor,
  });
}

// ─── Ítems por rol ────────────────────────────────────
const _estudianteItems = [
  _NavItem(icon: Icons.dashboard_outlined,     label: 'Dashboard',  route: '/student',           accentColor: AppColors.neonGreen),
  _NavItem(icon: Icons.layers_outlined,         label: 'Niveles',    route: '/student/niveles',   accentColor: AppColors.neonBlue),
  _NavItem(icon: Icons.bar_chart_outlined,      label: 'Progreso',   route: '/student/progreso',  accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.leaderboard_outlined,    label: 'Ranking',    route: '/student/ranking',   accentColor: AppColors.amber),
  _NavItem(icon: Icons.military_tech_outlined,  label: 'Insignias',  route: '/student/insignias', accentColor: AppColors.amber),
  _NavItem(icon: Icons.smart_toy_outlined,      label: 'Asistente',  route: '/chat',              accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.person_outlined,         label: 'Perfil',     route: '/student/perfil',    accentColor: AppColors.neonGreen),
];

const _docenteItems = [
  _NavItem(icon: Icons.dashboard_outlined,  label: 'Dashboard',    route: '/teacher',             accentColor: AppColors.neonBlue),
  _NavItem(icon: Icons.school_outlined,     label: 'Estudiantes',  route: '/teacher/estudiantes', accentColor: AppColors.neonGreen),
  _NavItem(icon: Icons.analytics_outlined,  label: 'Estadísticas', route: '/teacher/estadisticas',accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.summarize_outlined,  label: 'Reportes',     route: '/teacher/reportes',    accentColor: AppColors.amber),
  _NavItem(icon: Icons.smart_toy_outlined,  label: 'Asistente',    route: '/chat',                accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.person_outlined,     label: 'Perfil',       route: '/student/perfil',      accentColor: AppColors.neonGreen),
];

const _adminItems = [
  _NavItem(icon: Icons.dashboard_outlined,       label: 'Dashboard',    route: '/admin',              accentColor: AppColors.neonGreen),
  _NavItem(icon: Icons.people_outline,           label: 'Usuarios',     route: '/admin/usuarios',     accentColor: AppColors.neonBlue),
  _NavItem(icon: Icons.layers_outlined,          label: 'Niveles',      route: '/admin/niveles',      accentColor: AppColors.neonGreen),
  _NavItem(icon: Icons.quiz_outlined,            label: 'Preguntas',    route: '/admin/preguntas',    accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.check_box_outlined,       label: 'Respuestas',   route: '/admin/respuestas',   accentColor: AppColors.neonBlue),
  _NavItem(icon: Icons.flag_outlined,            label: 'Misiones',     route: '/admin/misiones',     accentColor: AppColors.amber),
  _NavItem(icon: Icons.analytics_outlined,       label: 'Estadísticas', route: '/admin/estadisticas', accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.smart_toy_outlined,       label: 'Asistente',    route: '/chat',               accentColor: AppColors.neonPurple),
  _NavItem(icon: Icons.settings_outlined,        label: 'Config.',      route: '/admin/config',       accentColor: AppColors.textMuted),
];

List<_NavItem> _itemsForRole(String rol) {
  if (rol == 'ADMINISTRADOR') return _adminItems;
  if (rol == 'DOCENTE') return _docenteItems;
  return _estudianteItems;
}

// ─── Sidebar principal ────────────────────────────────
class AppSidebar extends ConsumerStatefulWidget {
  const AppSidebar({super.key});

  @override
  ConsumerState<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends ConsumerState<AppSidebar>
    with SingleTickerProviderStateMixin {
  bool _collapsed = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  static const double _expanded = 220;
  static const double _collapsed2 = 64;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _anim = Tween<double>(begin: _expanded, end: _collapsed2)
        .animate(CurvedAnimation(
            parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _collapsed = !_collapsed);
    _collapsed ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    if (authState is! AuthAuthenticated) return const SizedBox.shrink();

    final usuario = authState.usuario;
    final items = _itemsForRole(usuario.rol);
    final location = GoRouterState.of(context).matchedLocation;

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final w = _anim.value;
        final showLabel = w > 120;

        return Container(
          width: w,
          decoration: const BoxDecoration(
            color: AppColors.bg900,
            border: Border(
              right: BorderSide(color: AppColors.border),
            ),
          ),
          child: Column(
            children: [
              _buildLogo(showLabel),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8),
                  children: items.map((item) {
                    final isActive = _isActive(location, item.route);
                    return _SidebarTile(
                      item: item,
                      isActive: isActive,
                      showLabel: showLabel,
                      onTap: () => context.go(item.route),
                    );
                  }).toList(),
                ),
              ),
              _buildFooter(usuario, showLabel),
            ],
          ),
        );
      },
    );
  }

  bool _isActive(String location, String route) {
    if (route == '/student' ||
        route == '/teacher' ||
        route == '/admin') {
      return location == route;
    }
    return location.startsWith(route);
  }

  Widget _buildLogo(bool showLabel) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: showLabel
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [AppColors.neonGreen, AppColors.neonBlue],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withOpacity(0.25),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.code,
                  color: AppColors.bg800, size: 20),
            ),
            if (showLabel) ...[
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'MISSION\nCODE',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ),
              Icon(
                _collapsed
                    ? Icons.chevron_right
                    : Icons.chevron_left,
                color: AppColors.textMuted,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(UsuarioModel usuario, bool showLabel) {
    return Column(
      children: [
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _SidebarTile(
            item: const _NavItem(
              icon: Icons.logout_outlined,
              label: 'Salir',
              route: '',
              accentColor: AppColors.danger,
            ),
            isActive: false,
            showLabel: showLabel,
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ),
        const SizedBox(height: 12),
        showLabel
            ? Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Row(children: [
                  _avatar(usuario, 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario.nombreCompleto.split(' ').first,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          usuario.rol,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _avatar(usuario, 14),
              ),
      ],
    );
  }

  Widget _avatar(UsuarioModel u, double radius) {
    final initial =
        u.nombreCompleto.isNotEmpty ? u.nombreCompleto[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.neonGreen.withOpacity(0.2),
      child: Text(
        initial,
        style: TextStyle(
          color: AppColors.neonGreen,
          fontSize: radius * 0.9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Tile de sidebar ──────────────────────────────────
class _SidebarTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final bool showLabel;
  final VoidCallback onTap;

  const _SidebarTile({
    required this.item,
    required this.isActive,
    required this.showLabel,
    required this.onTap,
  });

  @override
  State<_SidebarTile> createState() => _SidebarTileState();
}

class _SidebarTileState extends State<_SidebarTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? widget.item.accentColor
        : AppColors.textMuted;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 2),
          padding: EdgeInsets.symmetric(
            horizontal: widget.showLabel ? 12 : 0,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? widget.item.accentColor.withOpacity(0.1)
                : _hovered
                    ? AppColors.surface600.withOpacity(0.6)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: widget.isActive
                ? Border.all(
                    color:
                        widget.item.accentColor.withOpacity(0.25))
                : null,
          ),
          child: widget.showLabel
              ? Row(children: [
                  Icon(widget.item.icon, color: color, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.item.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: widget.isActive
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (widget.isActive)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: widget.item.accentColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.item.accentColor
                                .withOpacity(0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                ])
              : Center(
                  child: Tooltip(
                    message: widget.item.label,
                    child:
                        Icon(widget.item.icon, color: color, size: 20),
                  ),
                ),
        ),
      ),
    );
  }
}