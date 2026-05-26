import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/pregunta_provider.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/common/mission_snackbar.dart';

class CreatePreguntaScreen extends ConsumerStatefulWidget {
  const CreatePreguntaScreen({super.key});

  @override
  ConsumerState<CreatePreguntaScreen> createState() =>
      _CreatePreguntaScreenState();
}

class _CreatePreguntaScreenState
    extends ConsumerState<CreatePreguntaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _enunciadoCtrl = TextEditingController();
  final _explicacionCtrl = TextEditingController();
  final _puntosCtrl = TextEditingController(text: '10');
  final _ordenCtrl = TextEditingController(text: '1');

  String _tipo = 'OPCION_MULTIPLE';
  String _dificultad = 'FACIL';
  bool _activa = true;
  bool _loading = false;

  int? _misionSeleccionada;
  List<_RespuestaEntry> _respuestas = [];
  List<Map<String, dynamic>> _misiones = [];
  bool _loadingMisiones = false;

  @override
  void initState() {
    super.initState();
    _cargarMisiones();
    _initRespuestas();
  }

  void _initRespuestas() {
    _respuestas = [
      _RespuestaEntry(TextEditingController(), true),
      _RespuestaEntry(TextEditingController(), false),
      _RespuestaEntry(TextEditingController(), false),
      _RespuestaEntry(TextEditingController(), false),
    ];
  }

  Future<void> _cargarMisiones() async {
    setState(() => _loadingMisiones = true);
    try {
      final data =
          await ref.read(preguntaServiceProvider).getMisiones();
      setState(() {
        _misiones = data
            .map((m) => {
                  'id': m['id'],
                  'nombre': m['nombre'] ?? '',
                })
            .toList();
        _loadingMisiones = false;
      });
    } catch (_) {
      setState(() => _loadingMisiones = false);
    }
  }

  @override
  void dispose() {
    _enunciadoCtrl.dispose();
    _explicacionCtrl.dispose();
    _puntosCtrl.dispose();
    _ordenCtrl.dispose();
    for (final r in _respuestas) {
      r.controller.dispose();
    }
    super.dispose();
  }

  Future<void> _crear() async {
    if (!_formKey.currentState!.validate()) return;
    if (_misionSeleccionada == null) {
      MissionSnackbar.show(context,
          message: 'Selecciona una misión.', isWarning: true);
      return;
    }

    final respuestasValidas = _respuestas
        .where((r) => r.controller.text.trim().isNotEmpty)
        .toList();

    if (_tipo != 'TEXTO_LIBRE' && respuestasValidas.isEmpty) {
      MissionSnackbar.show(context,
          message: 'Agrega al menos una respuesta.',
          isWarning: true);
      return;
    }

    final tieneCorrecta =
        respuestasValidas.any((r) => r.esCorrecta);
    if (_tipo != 'TEXTO_LIBRE' && !tieneCorrecta) {
      MissionSnackbar.show(context,
          message: 'Marca al menos una respuesta como correcta.',
          isWarning: true);
      return;
    }

    setState(() => _loading = true);
    try {
      final pregunta =
          await ref.read(preguntaServiceProvider).createPregunta({
        'mision': _misionSeleccionada,
        'enunciado': _enunciadoCtrl.text.trim(),
        'tipo': _tipo,
        'dificultad': _dificultad,
        'puntos': int.tryParse(_puntosCtrl.text) ?? 10,
        'orden': int.tryParse(_ordenCtrl.text) ?? 1,
        'activa': _activa,
        'explicacion': _explicacionCtrl.text.trim(),
      });

      // Crear respuestas
      for (var i = 0; i < respuestasValidas.length; i++) {
        final r = respuestasValidas[i];
        await ref.read(preguntaServiceProvider).createRespuesta({
          'pregunta': pregunta.id,
          'texto': r.controller.text.trim(),
          'es_correcta': r.esCorrecta,
          'orden': i + 1,
        });
      }

      if (mounted) {
        MissionSnackbar.show(context,
            message: 'Pregunta creada correctamente con ${respuestasValidas.length} respuestas.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        MissionSnackbar.show(context,
            message: e.toString(), isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: SizedBox(
              width: 620,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface600,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.arrow_back,
                color: AppColors.textSecondary, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nueva pregunta',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            Text('Completa los campos para crear la pregunta',
                style: TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
          ],
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selección misión
            _buildMisionDropdown(),
            const SizedBox(height: 16),

            // Enunciado
            MissionInput(
              label: 'ENUNCIADO DE LA PREGUNTA',
              hint:
                  '¿Cuál es la primera fase del ciclo de vida del software?',
              controller: _enunciadoCtrl,
              maxLines: 3,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Campo requerido'
                  : null,
            ),
            const SizedBox(height: 16),

            // Tipo y dificultad en fila
            Row(children: [
              Expanded(child: _buildTipoSelector()),
              const SizedBox(width: 16),
              Expanded(child: _buildDificultadSelector()),
            ]),
            const SizedBox(height: 16),

            // Puntos y Orden
            Row(children: [
              Expanded(
                child: MissionInput(
                  label: 'PUNTOS',
                  controller: _puntosCtrl,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.star_outline,
                      color: AppColors.amber, size: 16),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MissionInput(
                  label: 'ORDEN',
                  controller: _ordenCtrl,
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Requerido' : null,
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // Explicación
            MissionInput(
              label: 'EXPLICACIÓN (para respuesta incorrecta)',
              hint: 'La fase de Requisitos es donde…',
              controller: _explicacionCtrl,
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Estado activa
            Row(children: [
              Switch(
                value: _activa,
                onChanged: (v) => setState(() => _activa = v),
                activeColor: AppColors.neonGreen,
              ),
              const SizedBox(width: 8),
              Text(_activa ? 'Pregunta activa' : 'Pregunta inactiva',
                  style: TextStyle(
                      color: _activa
                          ? AppColors.neonGreen
                          : AppColors.textMuted,
                      fontSize: 13)),
            ]),

            // Respuestas (solo si no es texto libre)
            if (_tipo != 'TEXTO_LIBRE') ...[
              const SizedBox(height: 20),
              const Divider(color: AppColors.border),
              const SizedBox(height: 16),
              _buildRespuestasSection(),
            ],

            const SizedBox(height: 28),
            Row(children: [
              Expanded(
                  child: MissionButton(
                      label: 'Cancelar',
                      onPressed: () => Navigator.pop(context),
                      variant: MissionButtonVariant.ghost)),
              const SizedBox(width: 12),
              Expanded(
                  child: MissionButton(
                      label: 'Crear pregunta',
                      icon: Icons.add_circle_outline,
                      loading: _loading,
                      onPressed: _crear)),
            ]),
          ],
        ),
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.06);
  }

  Widget _buildMisionDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MISIÓN',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: _loadingMisiones
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(children: [
                    SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.neonGreen)),
                    SizedBox(width: 10),
                    Text('Cargando misiones…',
                        style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13)),
                  ]))
              : DropdownButtonFormField<int>(
                  value: _misionSeleccionada,
                  hint: const Text('Selecciona una misión',
                      style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13)),
                  dropdownColor: AppColors.surface600,
                  style: const TextStyle(
                      color: AppColors.textPrimary, fontSize: 13),
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.textMuted, size: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                  ),
                  items: _misiones
                      .map((m) => DropdownMenuItem<int>(
                            value: m['id'] as int,
                            child: Text(m['nombre'] as String),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _misionSeleccionada = v),
                ),
        ),
      ],
    );
  }

  Widget _buildTipoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TIPO',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<String>(
            value: _tipo,
            dropdownColor: AppColors.surface600,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 13),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textMuted, size: 18),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            ),
            items: const [
              DropdownMenuItem(
                  value: 'OPCION_MULTIPLE',
                  child: Text('Opción múltiple')),
              DropdownMenuItem(
                  value: 'VERDADERO_FALSO',
                  child: Text('Verdadero/Falso')),
              DropdownMenuItem(
                  value: 'TEXTO_LIBRE',
                  child: Text('Texto libre')),
            ],
            onChanged: (v) {
              setState(() {
                _tipo = v ?? 'OPCION_MULTIPLE';
                if (_tipo == 'VERDADERO_FALSO') {
                  for (final r in _respuestas) r.controller.dispose();
                  _respuestas = [
                    _RespuestaEntry(
                        TextEditingController(text: 'Verdadero'), true),
                    _RespuestaEntry(
                        TextEditingController(text: 'Falso'), false),
                  ];
                } else if (_tipo == 'OPCION_MULTIPLE') {
                  _initRespuestas();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDificultadSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DIFICULTAD',
            style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonFormField<String>(
            value: _dificultad,
            dropdownColor: AppColors.surface600,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 13),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: AppColors.textMuted, size: 18),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            ),
            items: const [
              DropdownMenuItem(value: 'FACIL', child: Text('Fácil')),
              DropdownMenuItem(value: 'MEDIA', child: Text('Media')),
              DropdownMenuItem(
                  value: 'DIFICIL', child: Text('Difícil')),
            ],
            onChanged: (v) =>
                setState(() => _dificultad = v ?? 'FACIL'),
          ),
        ),
      ],
    );
  }

  Widget _buildRespuestasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('OPCIONES DE RESPUESTA',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5)),
            if (_tipo == 'OPCION_MULTIPLE')
              GestureDetector(
                onTap: () => setState(() => _respuestas.add(
                    _RespuestaEntry(TextEditingController(), false))),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: AppColors.neonGreen.withOpacity(0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add,
                          color: AppColors.neonGreen, size: 14),
                      SizedBox(width: 4),
                      Text('Agregar',
                          style: TextStyle(
                              color: AppColors.neonGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ..._respuestas.asMap().entries.map((entry) {
          final i = entry.key;
          final r = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RespuestaInputRow(
              entry: r,
              index: i,
              canDelete: _tipo == 'OPCION_MULTIPLE' &&
                  _respuestas.length > 2,
              onToggleCorrecta: () => setState(() {
                // Para VF y OM, marcar solo una como correcta
                for (final x in _respuestas) {
                  x.esCorrecta = false;
                }
                r.esCorrecta = true;
              }),
              onDelete: () => setState(() {
                r.controller.dispose();
                _respuestas.removeAt(i);
              }),
            ),
          );
        }),
        const SizedBox(height: 8),
        const Text(
          '⚡ Marca la respuesta correcta haciendo clic en el círculo verde.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}

class _RespuestaEntry {
  TextEditingController controller;
  bool esCorrecta;
  _RespuestaEntry(this.controller, this.esCorrecta);
}

class _RespuestaInputRow extends StatefulWidget {
  final _RespuestaEntry entry;
  final int index;
  final bool canDelete;
  final VoidCallback onToggleCorrecta;
  final VoidCallback onDelete;

  const _RespuestaInputRow({
    required this.entry,
    required this.index,
    required this.canDelete,
    required this.onToggleCorrecta,
    required this.onDelete,
  });

  @override
  State<_RespuestaInputRow> createState() => _RespuestaInputRowState();
}

class _RespuestaInputRowState extends State<_RespuestaInputRow> {
  @override
  Widget build(BuildContext context) {
    final letters = ['A', 'B', 'C', 'D', 'E', 'F'];
    final letter = widget.index < letters.length
        ? letters[widget.index]
        : '${widget.index + 1}';

    return Row(
      children: [
        // Indicador de letra
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.entry.esCorrecta
                ? AppColors.neonGreen.withOpacity(0.2)
                : AppColors.bg900,
            border: Border.all(
              color: widget.entry.esCorrecta
                  ? AppColors.neonGreen
                  : AppColors.border,
              width: widget.entry.esCorrecta ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: widget.entry.esCorrecta
                    ? AppColors.neonGreen
                    : AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Campo de texto
        Expanded(
          child: TextField(
            controller: widget.entry.controller,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Opción ${letter}…',
              hintStyle: const TextStyle(
                  color: AppColors.textMuted, fontSize: 13),
              filled: true,
              fillColor: widget.entry.esCorrecta
                  ? AppColors.neonGreen.withOpacity(0.06)
                  : AppColors.bg900,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: widget.entry.esCorrecta
                        ? AppColors.neonGreen.withOpacity(0.4)
                        : AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      color: AppColors.neonBlue, width: 1.5)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Botón marcar correcta
        Tooltip(
          message: widget.entry.esCorrecta
              ? 'Respuesta correcta'
              : 'Marcar como correcta',
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.entry.esCorrecta = !widget.entry.esCorrecta;
              });
              widget.onToggleCorrecta();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.entry.esCorrecta
                    ? AppColors.neonGreen.withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: widget.entry.esCorrecta
                      ? AppColors.neonGreen
                      : AppColors.border,
                ),
              ),
              child: Icon(
                widget.entry.esCorrecta
                    ? Icons.check
                    : Icons.radio_button_unchecked,
                color: widget.entry.esCorrecta
                    ? AppColors.neonGreen
                    : AppColors.textMuted,
                size: 16,
              ),
            ),
          ),
        ),
        // Botón eliminar
        if (widget.canDelete) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: widget.onDelete,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.close,
                  color: AppColors.danger, size: 14),
            ),
          ),
        ],
      ],
    );
  }
}