import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';
import '../models/pregunta_model.dart';
import '../models/nivel_model.dart';

class PreguntaService {
  final ApiClient _api = ApiClient.instance;

  Future<List<PreguntaModel>> getPreguntas({int? misionId}) async {
    try {
      final response = await _api.get(
        ApiConstants.preguntas,
        params: misionId != null ? {'mision': misionId} : null,
      );
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return (list as List)
          .map((j) => PreguntaModel.fromJson(j))
          .toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<PreguntaModel> createPregunta(Map<String, dynamic> data) async {
    try {
      final response =
          await _api.post(ApiConstants.preguntas, data: data);
      return PreguntaModel.fromJson(response.data);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<PreguntaModel> updatePregunta(
      int id, Map<String, dynamic> data) async {
    try {
      final response =
          await _api.patch('${ApiConstants.preguntas}$id/', data: data);
      return PreguntaModel.fromJson(response.data);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> deletePregunta(int id) async {
    try {
      await _api.delete('${ApiConstants.preguntas}$id/');
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> createRespuesta(Map<String, dynamic> data) async {
    try {
      await _api.post(ApiConstants.respuestas, data: data);
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

  Future<List<NivelModel>> getNiveles() async {
    try {
      final response = await _api.get(ApiConstants.niveles);
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return (list as List)
          .map((j) => NivelModel.fromJson(j))
          .toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<dynamic>> getMisiones({int? nivelId}) async {
    try {
      final response = await _api.get(
        ApiConstants.misiones,
        params: nivelId != null ? {'nivel': nivelId} : null,
      );
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return list as List;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}