import 'usuario_model.dart';
class AuthTokensModel {
  final String access;
  final String refresh;
  final UsuarioModel usuario;

  const AuthTokensModel({
    required this.access,
    required this.refresh,
    required this.usuario,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) => AuthTokensModel(
    access: json['access'],
    refresh: json['refresh'],
    usuario: UsuarioModel.fromJson(json['usuario']),
  );
}

// Necesitamos importar UsuarioModel
