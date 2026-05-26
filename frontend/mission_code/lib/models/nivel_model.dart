class NivelModel {
  final int id;
  final String nombre;
  final String descripcion;
  final int orden;
  final String dificultad;
  final int puntosRequeridos;
  final String? imagen;
  final bool activo;
  final int totalMisiones;

  const NivelModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.orden,
    required this.dificultad,
    required this.puntosRequeridos,
    this.imagen,
    required this.activo,
    required this.totalMisiones,
  });

  factory NivelModel.fromJson(Map<String, dynamic> json) => NivelModel(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    orden: json['orden'],
    dificultad: json['dificultad'],
    puntosRequeridos: json['puntos_requeridos'],
    imagen: json['imagen'],
    activo: json['activo'] ?? true,
    totalMisiones: json['total_misiones'] ?? 0,
  );
}