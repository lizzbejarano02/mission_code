import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';
import '../models/usuario_model.dart';

// ─── Service provider ─────────────────────────────────
final userServiceProvider =
    Provider<UserService>((_) => UserService());

// ─── Estado ───────────────────────────────────────────
class EstudiantesState {
  final List<UsuarioModel> items;
  final List<UsuarioModel> filtered;
  final bool loading;
  final String? error;
  final String searchQuery;

  const EstudiantesState({
    this.items = const [],
    this.filtered = const [],
    this.loading = false,
    this.error,
    this.searchQuery = '',
  });

  EstudiantesState copyWith({
    List<UsuarioModel>? items,
    List<UsuarioModel>? filtered,
    bool? loading,
    String? error,
    bool clearError = false,
    String? searchQuery,
  }) {
    return EstudiantesState(
      items: items ?? this.items,
      filtered: filtered ?? this.filtered,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────
class EstudiantesNotifier extends StateNotifier<EstudiantesState> {
  final UserService _service;

  EstudiantesNotifier(this._service)
      : super(const EstudiantesState()) {
    cargar();
  }

  Future<void> cargar() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final lista = await _service.getEstudiantes();
      state = state.copyWith(
        items: lista,
        filtered: lista,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void buscar(String query) {
    final q = query.toLowerCase().trim();
    final filtered = q.isEmpty
        ? state.items
        : state.items.where((u) {
            return u.nombreCompleto.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q) ||
                (u.codigoUniversitario
                        ?.toLowerCase()
                        .contains(q) ??
                    false);
          }).toList();
    state =
        state.copyWith(filtered: filtered, searchQuery: query);
  }

  void filtrarPorRol(String? rol) {
    if (rol == null || rol.isEmpty) {
      state = state.copyWith(filtered: state.items);
      return;
    }
    state = state.copyWith(
      filtered: state.items.where((u) => u.rol == rol).toList(),
    );
  }

  void agregar(UsuarioModel usuario) {
    final updated = [...state.items, usuario];
    state = state.copyWith(items: updated, filtered: updated);
  }
}

// ─── Provider ─────────────────────────────────────────
final estudiantesProvider =
    StateNotifierProvider<EstudiantesNotifier, EstudiantesState>(
        (ref) {
  return EstudiantesNotifier(ref.watch(userServiceProvider));
});