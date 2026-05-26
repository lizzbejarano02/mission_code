import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pregunta_service.dart';
import '../models/pregunta_model.dart';

final preguntaServiceProvider =
    Provider<PreguntaService>((_) => PreguntaService());

class PreguntasState {
  final List<PreguntaModel> items;
  final List<PreguntaModel> filtered;
  final bool loading;
  final String? error;

  const PreguntasState({
    this.items = const [],
    this.filtered = const [],
    this.loading = false,
    this.error,
  });

  PreguntasState copyWith({
    List<PreguntaModel>? items,
    List<PreguntaModel>? filtered,
    bool? loading,
    String? error,
  }) =>
      PreguntasState(
        items: items ?? this.items,
        filtered: filtered ?? this.filtered,
        loading: loading ?? this.loading,
        error: error,
      );
}

class PreguntasNotifier extends StateNotifier<PreguntasState> {
  final PreguntaService _service;

  PreguntasNotifier(this._service) : super(const PreguntasState()) {
    cargar();
  }

  Future<void> cargar({int? misionId}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final lista = await _service.getPreguntas(misionId: misionId);
      state = state.copyWith(
          items: lista, filtered: lista, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void buscar(String query) {
    final q = query.toLowerCase().trim();
    final filtered = q.isEmpty
        ? state.items
        : state.items.where((p) {
            return p.enunciado.toLowerCase().contains(q) ||
                p.tipo.toLowerCase().contains(q) ||
                p.dificultad.toLowerCase().contains(q);
          }).toList();
    state = state.copyWith(filtered: filtered);
  }

  void filtrarPorDificultad(String? dificultad) {
    if (dificultad == null || dificultad.isEmpty) {
      state = state.copyWith(filtered: state.items);
      return;
    }
    state = state.copyWith(
      filtered:
          state.items.where((p) => p.dificultad == dificultad).toList(),
    );
  }
}

final preguntasProvider =
    StateNotifierProvider<PreguntasNotifier, PreguntasState>((ref) {
  return PreguntasNotifier(ref.read(preguntaServiceProvider));
});