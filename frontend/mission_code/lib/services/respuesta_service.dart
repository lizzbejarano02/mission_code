import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';

class RespuestaService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Map<String, dynamic>>> getRespuestas(
      {int? preguntaId}) async {
    try {
      final response = await _api.get(
        ApiConstants.respuestas,
        params: preguntaId != null
            ? {'pregunta': preguntaId}
            : null,
      );
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

  Future<Map<String, dynamic>> createRespuesta(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _api.post(ApiConstants.respuestas, data: data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateRespuesta(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _api
          .patch('${ApiConstants.respuestas}$id/', data: data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> deleteRespuesta(int id) async {
    try {
      await _api.delete('${ApiConstants.respuestas}$id/');
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}