import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';
import '../models/usuario_model.dart';

class UserService {
  final ApiClient _api = ApiClient.instance;

  Future<List<UsuarioModel>> getEstudiantes() async {
    try {
      final response = await _api.get(ApiConstants.estudiantes);
      final list = response.data is List
          ? response.data
          : (response.data['results'] ?? response.data);
      return (list as List).map((j) => UsuarioModel.fromJson(j)).toList();
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<UsuarioModel> getPerfil() async {
    try {
      final response = await _api.get(ApiConstants.perfil);
      return UsuarioModel.fromJson(response.data);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<UsuarioModel> editarPerfil(Map<String, dynamic> data) async {
    try {
      final response = await _api.patch(ApiConstants.editarUsuario, data: data);
      final raw = response.data;
      if (raw is Map && raw.containsKey('usuario')) {
        return UsuarioModel.fromJson(raw['usuario']);
      }
      return UsuarioModel.fromJson(raw);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<UsuarioModel> crearUsuario({
    required String email,
    required String nombreCompleto,
    required String password,
    required String rol,
    String? codigoUniversitario,
    String? carrera,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'email': email,
        'nombre_completo': nombreCompleto,
        'password': password,
        'password2': password,
        'rol': rol,
      };
      if (codigoUniversitario != null && codigoUniversitario.isNotEmpty) {
        body['codigo_universitario'] = codigoUniversitario;
      }
      if (carrera != null && carrera.isNotEmpty) {
        body['carrera'] = carrera;
      }
      final response = await _api.post(ApiConstants.register, data: body);
      final raw = response.data;
      if (raw is Map && raw.containsKey('usuario')) {
        return UsuarioModel.fromJson(raw['usuario']);
      }
      return UsuarioModel.fromJson(raw);
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}