import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

// Splash
import '../screens/splash/splash_screen.dart';

// Auth
import '../screens/auth/login/login_screen.dart';
import '../screens/auth/register/register_screen.dart';

// Student
import '../screens/student/dashboard/student_dashboard_screen.dart';
import '../screens/student/niveles/niveles_screen.dart';
import '../screens/student/retos/retos_screen.dart';
import '../screens/student/ranking/ranking_screen.dart';
import '../screens/student/progreso/progreso_screen.dart';
import '../screens/student/perfil/perfil_screen.dart';
import '../screens/student/insignias/insignias_screen.dart';

// Teacher
import '../screens/teacher/dashboard/teacher_dashboard_screen.dart';

// Admin
import '../screens/admin/dashboard/admin_dashboard_screen.dart';
import '../screens/admin/users/users_crud_screen.dart';
import '../screens/admin/users/create_user_screen.dart';
//import '../screens/admin/niveles/niveles_crud_screen.dart';
import '../screens/admin/preguntas/preguntas_crud_screen.dart';
import '../screens/admin/misiones/misiones_crud_screen.dart';
import '../screens/admin/respuestas/respuestas_crud_screen.dart';

// Assistant
import '../screens/assistant/chat/chat_screen.dart';
import '../screens/assistant/recomendaciones/recomendaciones_screen.dart';
import '../screens/assistant/notificaciones/notificaciones_screen.dart';

// Shared layout
import '../widgets/navigation/scaffold_with_sidebar.dart';

// ─────────────────────────────────────────────────────
// Función auxiliar — fuera de cualquier clase
// ─────────────────────────────────────────────────────
String homeForRole(String rol) {
  if (rol == 'ADMINISTRADOR') return '/admin';
  if (rol == 'DOCENTE') return '/teacher';
  return '/student';
}

// ─────────────────────────────────────────────────────
// ChangeNotifier que escucha el authProvider
// ─────────────────────────────────────────────────────
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) {
      notifyListeners();
    });
  }
}

// ─────────────────────────────────────────────────────
// Provider del router
// ─────────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final loc = state.matchedLocation;

      final isLoading =
          authState is AuthInitial || authState is AuthLoading;
      final isAuth = authState is AuthAuthenticated;
      final onSplash = loc == '/splash';
      final onAuth = loc.startsWith('/auth');

      if (isLoading) {
        return onSplash ? null : '/splash';
      }

      if (!isAuth && !onAuth) {
        return '/auth/login';
      }

      if (isAuth && onAuth) {
        final usuario = (authState as AuthAuthenticated).usuario;
        return homeForRole(usuario.rol);
      }

      if (isAuth) {
        final usuario = (authState as AuthAuthenticated).usuario;
        final rol = usuario.rol;

        if (loc.startsWith('/admin') && rol != 'ADMINISTRADOR') {
          return homeForRole(rol);
        }
        if (loc.startsWith('/teacher') && rol == 'ESTUDIANTE') {
          return homeForRole(rol);
        }
        if (loc.startsWith('/admin/usuarios') && rol != 'ADMINISTRADOR') {
          return '/admin';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // ── Student ─────────────────────────────────────
      GoRoute(
        path: '/student',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: StudentDashboardScreen()),
      ),
      GoRoute(
        path: '/student/niveles',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: NivelesScreen()),
      ),
      GoRoute(
        path: '/student/retos/:misionId',
        builder: (_, state) {
          final id = int.tryParse(
                  state.pathParameters['misionId'] ?? '0') ??
              0;
          return RetosScreen(misionId: id);
        },
      ),
      GoRoute(
        path: '/student/ranking',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: RankingScreen()),
      ),
      GoRoute(
        path: '/student/progreso',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: ProgresoScreen()),
      ),
      GoRoute(
        path: '/student/perfil',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: PerfilScreen()),
      ),
      GoRoute(
        path: '/student/insignias',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: InsigniasScreen()),
      ),

      // ── Teacher ─────────────────────────────────────
      GoRoute(
        path: '/teacher',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: TeacherDashboardScreen()),
      ),
      GoRoute(
        path: '/teacher/estudiantes',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: TeacherDashboardScreen()),
      ),
      GoRoute(
        path: '/teacher/estadisticas',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: TeacherDashboardScreen()),
      ),
      GoRoute(
        path: '/teacher/reportes',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: TeacherDashboardScreen()),
      ),

      // ── Admin ────────────────────────────────────────
      GoRoute(
        path: '/admin',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: AdminDashboardScreen()),
      ),
      GoRoute(
        path: '/admin/usuarios',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: UsersCrudScreen()),
      ),
      GoRoute(
        path: '/admin/usuarios/nuevo',
        builder: (_, __) => const CreateUserScreen(),
      ),
      //GoRoute(
        //path: '/admin/niveles',
        //builder: (_, __) =>
            //const ScaffoldWithSidebar(child: NivelesCrudScreen()),
      //),
      GoRoute(
        path: '/admin/preguntas',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: PreguntasCrudScreen()),
      ),
      GoRoute(
        path: '/admin/misiones',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: MisionesCrudScreen()),
      ),
      GoRoute(
        path: '/admin/respuestas',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: RespuestasCrudScreen()),
      ),
      GoRoute(
        path: '/admin/estadisticas',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: AdminDashboardScreen()),
      ),
      GoRoute(
        path: '/admin/config',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: AdminDashboardScreen()),
      ),

      // ── Assistant ────────────────────────────────────
      GoRoute(
        path: '/chat',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: ChatScreen()),
      ),
      GoRoute(
        path: '/recomendaciones',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: RecomendacionesScreen()),
      ),
      GoRoute(
        path: '/notificaciones',
        builder: (_, __) =>
            const ScaffoldWithSidebar(child: NotificacionesScreen()),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: Color(0xFFEF4444), size: 56),
            const SizedBox(height: 16),
            const Text(
              'Página no encontrada',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? '',
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    ),
  );
});