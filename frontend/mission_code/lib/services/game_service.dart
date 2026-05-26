import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';
import '../models/nivel_model.dart';
import '../models/mision_model.dart';
import '../models/pregunta_model.dart';

class GameService {
  final ApiClient _api = ApiClient.instance;

  Future<List<NivelModel>> getNiveles() async {
    try {
      final response = await _api.get(ApiConstants.niveles);
      final list = response.data['results'] ?? response.data;
      return (list as List).map((j) => NivelModel.fromJson(j)).toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<NivelModel> createNivel(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.niveles, data: data);
      return NivelModel.fromJson(response.data);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<NivelModel> updateNivel(int id, Map<String, dynamic> data) async {
    try {
      final response = await _api.patch('${ApiConstants.niveles}$id/', data: data);
      return NivelModel.fromJson(response.data);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> deleteNivel(int id) async {
    try {
      await _api.delete('${ApiConstants.niveles}$id/');
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<MisionModel>> getMisiones({int? nivelId}) async {
    try {
      final response = await _api.get(
        ApiConstants.misiones,
        params: nivelId != null ? {'nivel': nivelId} : null,
      );
      final list = response.data['results'] ?? response.data;
      return (list as List).map((j) => MisionModel.fromJson(j)).toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<PreguntaModel>> getPreguntas({int? misionId}) async {
    try {
      final response = await _api.get(
        ApiConstants.preguntas,
        params: misionId != null ? {'mision': misionId} : null,
      );
      final list = response.data['results'] ?? response.data;
      return (list as List).map((j) => PreguntaModel.fromJson(j)).toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> responderPregunta({
    required int preguntaId,
    int? respuestaId,
    String? respuestaTexto,
    int tiempoSegundos = 0,
  }) async {
    try {
      final body = <String, dynamic>{
        'pregunta_id': preguntaId,
        'tiempo_respuesta_segundos': tiempoSegundos,
      };
      if (respuestaId != null) body['respuesta_id'] = respuestaId;
      if (respuestaTexto != null) body['respuesta_texto'] = respuestaTexto;

      final response = await _api.post(ApiConstants.responderPregunta, data: body);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}