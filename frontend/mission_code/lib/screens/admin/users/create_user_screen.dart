import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/user_provider.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';
import '../../../widgets/common/mission_snackbar.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _codigoCtrl = TextEditingController();

  String _rol = 'ESTUDIANTE';
  bool _obscure = true;
  bool _loading = false;
  static const String _carreraFija = 'Ingeniería de Software';

  bool get _esEstudiante => _rol == 'ESTUDIANTE';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nombreCtrl.dispose();
    _passCtrl.dispose();
    _codigoCtrl.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(userServiceProvider).crearUsuario(
            email: _emailCtrl.text.trim(),
            nombreCompleto: _nombreCtrl.text.trim(),
            password: _passCtrl.text,
            rol: _rol,
            codigoUniversitario:
                _esEstudiante ? _codigoCtrl.text.trim() : null,
            carrera: _esEstudiante ? _carreraFija : null,
          );
      if (mounted) {
        MissionSnackbar.show(context,
            message: 'Usuario creado correctamente.');
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
    final isWide = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: AppColors.bg800,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isWide ? 40 : 20),
          child: Center(
            child: SizedBox(
              width: 540,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 28),
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
            Text(
              'Crear nuevo usuario',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Completa los campos para registrar un nuevo usuario',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
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
            _buildRolSelector(),
            const SizedBox(height: 20),
            MissionInput(
              label: 'NOMBRE COMPLETO',
              hint: 'Juan Pérez García',
              controller: _nombreCtrl,
              prefixIcon: const Icon(Icons.person_outline,
                  color: AppColors.textMuted, size: 18),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            MissionInput(
              label: 'CORREO ELECTRÓNICO',
              hint: 'usuario@universidad.edu.co',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.mail_outline,
                  color: AppColors.textMuted, size: 18),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Campo requerido';
                if (!v.contains('@')) return 'Correo inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (_esEstudiante) ...[
              MissionInput(
                label: 'CÓDIGO UNIVERSITARIO',
                hint: '2021001',
                controller: _codigoCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.badge_outlined,
                    color: AppColors.textMuted, size: 18),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              _buildCarreraFija(),
              const SizedBox(height: 16),
            ],
            MissionInput(
              label: 'CONTRASEÑA',
              hint: 'Mínimo 8 caracteres',
              controller: _passCtrl,
              obscureText: _obscure,
              prefixIcon: const Icon(Icons.lock_outline,
                  color: AppColors.textMuted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                    _obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textMuted,
                    size: 18),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Campo requerido';
                if (v.length < 8) return 'Mínimo 8 caracteres';
                return null;
              },
            ),
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
                    label: 'Crear usuario',
                    icon: Icons.person_add_outlined,
                    loading: _loading,
                    onPressed: _crear,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.08);
  }

  Widget _buildRolSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ROL DEL USUARIO',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _RolOption(
              label: 'Estudiante',
              icon: Icons.school_outlined,
              selected: _rol == 'ESTUDIANTE',
              color: AppColors.neonGreen,
              onTap: () => setState(() => _rol = 'ESTUDIANTE'),
            ),
            const SizedBox(width: 8),
            _RolOption(
              label: 'Docente',
              icon: Icons.person_outlined,
              selected: _rol == 'DOCENTE',
              color: AppColors.neonBlue,
              onTap: () => setState(() => _rol = 'DOCENTE'),
            ),
            const SizedBox(width: 8),
            _RolOption(
              label: 'Admin',
              icon: Icons.admin_panel_settings_outlined,
              selected: _rol == 'ADMINISTRADOR',
              color: AppColors.neonPurple,
              onTap: () => setState(() => _rol = 'ADMINISTRADOR'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCarreraFija() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CARRERA',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.computer,
                  color: AppColors.neonGreen, size: 17),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  _carreraFija,
                  style: TextStyle(
                      color: AppColors.textPrimary, fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text('AUTO',
                    style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RolOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _RolOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.12) : AppColors.bg900,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  color: selected ? color : AppColors.textMuted,
                  size: 20),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: selected ? color : AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}