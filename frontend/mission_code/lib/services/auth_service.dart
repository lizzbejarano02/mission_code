import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';
import '../core/errors/app_exception.dart';
import '../constants/api_constants.dart';
import '../models/usuario_model.dart';

class AuthService {
  final ApiClient _api = ApiClient.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      await _saveTokens(data['access'], data['refresh']);
      return data;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> register({
    required String email,
    required String nombreCompleto,
    required String password,
    required String password2,
    required String rol,
    String? codigoUniversitario,
    String? carrera,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'email': email,
        'nombre_completo': nombreCompleto,
        'password': password,
        'password2': password2,
        'rol': rol,
      };
      if (codigoUniversitario != null) body['codigo_universitario'] = codigoUniversitario;
      if (carrera != null) body['carrera'] = carrera;

      final response = await _api.post(ApiConstants.register, data: body);
      final data = response.data as Map<String, dynamic>;
      await _saveTokens(data['tokens']['access'], data['tokens']['refresh']);
      return data;
    } catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> logout(String refreshToken) async {
    try {
      await _api.post(ApiConstants.logout, data: {'refresh': refreshToken});
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<UsuarioModel?> getPerfil() async {
    try {
      final response = await _api.get(ApiConstants.perfil);
      return UsuarioModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasValidSession() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  Future<String?> getAccessToken() => _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() => _storage.read(key: 'refresh_token');

  Future<void> _saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }
}