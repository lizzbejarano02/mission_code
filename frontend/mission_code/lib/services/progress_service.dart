import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';
import '../models/progreso_model.dart';
import '../models/ranking_model.dart';

class ProgressService {
  final ApiClient _api = ApiClient.instance;

  Future<List<ProgresoModel>> getProgreso({int? usuarioId}) async {
    try {
      final response = await _api.get(
        ApiConstants.progreso,
        params: usuarioId != null ? {'usuario_id': usuarioId} : null,
      );
      final list = response.data['results'] ?? response.data;
      return (list as List).map((j) => ProgresoModel.fromJson(j)).toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<EstadisticaModel> getEstadisticas({int? usuarioId}) async {
    try {
      final response = await _api.get(
        ApiConstants.estadisticas,
        params: usuarioId != null ? {'usuario_id': usuarioId} : null,
      );
      return EstadisticaModel.fromJson(response.data);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<RankingModel>> getRanking() async {
    try {
      final response = await _api.get(ApiConstants.ranking);
      final list = response.data['results'] ?? response.data;
      return (list as List).map((j) => RankingModel.fromJson(j)).toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}