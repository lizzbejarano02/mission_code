import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../models/usuario_model.dart';
import '../../../providers/user_provider.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/common/mission_snackbar.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final UsuarioModel usuario;
  const EditUserScreen({super.key, required this.usuario});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _carreraCtrl;
  late final TextEditingController _codigoCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.usuario.nombreCompleto);
    _carreraCtrl =
        TextEditingController(text: widget.usuario.carrera ?? '');
    _codigoCtrl = TextEditingController(
        text: widget.usuario.codigoUniversitario ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _carreraCtrl.dispose();
    _codigoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final data = <String, dynamic>{
        'nombre_completo': _nombreCtrl.text.trim(),
      };
      if (widget.usuario.esEstudiante) {
        data['codigo_universitario'] = _codigoCtrl.text.trim();
        data['carrera'] = _carreraCtrl.text.trim();
      }
      await ref.read(userServiceProvider).editarPerfil(data);
      if (mounted) {
        MissionSnackbar.show(context,
            message: 'Usuario actualizado correctamente.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        MissionSnackbar.show(context, message: e.toString(), isError: true);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.usuario;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Center(
            child: SizedBox(
              width: 520,
              child: Column(
                children: [
                  _buildHeader(context, u),
                  const SizedBox(height: 24),
                  _buildForm(u),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UsuarioModel u) {
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editar usuario',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                u.email,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildForm(UsuarioModel u) {
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
            // Info no editable
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bg900,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.textMuted, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Email y rol no son editables: ${u.email}',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            MissionInput(
              label: 'NOMBRE COMPLETO',
              controller: _nombreCtrl,
              prefixIcon: const Icon(Icons.person_outline,
                  color: AppColors.textMuted, size: 18),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Campo requerido'
                  : null,
            ),
            if (u.esEstudiante) ...[
              const SizedBox(height: 16),
              MissionInput(
                label: 'CÓDIGO UNIVERSITARIO',
                controller: _codigoCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.badge_outlined,
                    color: AppColors.textMuted, size: 18),
              ),
              const SizedBox(height: 16),
              MissionInput(
                label: 'CARRERA',
                controller: _carreraCtrl,
                prefixIcon: const Icon(Icons.computer,
                    color: AppColors.textMuted, size: 18),
              ),
            ],
            const SizedBox(height: 28),
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
                    label: 'Guardar cambios',
                    icon: Icons.save_outlined,
                    loading: _loading,
                    onPressed: _guardar,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05);
  }
}