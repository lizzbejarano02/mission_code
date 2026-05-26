import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/user_provider.dart';
import '../../../models/usuario_model.dart';
import '../../../widgets/common/role_badge.dart';
import '../../../widgets/common/mission_snackbar.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/cards/mission_card.dart';
import 'create_user_screen.dart';
import 'edit_user_screen.dart';
import 'user_detail_screen.dart';

class UsersCrudScreen extends ConsumerStatefulWidget {
  const UsersCrudScreen({super.key});

  @override
  ConsumerState<UsersCrudScreen> createState() => _UsersCrudScreenState();
}

class _UsersCrudScreenState extends ConsumerState<UsersCrudScreen> {
  final _searchCtrl = TextEditingController();
  String _rolFilter = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(estudiantesProvider);
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isWide),
          _buildFiltersBar(isWide),
          Expanded(
            child: state.loading
                ? _buildSkeleton()
                : state.error != null
                    ? _buildError(state.error!)
                    : state.filtered.isEmpty
                        ? _buildEmpty(isWide)
                        : isWide
                            ? _buildTable(state.filtered)
                            : _buildMobileList(state.filtered),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    final total = ref.watch(estudiantesProvider).items.length;

    return Container(
      padding: EdgeInsets.fromLTRB(isWide ? 28 : 16, 24, isWide ? 28 : 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary, size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Gestión de Usuarios',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$total usuarios registrados',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          MissionButton(
            label: 'Nuevo usuario',
            icon: Icons.add,
            onPressed: () => _openCreate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 28 : 16,
        vertical: 12,
      ),
      color: AppColors.bg900,
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildSearchField()),
                const SizedBox(width: 12),
                SizedBox(width: 180, child: _buildRolDropdown()),
                const SizedBox(width: 12),
                _buildRefreshButton(),
              ],
            )
          : Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildRolDropdown()),
                    const SizedBox(width: 10),
                    _buildRefreshButton(),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => ref.read(estudiantesProvider.notifier).buscar(v),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, email o código…',
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 16),
          suffixIcon: _searchCtrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted, size: 14),
                  onPressed: () {
                    _searchCtrl.clear();
                    ref.read(estudiantesProvider.notifier).buscar('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface600,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.neonBlue, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildRolDropdown() {
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<String>(
        value: _rolFilter.isEmpty ? null : _rolFilter,
        hint: const Text('Todos los roles',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        dropdownColor: AppColors.surface600,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textMuted, size: 18),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface600,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
        items: const [
          DropdownMenuItem(value: '', child: Text('Todos los roles')),
          DropdownMenuItem(value: 'ESTUDIANTE', child: Text('Estudiante')),
          DropdownMenuItem(value: 'DOCENTE', child: Text('Docente')),
          DropdownMenuItem(value: 'ADMINISTRADOR', child: Text('Administrador')),
        ],
        onChanged: (v) {
          setState(() => _rolFilter = v ?? '');
          ref.read(estudiantesProvider.notifier).filtrarPorRol(v);
        },
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Tooltip(
      message: 'Recargar',
      child: InkWell(
        onTap: () => ref.read(estudiantesProvider.notifier).cargar(),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface600,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.refresh_outlined, color: AppColors.textSecondary, size: 18),
        ),
      ),
    );
  }

  Widget _buildTable(List<UsuarioModel> usuarios) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      child: Column(
        children: [
          // Header de tabla
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bg900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  flex: 3,
                  child: Text(
                    'USUARIO',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'CÓDIGO / CARRERA',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'ROL',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'XP',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'ACCIONES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filas
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Column(
                children: usuarios.asMap().entries.map((entry) {
                  final i = entry.key;
                  final u = entry.value;
                  return _UserTableRow(
                    usuario: u,
                    isLast: i == usuarios.length - 1,
                    index: i,
                    onView: () => _openDetail(context, u),
                    onEdit: () => _openEdit(context, u),
                    onDelete: () => _confirmDelete(context, u),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildTableFooter(usuarios.length),
        ],
      ),
    );
  }

  Widget _buildTableFooter(int count) {
    return Row(
      children: [
        Text(
          'Mostrando $count resultado${count == 1 ? '' : 's'}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMobileList(List<UsuarioModel> usuarios) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: usuarios.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final u = usuarios[i];
        return MissionCard(
          onTap: () => _openDetail(context, u),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _UserAvatar(nombre: u.nombreCompleto, rol: u.rol, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u.nombreCompleto,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          u.email,
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  RoleBadge(rol: u.rol),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (u.codigoUniversitario != null)
                    Expanded(
                      child: _InfoChip(
                        icon: Icons.badge_outlined,
                        label: u.codigoUniversitario!,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _openEdit(context, u),
                    icon: const Icon(Icons.edit_outlined,
                        color: AppColors.neonBlue, size: 18),
                    tooltip: 'Editar',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => _confirmDelete(context, u),
                    icon: const Icon(Icons.delete_outline,
                        color: AppColors.danger, size: 18),
                    tooltip: 'Eliminar',
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ],
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn().slideY(begin: 0.08);
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(28),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surface600,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(color: AppColors.surface400, duration: 1000.ms),
    );
  }

  Widget _buildEmpty(bool isWide) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.neonBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline,
                color: AppColors.neonBlue, size: 40),
          ),
          const SizedBox(height: 20),
          const Text(
            'No hay usuarios',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea el primer usuario con el botón "Nuevo usuario"',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 24),
          MissionButton(
            label: 'Nuevo usuario',
            icon: Icons.add,
            onPressed: () => _openCreate(context),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
          const SizedBox(height: 16),
          Text(error,
              style: const TextStyle(color: AppColors.danger, fontSize: 13)),
          const SizedBox(height: 16),
          MissionButton(
            label: 'Reintentar',
            onPressed: () => ref.read(estudiantesProvider.notifier).cargar(),
            variant: MissionButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CreateUserScreen()))
        .then((_) => ref.read(estudiantesProvider.notifier).cargar());
  }

  void _openEdit(BuildContext context, UsuarioModel u) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => EditUserScreen(usuario: u)))
        .then((_) => ref.read(estudiantesProvider.notifier).cargar());
  }

  void _openDetail(BuildContext context, UsuarioModel u) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => UserDetailScreen(usuario: u)));
  }

  void _confirmDelete(BuildContext context, UsuarioModel u) {
    showDialog(
      context: context,
      builder: (_) => _DeleteUserDialog(
        usuario: u,
        onConfirm: () {
          MissionSnackbar.show(
            context,
            message: 'Usuario "${u.nombreCompleto}" eliminado.',
            isError: false,
          );
          ref.read(estudiantesProvider.notifier).cargar();
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Fila de tabla
// ─────────────────────────────────────────

class _UserTableRow extends StatefulWidget {
  final UsuarioModel usuario;
  final bool isLast;
  final int index;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserTableRow({
    required this.usuario,
    required this.isLast,
    required this.index,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_UserTableRow> createState() => _UserTableRowState();
}

class _UserTableRowState extends State<_UserTableRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onView,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.surface400 : AppColors.surface600,
            border: widget.isLast
                ? null
                : const Border(
                    bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              // Avatar
              SizedBox(
                width: 40,
                child: _UserAvatar(nombre: u.nombreCompleto, rol: u.rol),
              ),
              // Nombre + email
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.nombreCompleto,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      u.email,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Código / carrera
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (u.codigoUniversitario != null)
                      Text(
                        u.codigoUniversitario!,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    if (u.carrera != null)
                      Text(
                        u.carrera!,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (u.codigoUniversitario == null && u.carrera == null)
                      const Text('—',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              // Rol
              SizedBox(
                width: 100,
                child: RoleBadge(rol: u.rol),
              ),
              // XP
              SizedBox(
                width: 80,
                child: Text(
                  '${u.puntosTotales} XP',
                  style: const TextStyle(
                    color: AppColors.neonGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ),
              // Acciones
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionBtn(
                      icon: Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      tooltip: 'Ver detalle',
                      onTap: widget.onView,
                    ),
                    const SizedBox(width: 4),
                    _ActionBtn(
                      icon: Icons.edit_outlined,
                      color: AppColors.neonBlue,
                      tooltip: 'Editar',
                      onTap: widget.onEdit,
                    ),
                    const SizedBox(width: 4),
                    _ActionBtn(
                      icon: Icons.delete_outline,
                      color: AppColors.danger,
                      tooltip: 'Eliminar',
                      onTap: widget.onDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate(delay: Duration(milliseconds: 30 * widget.index))
          .fadeIn()
          .slideX(begin: 0.03),
    );
  }
}

class _ActionBtn extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _h
                  ? widget.color.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(widget.icon, color: widget.color, size: 16),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String nombre;
  final String rol;
  final double size;

  const _UserAvatar({required this.nombre, required this.rol, this.size = 32});

  Color get _color => switch (rol) {
        'ADMINISTRADOR' => AppColors.neonPurple,
        'DOCENTE' => AppColors.neonBlue,
        _ => AppColors.neonGreen,
      };

  @override
  Widget build(BuildContext context) {
    final initial =
        nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color.withOpacity(0.15),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: _color,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textMuted, size: 12),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Dialog de eliminación
// ─────────────────────────────────────────

class _DeleteUserDialog extends StatefulWidget {
  final UsuarioModel usuario;
  final VoidCallback onConfirm;

  const _DeleteUserDialog({required this.usuario, required this.onConfirm});

  @override
  State<_DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<_DeleteUserDialog> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface600,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline,
                    color: AppColors.danger, size: 30),
              ),
              const SizedBox(height: 20),
              const Text(
                '¿Eliminar usuario?',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Se eliminará "${widget.usuario.nombreCompleto}" permanentemente. Esta acción no se puede deshacer.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: MissionButton(
                      label: 'Cancelar',
                      onPressed: () => Navigator.pop(context),
                      variant: MissionButtonVariant.ghost,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MissionButton(
                      label: 'Sí, eliminar',
                      loading: _loading,
                      variant: MissionButtonVariant.danger,
                      onPressed: () async {
                        setState(() => _loading = true);
                        await Future.delayed(const Duration(milliseconds: 600));
                        if (context.mounted) {
                          Navigator.pop(context);
                          widget.onConfirm();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}