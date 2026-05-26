import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl   = TextEditingController();
  final _nombreCtrl  = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _pass2Ctrl   = TextEditingController();
  final _codigoCtrl  = TextEditingController();

  String _rolSeleccionado = 'ESTUDIANTE';
  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _loading  = false;
  String? _error;

  static const String _carreraFija = 'Ingeniería de Software';
  bool get _esEstudiante => _rolSeleccionado == 'ESTUDIANTE';

  @override
  void dispose() {
    _emailCtrl.dispose(); _nombreCtrl.dispose();
    _passCtrl.dispose(); _pass2Ctrl.dispose(); _codigoCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authProvider.notifier).register(
        email: _emailCtrl.text.trim(),
        nombreCompleto: _nombreCtrl.text.trim(),
        password: _passCtrl.text,
        password2: _pass2Ctrl.text,
        rol: _rolSeleccionado,
        codigoUniversitario: _esEstudiante ? _codigoCtrl.text.trim() : null,
        carrera: _esEstudiante ? _carreraFija : null,
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SizedBox(
              width: 500,
              child: _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface600,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera
            Row(children: [
              GestureDetector(
                onTap: () => context.go('/auth/login'),
                child: const Icon(Icons.arrow_back, color: AppColors.textMuted, size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Crear cuenta', style: TextStyle(
                color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700,
              )),
            ]),
            const SizedBox(height: 6),
            const Text('Únete a Mission Code y empieza a aprender',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 28),

            // Selector de rol
            _buildRolSelector(),
            const SizedBox(height: 20),

            // Nombre completo
            MissionInput(
              label: 'NOMBRE COMPLETO',
              hint: 'Juan Pérez García',
              controller: _nombreCtrl,
              prefixIcon: const Icon(Icons.person_outline, color: AppColors.textMuted, size: 18),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'El nombre es requerido' : null,
            ),
            const SizedBox(height: 16),

            // Email
            MissionInput(
              label: 'CORREO ELECTRÓNICO',
              hint: 'tu@universidad.edu.co',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textMuted, size: 18),
              validator: (v) {
                if (v == null || v.isEmpty) return 'El correo es requerido';
                if (!v.contains('@')) return 'Correo inválido';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Campos específicos por rol
            if (_esEstudiante) ...[
              // Código universitario
              MissionInput(
                label: 'CÓDIGO UNIVERSITARIO',
                hint: '2021001',
                controller: _codigoCtrl,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.textMuted, size: 18),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'El código es requerido' : null,
              ),
              const SizedBox(height: 16),

              // Carrera (fija, no editable)
              _buildCarreraFija(),
              const SizedBox(height: 16),
            ],

            // Contraseña
            MissionInput(
              label: 'CONTRASEÑA',
              hint: '••••••••',
              controller: _passCtrl,
              obscureText: _obscure1,
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(_obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted, size: 18),
                onPressed: () => setState(() => _obscure1 = !_obscure1),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'La contraseña es requerida';
                if (v.length < 8) return 'Mínimo 8 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Confirmar contraseña
            MissionInput(
              label: 'CONFIRMAR CONTRASEÑA',
              hint: '••••••••',
              controller: _pass2Ctrl,
              obscureText: _obscure2,
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(_obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted, size: 18),
                onPressed: () => setState(() => _obscure2 = !_obscure2),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
                return null;
              },
            ),
            const SizedBox(height: 20),

            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                ),
                child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
              ),
              const SizedBox(height: 16),
            ],

            MissionButton(
              label: 'Crear cuenta',
              onPressed: _register,
              loading: _loading,
              fullWidth: true,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildRolSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ROL', style: TextStyle(
          color: AppColors.textSecondary, fontSize: 12,
          fontWeight: FontWeight.w500, letterSpacing: 0.5,
        )),
        const SizedBox(height: 8),
        Row(
          children: [
            _RolChip(
              label: 'Estudiante',
              icon: Icons.school_outlined,
              selected: _rolSeleccionado == 'ESTUDIANTE',
              color: AppColors.neonGreen,
              onTap: () => setState(() => _rolSeleccionado = 'ESTUDIANTE'),
            ),
            const SizedBox(width: 8),
            _RolChip(
              label: 'Docente',
              icon: Icons.person_outlined,
              selected: _rolSeleccionado == 'DOCENTE',
              color: AppColors.neonBlue,
              onTap: () => setState(() => _rolSeleccionado = 'DOCENTE'),
            ),
            const SizedBox(width: 8),
            _RolChip(
              label: 'Admin',
              icon: Icons.admin_panel_settings_outlined,
              selected: _rolSeleccionado == 'ADMINISTRADOR',
              color: AppColors.neonPurple,
              onTap: () => setState(() => _rolSeleccionado = 'ADMINISTRADOR'),
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
        const Text('CARRERA', style: TextStyle(
          color: AppColors.textSecondary, fontSize: 12,
          fontWeight: FontWeight.w500, letterSpacing: 0.5,
        )),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.neonGreen.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
          ),
          child: Row(children: [
            const Icon(Icons.computer, color: AppColors.neonGreen, size: 18),
            const SizedBox(width: 10),
            const Text(_carreraFija, style: TextStyle(
              color: AppColors.textPrimary, fontSize: 14,
            )),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('FIJA', style: TextStyle(
                color: AppColors.neonGreen, fontSize: 10, fontWeight: FontWeight.w700,
              )),
            ),
          ]),
        ),
      ],
    );
  }
}

class _RolChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _RolChip({
    required this.label, required this.icon,
    required this.selected, required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : AppColors.surface600,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? color : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? color : AppColors.textMuted, size: 18),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(
                color: selected ? color : AppColors.textMuted,
                fontSize: 11, fontWeight: FontWeight.w500,
              )),
            ],
          ),
        ),
      ),
    );
  }
}