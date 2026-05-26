import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/progress_service.dart';
import '../models/progreso_model.dart';
import '../models/ranking_model.dart';

// ─── Service provider ─────────────────────────────────
final progressServiceProvider =
    Provider<ProgressService>((_) => ProgressService());

// ─── Providers ────────────────────────────────────────
final progresoProvider =
    FutureProvider<List<ProgresoModel>>((ref) async {
  return ref.read(progressServiceProvider).getProgreso();
});

final estadisticasProvider =
    FutureProvider<EstadisticaModel>((ref) async {
  return ref.read(progressServiceProvider).getEstadisticas();
});

final rankingProvider =
    FutureProvider<List<RankingModel>>((ref) async {
  return ref.read(progressServiceProvider).getRanking();
});