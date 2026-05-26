import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../models/pregunta_model.dart';
import '../../../providers/pregunta_provider.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/common/mission_snackbar.dart';

class EditPreguntaScreen extends ConsumerStatefulWidget {
  final PreguntaModel pregunta;
  const EditPreguntaScreen({super.key, required this.pregunta});

  @override
  ConsumerState<EditPreguntaScreen> createState() =>
      _EditPreguntaScreenState();
}

class _EditPreguntaScreenState extends ConsumerState<EditPreguntaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _enunciadoCtrl;
  late final TextEditingController _explicacionCtrl;
  late final TextEditingController _puntosCtrl;
  late final TextEditingController _ordenCtrl;
  late String _dificultad;
  late bool _activa;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pregunta;
    _enunciadoCtrl = TextEditingController(text: p.enunciado);
    _explicacionCtrl =
        TextEditingController(text: p.imagen ?? '');
    _puntosCtrl = TextEditingController(text: '${p.puntos}');
    _ordenCtrl = TextEditingController(text: '${p.orden}');
    _dificultad = p.dificultad;
    _activa = p.opcionesRespuesta.isNotEmpty;
  }

  @override
  void dispose() {
    _enunciadoCtrl.dispose();
    _explicacionCtrl.dispose();
    _puntosCtrl.dispose();
    _ordenCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(preguntaServiceProvider).updatePregunta(
          widget.pregunta.id, {
        'enunciado': _enunciadoCtrl.text.trim(),
        'dificultad': _dificultad,
        'puntos': int.tryParse(_puntosCtrl.text) ?? widget.pregunta.puntos,
        'orden': int.tryParse(_ordenCtrl.text) ?? widget.pregunta.orden,
        'activa': _activa,
      });
      if (mounted) {
        MissionSnackbar.show(context,
            message: 'Pregunta actualizada correctamente.');
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
              width: 560,
              child: Column(
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
            Text('Editar pregunta',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            Text('Modifica los campos de la pregunta',
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
            MissionInput(
              label: 'ENUNCIADO',
              controller: _enunciadoCtrl,
              maxLines: 3,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Campo requerido'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildDificultadDropdown()),
              const SizedBox(width: 16),
              Expanded(
                  child: MissionInput(
                      label: 'PUNTOS',
                      controller: _puntosCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Requerido'
                          : null)),
              const SizedBox(width: 16),
              Expanded(
                  child: MissionInput(
                      label: 'ORDEN',
                      controller: _ordenCtrl,
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Requerido'
                          : null)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Switch(
                  value: _activa,
                  onChanged: (v) => setState(() => _activa = v),
                  activeColor: AppColors.neonGreen),
              const SizedBox(width: 8),
              Text(_activa ? 'Activa' : 'Inactiva',
                  style: TextStyle(
                      color: _activa
                          ? AppColors.neonGreen
                          : AppColors.textMuted,
                      fontSize: 13)),
            ]),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                  child: MissionButton(
                      label: 'Cancelar',
                      onPressed: () => Navigator.pop(context),
                      variant: MissionButtonVariant.ghost)),
              const SizedBox(width: 12),
              Expanded(
                  child: MissionButton(
                      label: 'Guardar cambios',
                      icon: Icons.save_outlined,
                      loading: _loading,
                      onPressed: _guardar)),
            ]),
          ],
        ),
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.06);
  }

  Widget _buildDificultadDropdown() {
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
              border: Border.all(color: AppColors.border)),
          child: DropdownButtonFormField<String>(
            value: _dificultad,
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
            items: const [
              DropdownMenuItem(
                  value: 'FACIL', child: Text('Fácil')),
              DropdownMenuItem(
                  value: 'MEDIA', child: Text('Media')),
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
}