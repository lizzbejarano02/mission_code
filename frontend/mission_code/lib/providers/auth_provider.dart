import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/usuario_model.dart';

// ─── Estados ──────────────────────────────────────────
sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UsuarioModel usuario;
  AuthAuthenticated(this.usuario);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// ─── Notifier ─────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _service;

  AuthNotifier(this._service) : super(AuthInitial()) {
    _checkSession();
  }

  UsuarioModel? get currentUser {
    final s = state;
    if (s is AuthAuthenticated) return s.usuario;
    return null;
  }

  Future<void> _checkSession() async {
    state = AuthLoading();
    try {
      final hasSession = await _service.hasValidSession();
      if (hasSession) {
        final user = await _service.getPerfil();
        if (user != null) {
          state = AuthAuthenticated(user);
        } else {
          state = AuthUnauthenticated();
        }
      } else {
        state = AuthUnauthenticated();
      }
    } catch (_) {
      state = AuthUnauthenticated();
    }
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    try {
      final data = await _service.login(
          email: email, password: password);
      final usuario = UsuarioModel.fromJson(
          data['usuario'] as Map<String, dynamic>);
      state = AuthAuthenticated(usuario);
      return usuario.rol;
    } catch (e) {
      state = AuthError(e.toString());
      rethrow;
    }
  }

  Future<String> register({
    required String email,
    required String nombreCompleto,
    required String password,
    required String password2,
    required String rol,
    String? codigoUniversitario,
    String? carrera,
  }) async {
    state = AuthLoading();
    try {
      final data = await _service.register(
        email: email,
        nombreCompleto: nombreCompleto,
        password: password,
        password2: password2,
        rol: rol,
        codigoUniversitario: codigoUniversitario,
        carrera: carrera,
      );
      final raw = data['usuario'] as Map<String, dynamic>? ?? data;
      final usuario = UsuarioModel.fromJson(raw);
      state = AuthAuthenticated(usuario);
      return usuario.rol;
    } catch (e) {
      state = AuthError(e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    final refreshToken = await _service.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _service.logout(refreshToken);
      } catch (_) {}
    }
    state = AuthUnauthenticated();
  }
}

// ─── Providers ────────────────────────────────────────
final authServiceProvider = Provider<AuthService>(
    (_) => AuthService());

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});