class RespuestaOpcionModel {
  final int id;
  final String texto;
  final int orden;

  const RespuestaOpcionModel({
    required this.id,
    required this.texto,
    required this.orden,
  });

  factory RespuestaOpcionModel.fromJson(Map<String, dynamic> json) =>
    RespuestaOpcionModel(
      id: json['id'],
      texto: json['texto'],
      orden: json['orden'],
    );
}

class PreguntaModel {
  final int id;
  final String enunciado;
  final String tipo;
  final String dificultad;
  final int puntos;
  final String? imagen;
  final int orden;
  final List<RespuestaOpcionModel> opcionesRespuesta;

  const PreguntaModel({
    required this.id,
    required this.enunciado,
    required this.tipo,
    required this.dificultad,
    required this.puntos,
    this.imagen,
    required this.orden,
    required this.opcionesRespuesta,
  });

  factory PreguntaModel.fromJson(Map<String, dynamic> json) => PreguntaModel(
    id: json['id'],
    enunciado: json['enunciado'],
    tipo: json['tipo'],
    dificultad: json['dificultad'],
    puntos: json['puntos'],
    imagen: json['imagen'],
    orden: json['orden'],
    opcionesRespuesta: (json['opciones_respuesta'] as List? ?? [])
        .map((r) => RespuestaOpcionModel.fromJson(r))
        .toList(),
  );
}