"""
Views de la app assistant
"""

from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import MensajeChat, Recomendacion, Notificacion
from .serializers import (
    MensajeChatSerializer,
    EnviarMensajeSerializer,
    RecomendacionSerializer,
    NotificacionSerializer,
)


class EnviarMensajeView(APIView):
    """
    POST /api/assistant/enviar_mensaje/
    El usuario envia un mensaje al asistente.
    El sistema guarda el mensaje y genera una respuesta basica.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = EnviarMensajeSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        contenido = serializer.validated_data['contenido']
        usuario = request.user

        # Guardar mensaje del usuario
        MensajeChat.objects.create(
            usuario=usuario,
            remitente='USUARIO',
            contenido=contenido,
        )

        # Generar respuesta del asistente (básica — se puede integrar con IA)
        respuesta_texto = _generar_respuesta_asistente(contenido, usuario)

        # Guardar respuesta del asistente
        mensaje_asistente = MensajeChat.objects.create(
            usuario=usuario,
            remitente='ASISTENTE',
            contenido=respuesta_texto,
        )

        return Response({
            'mensaje_usuario': contenido,
            'respuesta_asistente': respuesta_texto,
            'fecha': mensaje_asistente.fecha_envio,
        }, status=status.HTTP_201_CREATED)


def _generar_respuesta_asistente(pregunta: str, usuario) -> str:
    """
    Genera una respuesta basica del asistente.
    En produccion, aqui se integraría con una API de IA (OpenAI, Gemini, etc.)
    """
    pregunta_lower = pregunta.lower()

    if 'hola' in pregunta_lower or 'buenos' in pregunta_lower:
        return f'¡Hola {usuario.nombre_completo}! Soy tu asistente de Ingenieria de Software. ¿En que puedo ayudarte hoy?'
    elif 'puntos' in pregunta_lower:
        return f'Tienes {usuario.puntos_totales} puntos acumulados. ¡Sigue respondiendo preguntas para ganar mas!'
    elif 'ingenieria de software' in pregunta_lower or 'is' in pregunta_lower:
        return 'La Ingenieria de Software es la disciplina que se ocupa del diseño, desarrollo y mantenimiento de software. ¿Quieres explorar algun tema especifico?'
    elif 'ayuda' in pregunta_lower:
        return 'Puedo ayudarte con: tus dudas sobre IS, revisar tu progreso, recomendarte misiones, o explicar conceptos del curso.'
    else:
        return f'Gracias por tu pregunta sobre "{pregunta[:50]}". Estoy aqui para apoyarte en tu aprendizaje de Ingenieria de Software. ¡Explora las misiones disponibles!'


class ObtenerMensajesView(generics.ListAPIView):
    """
    GET /api/assistant/obtener_mensajes/
    Historial del chat del usuario autenticado.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = MensajeChatSerializer

    def get_queryset(self):
        return MensajeChat.objects.filter(
            usuario=self.request.user
        ).order_by('fecha_envio')


class ObtenerRecomendacionesView(generics.ListAPIView):
    """
    GET /api/assistant/obtener_recomendaciones/
    Recomendaciones personalizadas del usuario.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = RecomendacionSerializer

    def get_queryset(self):
        return Recomendacion.objects.filter(
            usuario=self.request.user
        ).order_by('-fecha_creacion')[:10]