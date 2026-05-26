class ProgresoModel {
  final int id;
  final int usuario;
  final String nivelNombre;
  final String misionNombre;
  final String estado;
  final int puntosObtenidos;
  final double porcentajeCompletado;
  final int intentos;

  const ProgresoModel({
    required this.id,
    required this.usuario,
    required this.nivelNombre,
    required this.misionNombre,
    required this.estado,
    required this.puntosObtenidos,
    required this.porcentajeCompletado,
    required this.intentos,
  });

  factory ProgresoModel.fromJson(Map<String, dynamic> json) => ProgresoModel(
    id: json['id'],
    usuario: json['usuario'],
    nivelNombre: json['nivel_nombre'] ?? '',
    misionNombre: json['mision_nombre'] ?? '',
    estado: json['estado'],
    puntosObtenidos: json['puntos_obtenidos'],
    porcentajeCompletado: double.tryParse(json['porcentaje_completado'].toString()) ?? 0.0,
    intentos: json['intentos'],
  );
}

class EstadisticaModel {
  final int totalPreguntasRespondidas;
  final int totalRespuestasCorrectas;
  final int totalRespuestasIncorrectas;
  final double porcentajeAcierto;
  final int totalMisionesCompletadas;
  final int totalNivelesCompletados;
  final int rachaActual;
  final int rachaMaxima;

  const EstadisticaModel({
    required this.totalPreguntasRespondidas,
    required this.totalRespuestasCorrectas,
    required this.totalRespuestasIncorrectas,
    required this.porcentajeAcierto,
    required this.totalMisionesCompletadas,
    required this.totalNivelesCompletados,
    required this.rachaActual,
    required this.rachaMaxima,
  });

  factory EstadisticaModel.fromJson(Map<String, dynamic> json) => EstadisticaModel(
    totalPreguntasRespondidas: json['total_preguntas_respondidas'] ?? 0,
    totalRespuestasCorrectas: json['total_respuestas_correctas'] ?? 0,
    totalRespuestasIncorrectas: json['total_respuestas_incorrectas'] ?? 0,
    porcentajeAcierto: double.tryParse(json['porcentaje_acierto'].toString()) ?? 0.0,
    totalMisionesCompletadas: json['total_misiones_completadas'] ?? 0,
    totalNivelesCompletados: json['total_niveles_completados'] ?? 0,
    rachaActual: json['racha_actual'] ?? 0,
    rachaMaxima: json['racha_maxima'] ?? 0,
  );
}