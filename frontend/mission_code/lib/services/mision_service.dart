import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';

class MisionService {
  final ApiClient _api = ApiClient.instance;

  Future<List<Map<String, dynamic>>> getMisiones({int? nivelId}) async {
    try {
      final response = await _api.get(
        ApiConstants.misiones,
        params: nivelId != null ? {'nivel': nivelId} : null,
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

  Future<Map<String, dynamic>> createMision(
      Map<String, dynamic> data) async {
    try {
      final response =
          await _api.post(ApiConstants.misiones, data: data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> updateMision(
      int id, Map<String, dynamic> data) async {
    try {
      final response =
          await _api.patch('${ApiConstants.misiones}$id/', data: data);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> deleteMision(int id) async {
    try {
      await _api.delete('${ApiConstants.misiones}$id/');
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}