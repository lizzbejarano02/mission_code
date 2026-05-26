class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Auth
  static const String register       = '/users/register/';
  static const String login          = '/users/login/';
  static const String logout         = '/users/logout/';
  static const String tokenRefresh   = '/users/token/refresh/';
  static const String perfil         = '/users/perfil/';
  static const String editarUsuario  = '/users/editar_usuario/';
  static const String estudiantes    = '/users/obtener_estudiantes/';

  // Game
  static const String niveles        = '/game/niveles/';
  static const String misiones       = '/game/misiones/';
  static const String preguntas      = '/game/preguntas/';
  static const String respuestas     = '/game/respuestas/';
  static const String responderPregunta = '/game/responder-pregunta/';
  static const String historialRespuestas = '/game/historial-respuestas/';

  // Progress
  static const String progreso       = '/progress/progreso/';
  static const String estadisticas   = '/progress/estadisticas/';
  static const String ranking        = '/progress/ranking/';

  // Assistant
  static const String enviarMensaje  = '/assistant/enviar_mensaje/';
  static const String mensajes       = '/assistant/obtener_mensajes/';
  static const String recomendaciones = '/assistant/obtener_recomendaciones/';
}