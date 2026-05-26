class RankingModel {
  final int posicion;
  final int usuario;
  final String usuarioNombre;
  final String? avatar;
  final int puntos;
  final String? nivelNombre;

  const RankingModel({
    required this.posicion,
    required this.usuario,
    required this.usuarioNombre,
    this.avatar,
    required this.puntos,
    this.nivelNombre,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) => RankingModel(
    posicion: json['posicion'],
    usuario: json['usuario'],
    usuarioNombre: json['usuario_nombre'] ?? '',
    avatar: json['avatar'],
    puntos: json['puntos'],
    nivelNombre: json['nivel_nombre'],
  );
}