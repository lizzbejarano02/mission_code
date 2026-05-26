import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/colors/app_colors.dart';
import '../../../providers/mision_provider.dart';
import '../../../models/nivel_model.dart';
import '../../../services/game_service.dart';

import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/common/mission_snackbar.dart';

class MisionesCrudScreen extends ConsumerStatefulWidget {
  const MisionesCrudScreen({super.key});

  @override
  ConsumerState<MisionesCrudScreen> createState() =>
      _MisionesCrudScreenState();
}

class _MisionesCrudScreenState extends ConsumerState<MisionesCrudScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(misionesProvider);
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: Column(
        children: [
          _buildHeader(context, isWide, state.items.length),
          _buildFilters(isWide),
          Expanded(
            child: state.loading
                ? _buildSkeleton()
                : state.error != null
                    ? _buildError(state.error!)
                    : state.filtered.isEmpty
                        ? _buildEmpty()
                        : isWide
                            ? _buildTable(state.filtered)
                            : _buildMobileList(state.filtered),
          ),
        ],
      ),
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _buildHeader(BuildContext ctx, bool isWide, int total) {
    return Container(
      padding: EdgeInsets.fromLTRB(isWide ? 28 : 16, 24, isWide ? 28 : 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => ctx.pop(),
            icon: const Icon(Icons.arrow_back,
                color: AppColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Gestión de Misiones',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              Text('$total misiones',
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
          const Spacer(),
          MissionButton(
            label: 'Nueva misión',
            icon: Icons.add,
            onPressed: () => _showDialog(context, null),
          ),
        ],
      ),
    );
  }

  // ───────────────── FILTERS ─────────────────
  Widget _buildFilters(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 16, vertical: 12),
      color: AppColors.bg900,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) =>
                  ref.read(misionesProvider.notifier).buscar(v),
              decoration: const InputDecoration(
                hintText: 'Buscar misión...',
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () =>
                ref.read(misionesProvider.notifier).cargar(),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }

  // ───────────────── DIALOG ─────────────────
  void _showDialog(BuildContext ctx, Map<String, dynamic>? m) {
    showDialog(
      context: ctx,
      builder: (_) => _MisionDialog(
        mision: m,
        onSave: (data) async {
          final service = ref.read(misionServiceProvider);

          if (m == null) {
            await service.createMision(data);
          } else {
            await service.updateMision(m['id'], data);
          }

          ref.read(misionesProvider.notifier).cargar();

          if (ctx.mounted) {
            MissionSnackbar.show(
              ctx,
              message: m == null
                  ? 'Misión creada correctamente'
                  : 'Misión actualizada correctamente',
            );
          }
        },
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, Map<String, dynamic> m) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar misión?'),
        content: Text(m['nombre'] ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);

              await ref
                  .read(misionServiceProvider)
                  .deleteMision(m['id']);

              ref.read(misionesProvider.notifier).cargar();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildEmpty() =>
      const Center(child: Text('No hay misiones'));

  Widget _buildError(String e) =>
      Center(child: Text(e));

  Widget _buildTable(List items) => const SizedBox();

  Widget _buildMobileList(List items) => const SizedBox();
}

// ───────────────── DIALOG ─────────────────

class _MisionDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? mision;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const _MisionDialog({
    this.mision,
    required this.onSave,
  });

  @override
  ConsumerState<_MisionDialog> createState() => _MisionDialogState();
}

class _MisionDialogState extends ConsumerState<_MisionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombre;
  late TextEditingController _desc;
  late TextEditingController _xp;

  int? _nivelId;
  List<NivelModel> _niveles = [];

  @override
  void initState() {
    super.initState();

    final m = widget.mision;

    _nombre = TextEditingController(text: m?['nombre'] ?? '');
    _desc = TextEditingController(text: m?['descripcion'] ?? '');
    _xp = TextEditingController(text: '${m?['puntos_recompensa'] ?? 10}');
    _nivelId = m?['nivel'];

    _loadNiveles();
  }

  Future<void> _loadNiveles() async {
    try {
      final service = GameService(); // 🔥 FIX REAL
      final data = await service.getNiveles();

      if (mounted) {
        setState(() => _niveles = data);
      }
    } catch (e) {
      debugPrint("Error niveles: $e");
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_nivelId == null) return;

    await widget.onSave({
      'nivel': _nivelId,
      'nombre': _nombre.text,
      'descripcion': _desc.text,
      'puntos_recompensa': int.tryParse(_xp.text) ?? 10,
    });

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.mision == null ? 'Nueva misión' : 'Editar misión'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _nivelId,
                items: _niveles
                    .map((e) => DropdownMenuItem(
                          value: e.id,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _nivelId = v),
              ),
              TextFormField(controller: _nombre),
              TextFormField(controller: _desc),
              TextFormField(controller: _xp),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _save,
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}