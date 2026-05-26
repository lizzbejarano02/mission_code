import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../design_system/buttons/mission_button.dart';
import '../../../design_system/inputs/mission_input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    try {
      await ref.read(authProvider.notifier).login(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: Stack(
        children: [
          // Fondo con gradiente sutil
          _buildBackground(),
          // Contenido
          Center(
            child: SingleChildScrollView(
              child: isWide ? _buildWideLayout() : _buildMobileLayout(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Círculo verde top-left
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonGreen.withOpacity(0.05),
              ),
            ),
          ),
          // Círculo azul bottom-right
          Positioned(
            bottom: -80, right: -80,
            child: Container(
              width: 350, height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonBlue.withOpacity(0.05),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        // Panel izquierdo — branding
        Expanded(child: _buildBrandPanel()),
        // Panel derecho — formulario
        Expanded(
          child: Center(
            child: SizedBox(
              width: 440,
              child: _buildFormCard(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildLogoMobile(),
          const SizedBox(height: 40),
          _buildFormCard(),
        ],
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [AppColors.neonGreen, AppColors.neonBlue],
              ),
              boxShadow: [BoxShadow(color: AppColors.greenGlow, blurRadius: 30)],
            ),
            child: const Icon(Icons.code, color: AppColors.bg800, size: 38),
          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: 40),

          Text(
            'MISSION\nCODE',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.1,
              shadows: [Shadow(color: AppColors.neonGreen.withOpacity(0.4), blurRadius: 30)],
            ),
          ).animate(delay: 200.ms).fadeIn().slideX(begin: -0.2),

          const SizedBox(height: 16),

          Text(
            'Plataforma gamificada para\nIngeniería de Software',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
            ),
          ).animate(delay: 400.ms).fadeIn(),

          const SizedBox(height: 48),

          // Features
          ...[
            ('⚡', 'Aprende jugando'),
            ('🏆', 'Compite en el ranking'),
            ('🎯', 'Completa misiones'),
          ].map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(children: [
              Text(f.$1, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(f.$2, style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 14,
              )),
            ]),
          ).animate(delay: 600.ms).fadeIn().slideX(begin: -0.1)),
        ],
      ),
    );
  }

  Widget _buildLogoMobile() {
    return Column(
      children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppColors.neonGreen, AppColors.neonBlue],
            ),
          ),
          child: const Icon(Icons.code, color: AppColors.bg800, size: 34),
        ),
        const SizedBox(height: 16),
        const Text('MISSION CODE', style: TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 3,
        )),
      ],
    );
  }

  Widget _buildFormCard() {
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
            const Text(
              'Iniciar sesión',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Bienvenido de nuevo a tu plataforma',
              style: TextStyle(color: AppColors.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 28),

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
            const SizedBox(height: 20),

            MissionInput(
              label: 'CONTRASEÑA',
              hint: '••••••••',
              controller: _passCtrl,
              obscureText: _obscure,
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted, size: 18,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'La contraseña es requerida' : null,
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text('¿Olvidaste tu contraseña?',
                  style: TextStyle(color: AppColors.neonBlue, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),

            // Error message
            if (_error != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.danger.withOpacity(0.3)),
                ),
                child: Row(children: [
                  const Icon(Icons.error_outline, color: AppColors.danger, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!,
                    style: const TextStyle(color: AppColors.danger, fontSize: 12))),
                ]),
              ),
              const SizedBox(height: 16),
            ],

            MissionButton(
              label: 'Entrar al sistema',
              onPressed: _login,
              loading: _loading,
              fullWidth: true,
              icon: Icons.arrow_forward_outlined,
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.border),
            const SizedBox(height: 16),

            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¿No tienes cuenta? ',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  GestureDetector(
                    onTap: () => context.go('/auth/register'),
                    child: const Text('Regístrate',
                      style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms)
     .slideY(begin: 0.1, end: 0);
  }
}