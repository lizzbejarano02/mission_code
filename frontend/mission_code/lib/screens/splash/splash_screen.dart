import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/colors/app_colors.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Espera mínimo 2.5s para la animación
    Future.delayed(const Duration(milliseconds: 2500), _navigate);
  }

  void _navigate() {
    if (_navigated || !mounted) return;
    final state = ref.read(authProvider);
    if (state is AuthAuthenticated) {
      _navigated = true;
      final role = state.usuario.rol;
      if (role == 'ADMINISTRADOR') context.go('/admin');
      else if (role == 'DOCENTE')  context.go('/teacher');
      else context.go('/student');
    } else if (state is AuthUnauthenticated || state is AuthError) {
      _navigated = true;
      context.go('/auth/login');
    }
    // Si aún está loading, el listener en el build se encargará
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Escuchar cambios del estado
    final state = ref.read(authProvider);
    if (state is! AuthInitial && state is! AuthLoading) {
      Future.microtask(_navigate);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reaccionar a cambios
    ref.listen(authProvider, (_, next) {
      if (next is! AuthInitial && next is! AuthLoading) {
        _navigate();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.bg900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Partículas de fondo (decorativas)
            _buildParticles(),
            // Logo
            _buildLogo(),
            const SizedBox(height: 48),
            // Loading dots
            _buildLoadingDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100, height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.neonGreen, AppColors.neonBlue],
            ),
            boxShadow: [
              BoxShadow(color: AppColors.greenGlow, blurRadius: 40, spreadRadius: 8),
            ],
          ),
          child: const Icon(Icons.code, color: AppColors.bg800, size: 52),
        )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .scale(begin: const Offset(0.7, 0.7), duration: 800.ms, curve: Curves.elasticOut),

        const SizedBox(height: 28),

        Text(
          'MISSION CODE',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 4,
            shadows: [Shadow(color: AppColors.neonGreen.withOpacity(0.6), blurRadius: 20)],
          ),
        )
        .animate(delay: 400.ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        Text(
          'Plataforma gamificada · Ingeniería de Software',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        )
        .animate(delay: 700.ms)
        .fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) =>
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 6, height: 6,
          decoration: const BoxDecoration(
            color: AppColors.neonGreen,
            shape: BoxShape.circle,
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .fadeIn(delay: Duration(milliseconds: i * 200))
        .then()
        .fadeOut(delay: 400.ms),
      ),
    );
  }

  Widget _buildParticles() {
    // Puntos decorativos de fondo
    return const SizedBox.shrink();
  }
}