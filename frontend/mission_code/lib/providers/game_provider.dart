import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/game_service.dart';
import '../models/nivel_model.dart';
import '../models/mision_model.dart';
import '../models/pregunta_model.dart';

final gameServiceProvider = Provider((_) => GameService());

// Niveles
final nivelesProvider = FutureProvider<List<NivelModel>>((ref) async {
  return ref.read(gameServiceProvider).getNiveles();
});

// Misiones por nivel
final misionesProvider = FutureProvider.family<List<MisionModel>, int?>((ref, nivelId) async {
  return ref.read(gameServiceProvider).getMisiones(nivelId: nivelId);
});

// Preguntas por misión
final preguntasProvider = FutureProvider.family<List<PreguntaModel>, int?>((ref, misionId) async {
  return ref.read(gameServiceProvider).getPreguntas(misionId: misionId);
});