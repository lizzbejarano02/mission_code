import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/assistant_service.dart';

final assistantServiceProvider =
    Provider<AssistantService>((_) => AssistantService());

final recomendacionesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(assistantServiceProvider).getRecomendaciones();
});

final notificacionesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(assistantServiceProvider).getNotificaciones();
});