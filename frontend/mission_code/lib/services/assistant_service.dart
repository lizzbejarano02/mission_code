import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';

class AssistantService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Map<String, dynamic>>> getRecomendaciones() async {
    try {
      final response = await _api.get(ApiConstants.recomendaciones);
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return (list as List)
          .map((j) => j as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getNotificaciones() async {
    try {
      final response = await _api.get('/assistant/obtener_notificaciones/');
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return (list as List)
          .map((j) => j as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> enviarMensaje(String mensaje) async {
    try {
      final response = await _api.post(
        ApiConstants.enviarMensaje,
        data: {'mensaje': mensaje},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getMensajes() async {
    try {
      final response = await _api.get(ApiConstants.mensajes);
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return (list as List)
          .map((j) => j as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}