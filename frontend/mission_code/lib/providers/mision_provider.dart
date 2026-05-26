import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/mision_service.dart';

final misionServiceProvider =
    Provider<MisionService>((_) => MisionService());

class MisionesState {
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> filtered;
  final bool loading;
  final String? error;

  const MisionesState({
    this.items = const [],
    this.filtered = const [],
    this.loading = false,
    this.error,
  });

  MisionesState copyWith({
    List<Map<String, dynamic>>? items,
    List<Map<String, dynamic>>? filtered,
    bool? loading,
    String? error,
    bool clearError = false,
  }) {
    return MisionesState(
      items: items ?? this.items,
      filtered: filtered ?? this.filtered,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class MisionesNotifier extends StateNotifier<MisionesState> {
  final MisionService _service;

  MisionesNotifier(this._service)
      : super(const MisionesState()) {
    cargar();
  }

  Future<void> cargar({int? nivelId}) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final lista =
          await _service.getMisiones(nivelId: nivelId);
      state = state.copyWith(
          items: lista, filtered: lista, loading: false);
    } catch (e) {
      state =
          state.copyWith(loading: false, error: e.toString());
    }
  }

  void buscar(String query) {
    final q = query.toLowerCase();
    final f = q.isEmpty
        ? state.items
        : state.items
            .where((m) =>
                (m['nombre'] as String? ?? '')
                    .toLowerCase()
                    .contains(q) ||
                (m['descripcion'] as String? ?? '')
                    .toLowerCase()
                    .contains(q))
            .toList();
    state = state.copyWith(filtered: f);
  }

  void filtrarPorEstado(String? estado) {
    if (estado == null || estado.isEmpty) {
      state = state.copyWith(filtered: state.items);
      return;
    }
    state = state.copyWith(
      filtered: state.items
          .where((m) => m['estado'] == estado)
          .toList(),
    );
  }
}

final misionesProvider =
    StateNotifierProvider<MisionesNotifier, MisionesState>(
        (ref) {
  return MisionesNotifier(ref.watch(misionServiceProvider));
});