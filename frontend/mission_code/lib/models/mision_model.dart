class MisionModel {
  final int id;
  final int nivel;
  final String nombre;
  final String descripcion;
  final int orden;
  final int puntosRecompensa;
  final int tiempLimiteMinutos;
  final String estado;
  final int totalPreguntas;

  const MisionModel({
    required this.id,
    required this.nivel,
    required this.nombre,
    required this.descripcion,
    required this.orden,
    required this.puntosRecompensa,
    required this.tiempLimiteMinutos,
    required this.estado,
    required this.totalPreguntas,
  });

  factory MisionModel.fromJson(Map<String, dynamic> json) => MisionModel(
    id: json['id'],
    nivel: json['nivel'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    orden: json['orden'],
    puntosRecompensa: json['puntos_recompensa'],
    tiempLimiteMinutos: json['tiempo_limite_minutos'] ?? 0,
    estado: json['estado'],
    totalPreguntas: json['total_preguntas'] ?? 0,
  );
}