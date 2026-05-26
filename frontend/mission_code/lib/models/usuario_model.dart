class UsuarioModel {
  final int id;
  final String email;
  final String nombreCompleto;
  final String? codigoUniversitario;
  final String? carrera;
  final String? avatar;
  final String rol;
  final int puntosTotales;

  const UsuarioModel({
    required this.id,
    required this.email,
    required this.nombreCompleto,
    this.codigoUniversitario,
    this.carrera,
    this.avatar,
    required this.rol,
    required this.puntosTotales,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
    id: json['id'],
    email: json['email'],
    nombreCompleto: json['nombre_completo'],
    codigoUniversitario: json['codigo_universitario'],
    carrera: json['carrera'],
    avatar: json['avatar'],
    rol: json['rol'],
    puntosTotales: json['puntos_totales'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'nombre_completo': nombreCompleto,
    'codigo_universitario': codigoUniversitario,
    'carrera': carrera,
    'avatar': avatar,
    'rol': rol,
    'puntos_totales': puntosTotales,
  };

  bool get esAdmin      => rol == 'ADMINISTRADOR';
  bool get esDocente    => rol == 'DOCENTE';
  bool get esEstudiante => rol == 'ESTUDIANTE';

  UsuarioModel copyWith({
    int? puntosTotales,
    String? nombreCompleto,
    String? carrera,
    String? avatar,
  }) => UsuarioModel(
    id: id, email: email,
    nombreCompleto: nombreCompleto ?? this.nombreCompleto,
    codigoUniversitario: codigoUniversitario,
    carrera: carrera ?? this.carrera,
    avatar: avatar ?? this.avatar,
    rol: rol,
    puntosTotales: puntosTotales ?? this.puntosTotales,
  );
}