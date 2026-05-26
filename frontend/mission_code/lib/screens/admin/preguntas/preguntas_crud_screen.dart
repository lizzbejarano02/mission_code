import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/pregunta_provider.dart';
import '../../../models/pregunta_model.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/cards/mission_card.dart';
import '../../../widgets/common/mission_snackbar.dart';
import 'create_pregunta_screen.dart';
import 'edit_pregunta_screen.dart';
import 'pregunta_detail_screen.dart';

class PreguntasCrudScreen extends ConsumerStatefulWidget {
  const PreguntasCrudScreen({super.key});

  @override
  ConsumerState<PreguntasCrudScreen> createState() =>
      _PreguntasCrudScreenState();
}

class _PreguntasCrudScreenState
    extends ConsumerState<PreguntasCrudScreen> {
  final _searchCtrl = TextEditingController();
  String _dificultadFilter = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(preguntasProvider);
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: Column(
        children: [
          _buildHeader(context, isWide, state.items.length),
          _buildFiltersBar(isWide),
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

  Widget _buildHeader(
      BuildContext context, bool isWide, int total) {
    return Container(
      padding: EdgeInsets.fromLTRB(isWide ? 28 : 16, 24, isWide ? 28 : 16, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
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
              const Text(
                'Banco de Preguntas',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '$total preguntas registradas',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          MissionButton(
            label: 'Nueva pregunta',
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
          horizontal: isWide ? 28 : 16, vertical: 12),
      color: AppColors.bg900,
      child: isWide
          ? Row(
              children: [
                Expanded(flex: 3, child: _buildSearchField()),
                const SizedBox(width: 12),
                SizedBox(
                    width: 180, child: _buildDificultadDropdown()),
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
                    Expanded(child: _buildDificultadDropdown()),
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
        onChanged: (v) =>
            ref.read(preguntasProvider.notifier).buscar(v),
        style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Buscar por enunciado, tipo…',
          hintStyle: const TextStyle(
              color: AppColors.textMuted, fontSize: 13),
          prefixIcon: const Icon(Icons.search,
              color: AppColors.textMuted, size: 16),
          filled: true,
          fillColor: AppColors.surface600,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
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
                  color: AppColors.neonPurple, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildDificultadDropdown() {
    return SizedBox(
      height: 40,
      child: DropdownButtonFormField<String>(
        value: _dificultadFilter.isEmpty ? null : _dificultadFilter,
        hint: const Text('Todas',
            style: TextStyle(
                color: AppColors.textMuted, fontSize: 13)),
        dropdownColor: AppColors.surface600,
        style: const TextStyle(
            color: AppColors.textPrimary, fontSize: 13),
        icon: const Icon(Icons.keyboard_arrow_down,
            color: AppColors.textMuted, size: 18),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.surface600,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.border)),
        ),
        items: const [
          DropdownMenuItem(value: '', child: Text('Todas')),
          DropdownMenuItem(value: 'FACIL', child: Text('Fácil')),
          DropdownMenuItem(value: 'MEDIA', child: Text('Media')),
          DropdownMenuItem(
              value: 'DIFICIL', child: Text('Difícil')),
        ],
        onChanged: (v) {
          setState(() => _dificultadFilter = v ?? '');
          ref
              .read(preguntasProvider.notifier)
              .filtrarPorDificultad(v);
        },
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Tooltip(
      message: 'Recargar',
      child: InkWell(
        onTap: () => ref.read(preguntasProvider.notifier).cargar(),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface600,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.refresh_outlined,
              color: AppColors.textSecondary, size: 18),
        ),
      ),
    );
  }

  Widget _buildTable(List<PreguntaModel> preguntas) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
      child: Column(
        children: [
          // Cabecera de tabla
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
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
                Expanded(
                  flex: 4,
                  child: Text('ENUNCIADO',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                ),
                SizedBox(
                  width: 110,
                  child: Text('TIPO',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                ),
                SizedBox(
                  width: 90,
                  child: Text('DIFICULTAD',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                ),
                SizedBox(
                  width: 60,
                  child: Text('PTS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                ),
                SizedBox(
                  width: 100,
                  child: Text('ACCIONES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
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
                children: preguntas.asMap().entries.map((entry) {
                  final i = entry.key;
                  final p = entry.value;
                  return _PreguntaTableRow(
                    pregunta: p,
                    isLast: i == preguntas.length - 1,
                    index: i,
                    onView: () => _openDetail(context, p),
                    onEdit: () => _openEdit(context, p),
                    onDelete: () => _confirmDelete(context, p),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mostrando ${preguntas.length} resultado${preguntas.length == 1 ? '' : 's'}',
            style: const TextStyle(
                color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(List<PreguntaModel> preguntas) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: preguntas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = preguntas[i];
        return MissionCard(
          borderColor: _diffColor(p.dificultad).withOpacity(0.3),
          onTap: () => _openDetail(context, p),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    p.enunciado.length > 80
                        ? '${p.enunciado.substring(0, 80)}…'
                        : p.enunciado,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        height: 1.4),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                _DiffBadge(dificultad: p.dificultad),
                const SizedBox(width: 8),
                _TipoBadge(tipo: p.tipo),
                const Spacer(),
                Text('${p.puntos} pts',
                    style: const TextStyle(
                        color: AppColors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                _SmallActionBtn(
                    icon: Icons.edit_outlined,
                    color: AppColors.neonBlue,
                    onTap: () => _openEdit(context, p)),
                const SizedBox(width: 6),
                _SmallActionBtn(
                    icon: Icons.delete_outline,
                    color: AppColors.danger,
                    onTap: () => _confirmDelete(context, p)),
              ]),
            ],
          ),
        ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn();
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.separated(
      padding: const EdgeInsets.all(28),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface600,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
      )
          .animate(onPlay: (c) => c.repeat())
          .shimmer(
              color: AppColors.surface400, duration: 1000.ms),
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
              color: AppColors.neonPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.quiz_outlined,
                color: AppColors.neonPurple, size: 40),
          ),
          const SizedBox(height: 20),
          const Text('No hay preguntas',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text(
              'Crea la primera pregunta con el botón "Nueva pregunta"',
              style: TextStyle(
                  color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(height: 24),
          MissionButton(
            label: 'Nueva pregunta',
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
          const Icon(Icons.error_outline,
              color: AppColors.danger, size: 48),
          const SizedBox(height: 16),
          Text(error,
              style: const TextStyle(
                  color: AppColors.danger, fontSize: 13)),
          const SizedBox(height: 16),
          MissionButton(
            label: 'Reintentar',
            onPressed: () =>
                ref.read(preguntasProvider.notifier).cargar(),
            variant: MissionButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Color _diffColor(String d) => switch (d) {
        'FACIL' => AppColors.neonGreen,
        'MEDIA' => AppColors.amber,
        'DIFICIL' => AppColors.danger,
        _ => AppColors.textMuted,
      };

  void _openCreate(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => const CreatePreguntaScreen()))
        .then((_) => ref.read(preguntasProvider.notifier).cargar());
  }

  void _openEdit(BuildContext context, PreguntaModel p) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => EditPreguntaScreen(pregunta: p)))
        .then((_) => ref.read(preguntasProvider.notifier).cargar());
  }

  void _openDetail(BuildContext context, PreguntaModel p) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PreguntaDetailScreen(pregunta: p)));
  }

  void _confirmDelete(BuildContext context, PreguntaModel p) {
    showDialog(
      context: context,
      builder: (_) => _DeletePreguntaDialog(
        pregunta: p,
        onConfirm: () async {
          try {
            await ref
                .read(preguntaServiceProvider)
                .deletePregunta(p.id);
            ref.read(preguntasProvider.notifier).cargar();
            if (context.mounted) {
              MissionSnackbar.show(context,
                  message: 'Pregunta eliminada correctamente.');
            }
          } catch (e) {
            if (context.mounted) {
              MissionSnackbar.show(context,
                  message: e.toString(), isError: true);
            }
          }
        },
      ),
    );
  }
}

// ─────────────────────────────────────────
// Fila de tabla de preguntas
// ─────────────────────────────────────────

class _PreguntaTableRow extends StatefulWidget {
  final PreguntaModel pregunta;
  final bool isLast;
  final int index;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PreguntaTableRow({
    required this.pregunta,
    required this.isLast,
    required this.index,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_PreguntaTableRow> createState() => _PreguntaTableRowState();
}

class _PreguntaTableRowState extends State<_PreguntaTableRow> {
  bool _hovered = false;

  Color _diffColor(String d) => switch (d) {
        'FACIL' => AppColors.neonGreen,
        'MEDIA' => AppColors.amber,
        'DIFICIL' => AppColors.danger,
        _ => AppColors.textMuted,
      };

  @override
  Widget build(BuildContext context) {
    final p = widget.pregunta;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onView,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surface400
                : AppColors.surface600,
            border: widget.isLast
                ? null
                : const Border(
                    bottom:
                        BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              // Enunciado
              Expanded(
                flex: 4,
                child: Text(
                  p.enunciado.length > 90
                      ? '${p.enunciado.substring(0, 90)}…'
                      : p.enunciado,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13),
                ),
              ),
              // Tipo
              SizedBox(
                width: 110,
                child: _TipoBadge(tipo: p.tipo),
              ),
              // Dificultad
              SizedBox(
                width: 90,
                child: _DiffBadge(dificultad: p.dificultad),
              ),
              // Puntos
              SizedBox(
                width: 60,
                child: Text(
                  '${p.puntos}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.amber,
                    fontSize: 13,
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
                    _ActionBtn2(
                        icon: Icons.visibility_outlined,
                        color: AppColors.textMuted,
                        tooltip: 'Ver',
                        onTap: widget.onView),
                    const SizedBox(width: 4),
                    _ActionBtn2(
                        icon: Icons.edit_outlined,
                        color: AppColors.neonBlue,
                        tooltip: 'Editar',
                        onTap: widget.onEdit),
                    const SizedBox(width: 4),
                    _ActionBtn2(
                        icon: Icons.delete_outline,
                        color: AppColors.danger,
                        tooltip: 'Eliminar',
                        onTap: widget.onDelete),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate(
              delay: Duration(milliseconds: 30 * widget.index))
          .fadeIn()
          .slideX(begin: 0.03),
    );
  }
}

class _ActionBtn2 extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  const _ActionBtn2(
      {required this.icon,
      required this.color,
      required this.tooltip,
      required this.onTap});
  @override
  State<_ActionBtn2> createState() => _ActionBtn2State();
}

class _ActionBtn2State extends State<_ActionBtn2> {
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
            child: Icon(widget.icon,
                color: widget.color, size: 16),
          ),
        ),
      ),
    );
  }
}

class _SmallActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallActionBtn(
      {required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      );
}

class _DiffBadge extends StatelessWidget {
  final String dificultad;
  const _DiffBadge({required this.dificultad});

  Color get _c => switch (dificultad) {
        'FACIL' => AppColors.neonGreen,
        'MEDIA' => AppColors.amber,
        'DIFICIL' => AppColors.danger,
        _ => AppColors.textMuted,
      };

  String get _label => switch (dificultad) {
        'FACIL' => 'Fácil',
        'MEDIA' => 'Media',
        'DIFICIL' => 'Difícil',
        _ => dificultad,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: _c.withOpacity(0.3)),
      ),
      child: Text(_label,
          style: TextStyle(
              color: _c,
              fontSize: 10,
              fontWeight: FontWeight.w600)),
    );
  }
}

class _TipoBadge extends StatelessWidget {
  final String tipo;
  const _TipoBadge({required this.tipo});

  String get _label => switch (tipo) {
        'OPCION_MULTIPLE' => 'Opción múltiple',
        'VERDADERO_FALSO' => 'V/F',
        'TEXTO_LIBRE' => 'Texto libre',
        _ => tipo,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.neonBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: AppColors.neonBlue.withOpacity(0.3)),
      ),
      child: Text(_label,
          style: const TextStyle(
              color: AppColors.neonBlue,
              fontSize: 10,
              fontWeight: FontWeight.w500)),
    );
  }
}

class _DeletePreguntaDialog extends StatefulWidget {
  final PreguntaModel pregunta;
  final Future<void> Function() onConfirm;
  const _DeletePreguntaDialog(
      {required this.pregunta, required this.onConfirm});
  @override
  State<_DeletePreguntaDialog> createState() =>
      _DeletePreguntaDialogState();
}

class _DeletePreguntaDialogState
    extends State<_DeletePreguntaDialog> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface600,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)),
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline,
                    color: AppColors.danger, size: 28),
              ),
              const SizedBox(height: 18),
              const Text('¿Eliminar pregunta?',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Se eliminará esta pregunta y todas sus respuestas asociadas permanentemente.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5),
              ),
              const SizedBox(height: 22),
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
                  label: 'Sí, eliminar',
                  loading: _loading,
                  variant: MissionButtonVariant.danger,
                  onPressed: () async {
                    setState(() => _loading = true);
                    await widget.onConfirm();
                    if (context.mounted) Navigator.pop(context);
                  },
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}