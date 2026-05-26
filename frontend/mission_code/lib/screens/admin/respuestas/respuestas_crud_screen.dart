import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../services/respuesta_service.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/common/mission_snackbar.dart';

final respuestaServiceProvider =
    Provider<RespuestaService>((_) => RespuestaService());

class RespuestasCrudScreen extends ConsumerStatefulWidget {
  const RespuestasCrudScreen({super.key});

  @override
  ConsumerState<RespuestasCrudScreen> createState() =>
      _RespuestasCrudScreenState();
}

class _RespuestasCrudScreenState
    extends ConsumerState<RespuestasCrudScreen> {
  List<Map<String, dynamic>> _respuestas = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _loading = true;
  String? _error;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await ref
          .read(respuestaServiceProvider)
          .getRespuestas();
      if (mounted) {
        setState(() {
          _respuestas = data;
          _filtered = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  void _buscar(String q) {
    final query = q.toLowerCase();
    setState(() {
      _filtered = query.isEmpty
          ? _respuestas
          : _respuestas
              .where((r) => (r['texto'] as String? ?? '')
                  .toLowerCase()
                  .contains(query))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: Column(
        children: [
          _buildHeader(context, isWide),
          _buildFilters(isWide),
          Expanded(
            child: _loading
                ? _buildSkeleton()
                : _error != null
                    ? _buildError()
                    : _filtered.isEmpty
                        ? _buildEmpty()
                        : isWide
                            ? _buildTable()
                            : _buildMobileList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isWide) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          isWide ? 28 : 16, 24, isWide ? 28 : 16, 16),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColors.border))),
      child: Row(children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back,
              color: AppColors.textSecondary, size: 20),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gestión de Respuestas',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            Text('${_respuestas.length} respuestas',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
        const Spacer(),
        MissionButton(
          label: 'Nueva respuesta',
          icon: Icons.add,
          onPressed: () => _showDialog(context, null),
        ),
      ]),
    );
  }

  Widget _buildFilters(bool isWide) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 28 : 16, vertical: 12),
      color: AppColors.bg900,
      child: Row(children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchCtrl,
              onChanged: _buscar,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar respuesta…',
                hintStyle: const TextStyle(
                    color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textMuted, size: 16),
                filled: true,
                fillColor: AppColors.surface600,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: AppColors.neonBlue, width: 1.5)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: _cargar,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: AppColors.surface600,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.refresh_outlined,
                color: AppColors.textSecondary, size: 18),
          ),
        ),
      ]),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.bg900,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(children: [
            Expanded(
                flex: 4,
                child: Text('TEXTO',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
            SizedBox(
                width: 120,
                child: Text('PREGUNTA',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
            SizedBox(
                width: 100,
                child: Text('¿CORRECTA?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
            SizedBox(
                width: 100,
                child: Text('ACCIONES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8))),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12)),
            child: Column(
              children: _filtered
                  .asMap()
                  .entries
                  .map((e) => _RespuestaRow(
                        respuesta: e.value,
                        isLast: e.key == _filtered.length - 1,
                        index: e.key,
                        onEdit: () =>
                            _showDialog(context, e.value),
                        onDelete: () =>
                            _confirmDelete(context, e.value),
                      ))
                  .toList(),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final r = _filtered[i];
        final correcto = r['es_correcta'] as bool? ?? false;
        return MissionCard(
          borderColor: correcto
              ? AppColors.neonGreen.withOpacity(0.3)
              : AppColors.border,
          child: Row(children: [
            Icon(
              correcto
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color: correcto
                  ? AppColors.neonGreen
                  : AppColors.danger,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Text(r['texto'] as String? ?? '',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13))),
            _TileBtn2(
                icon: Icons.edit_outlined,
                color: AppColors.neonBlue,
                onTap: () => _showDialog(context, r)),
            const SizedBox(width: 6),
            _TileBtn2(
                icon: Icons.delete_outline,
                color: AppColors.danger,
                onTap: () => _confirmDelete(context, r)),
          ]),
        ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn();
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(28),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 48,
        decoration: BoxDecoration(
            color: AppColors.surface600,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border)),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(color: AppColors.surface400, duration: 1000.ms),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                color: AppColors.neonBlue.withOpacity(0.1),
                shape: BoxShape.circle),
            child: const Icon(Icons.check_box_outlined,
                color: AppColors.neonBlue, size: 40)),
        const SizedBox(height: 20),
        const Text('No hay respuestas',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        MissionButton(
            label: 'Nueva respuesta',
            icon: Icons.add,
            onPressed: () => _showDialog(context, null)),
      ]),
    ).animate().fadeIn();
  }

  Widget _buildError() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.error_outline,
            color: AppColors.danger, size: 48),
        const SizedBox(height: 12),
        Text(_error ?? '',
            style: const TextStyle(
                color: AppColors.danger, fontSize: 13)),
        const SizedBox(height: 16),
        MissionButton(
            label: 'Reintentar',
            variant: MissionButtonVariant.outline,
            onPressed: _cargar),
      ]),
    );
  }

  void _showDialog(BuildContext ctx, Map<String, dynamic>? r) {
    showDialog(
      context: ctx,
      builder: (_) => _RespuestaDialog(
        respuesta: r,
        onSave: (data) async {
          final svc = ref.read(respuestaServiceProvider);
          if (r == null) {
            await svc.createRespuesta(data);
          } else {
            await svc.updateRespuesta(r['id'] as int, data);
          }
          _cargar();
          if (ctx.mounted) {
            MissionSnackbar.show(ctx,
                message: r == null
                    ? 'Respuesta creada.'
                    : 'Respuesta actualizada.');
          }
        },
      ),
    );
  }

  void _confirmDelete(
      BuildContext ctx, Map<String, dynamic> r) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface600,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Eliminar respuesta?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text('"${r['texto']}"',
            style: const TextStyle(
                color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar',
                  style:
                      TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await ref
                    .read(respuestaServiceProvider)
                    .deleteRespuesta(r['id'] as int);
                _cargar();
                if (ctx.mounted) {
                  MissionSnackbar.show(ctx,
                      message: 'Respuesta eliminada.');
                }
              } catch (e) {
                if (ctx.mounted) {
                  MissionSnackbar.show(ctx,
                      message: e.toString(), isError: true);
                }
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ─── Fila de tabla ────────────────────────────────────

class _RespuestaRow extends StatefulWidget {
  final Map<String, dynamic> respuesta;
  final bool isLast;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RespuestaRow({
    required this.respuesta,
    required this.isLast,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_RespuestaRow> createState() => _RespuestaRowState();
}

class _RespuestaRowState extends State<_RespuestaRow> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.respuesta;
    final correcto = r['es_correcta'] as bool? ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _h ? AppColors.surface400 : AppColors.surface600,
          border: widget.isLast
              ? null
              : const Border(
                  bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(children: [
          Expanded(
              flex: 4,
              child: Text(r['texto'] as String? ?? '',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13))),
          SizedBox(
            width: 120,
            child: Text('ID: ${r['pregunta'] ?? '—'}',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: correcto
                      ? AppColors.neonGreen.withOpacity(0.12)
                      : AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                    correcto ? 'Correcta' : 'Incorrecta',
                    style: TextStyle(
                      color: correcto
                          ? AppColors.neonGreen
                          : AppColors.danger,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TileBtn2(
                    icon: Icons.edit_outlined,
                    color: AppColors.neonBlue,
                    onTap: widget.onEdit),
                const SizedBox(width: 6),
                _TileBtn2(
                    icon: Icons.delete_outline,
                    color: AppColors.danger,
                    onTap: widget.onDelete),
              ],
            ),
          ),
        ]),
      ).animate(
              delay: Duration(milliseconds: 25 * widget.index))
          .fadeIn(),
    );
  }
}

class _TileBtn2 extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _TileBtn2(
      {required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6)),
          child: Icon(icon, color: color, size: 15),
        ),
      );
}

// ─── Dialog crear / editar respuesta ──────────────────

class _RespuestaDialog extends StatefulWidget {
  final Map<String, dynamic>? respuesta;
  final Future<void> Function(Map<String, dynamic>) onSave;

  const _RespuestaDialog(
      {this.respuesta, required this.onSave});

  @override
  State<_RespuestaDialog> createState() =>
      _RespuestaDialogState();
}

class _RespuestaDialogState extends State<_RespuestaDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textoCtrl;
  late final TextEditingController _preguntaIdCtrl;
  late final TextEditingController _ordenCtrl;
  bool _esCorrecta = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final r = widget.respuesta;
    _textoCtrl =
        TextEditingController(text: r?['texto'] as String? ?? '');
    _preguntaIdCtrl = TextEditingController(
        text: '${r?['pregunta'] ?? ''}');
    _ordenCtrl =
        TextEditingController(text: '${r?['orden'] ?? 1}');
    _esCorrecta = r?['es_correcta'] as bool? ?? false;
  }

  @override
  void dispose() {
    _textoCtrl.dispose();
    _preguntaIdCtrl.dispose();
    _ordenCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await widget.onSave({
        'texto': _textoCtrl.text.trim(),
        'pregunta': int.tryParse(_preguntaIdCtrl.text) ?? 0,
        'es_correcta': _esCorrecta,
        'orden': int.tryParse(_ordenCtrl.text) ?? 1,
      });
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 460,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    widget.respuesta == null
                        ? 'Nueva respuesta'
                        : 'Editar respuesta',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 20),
                MissionInput(
                  label: 'TEXTO DE LA RESPUESTA',
                  hint: 'Ej: Requisitos',
                  controller: _textoCtrl,
                  maxLines: 2,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'Requerido'
                          : null,
                ),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(
                      child: MissionInput(
                          label: 'ID PREGUNTA',
                          hint: '1',
                          controller: _preguntaIdCtrl,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Requerido'
                                  : null)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: MissionInput(
                          label: 'ORDEN',
                          controller: _ordenCtrl,
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Requerido'
                                  : null)),
                ]),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => setState(
                      () => _esCorrecta = !_esCorrecta),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _esCorrecta
                          ? AppColors.neonGreen.withOpacity(0.1)
                          : AppColors.bg900,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _esCorrecta
                            ? AppColors.neonGreen
                            : AppColors.border,
                        width: _esCorrecta ? 1.5 : 1,
                      ),
                    ),
                    child: Row(children: [
                      Icon(
                        _esCorrecta
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _esCorrecta
                            ? AppColors.neonGreen
                            : AppColors.textMuted,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _esCorrecta
                            ? '✓ Respuesta correcta'
                            : 'Marcar como correcta',
                        style: TextStyle(
                          color: _esCorrecta
                              ? AppColors.neonGreen
                              : AppColors.textMuted,
                          fontSize: 13,
                          fontWeight: _esCorrecta
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 24),
                Row(children: [
                  Expanded(
                      child: MissionButton(
                          label: 'Cancelar',
                          onPressed: () =>
                              Navigator.pop(context),
                          variant: MissionButtonVariant.ghost)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: MissionButton(
                          label: widget.respuesta == null
                              ? 'Crear'
                              : 'Guardar',
                          loading: _loading,
                          onPressed: _save)),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}