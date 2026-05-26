"""
Views de la app game
"""

from rest_framework import status, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.utils import timezone

from .models import Nivel, Mision, Pregunta, Respuesta, RespuestaUsuario
from .serializers import (
    NivelSerializer,
    NivelDetalleSerializer,
    MisionSerializer,
    MisionDetalleSerializer,
    PreguntaSerializer,
    PreguntaAdminSerializer,
    RespuestaAdminSerializer,
    ResponderPreguntaSerializer,
    RespuestaUsuarioSerializer,
)
from users.permissions import EsDocenteOAdmin, EsEstudiante, EsUsuarioAutenticado


# ─────────────────────────────────────────────────
# NIVELES
# ─────────────────────────────────────────────────
class NivelListView(generics.ListCreateAPIView):
    """
    GET  /api/game/niveles/       → lista niveles
    POST /api/game/niveles/       → crea nivel (admin/docente)
    """
    queryset = Nivel.objects.filter(activo=True).order_by('orden')

    def get_serializer_class(self):
        return NivelSerializer

    def get_permissions(self):
        if self.request.method == 'POST':
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]


class NivelDetalleView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET    /api/game/niveles/<id>/  → detalle nivel con misiones
    PUT    /api/game/niveles/<id>/  → actualizar (admin/docente)
    DELETE /api/game/niveles/<id>/  → eliminar (admin/docente)
    """
    queryset = Nivel.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return NivelDetalleSerializer
        return NivelSerializer

    def get_permissions(self):
        if self.request.method in ['PUT', 'PATCH', 'DELETE']:
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]


# ─────────────────────────────────────────────────
# MISIONES
# ─────────────────────────────────────────────────
class MisionListView(generics.ListCreateAPIView):
    """
    GET  /api/game/misiones/
    POST /api/game/misiones/ (admin/docente)
    """

    def get_serializer_class(self):
        return MisionSerializer

    def get_permissions(self):
        if self.request.method == 'POST':
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]

    def get_queryset(self):
        queryset = Mision.objects.filter(activo=True)
        nivel_id = self.request.query_params.get('nivel_id')
        if nivel_id:
            queryset = queryset.filter(nivel_id=nivel_id)
        return queryset.order_by('nivel', 'orden')


class MisionDetalleView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET/PUT/DELETE /api/game/misiones/<id>/
    """
    queryset = Mision.objects.all()

    def get_serializer_class(self):
        if self.request.method == 'GET':
            return MisionDetalleSerializer
        return MisionSerializer

    def get_permissions(self):
        if self.request.method in ['PUT', 'PATCH', 'DELETE']:
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]


# ─────────────────────────────────────────────────
# PREGUNTAS
# ─────────────────────────────────────────────────
class PreguntaListView(generics.ListCreateAPIView):
    """
    GET  /api/game/preguntas/?mision_id=X
    POST /api/game/preguntas/ (admin/docente)
    """

    def get_serializer_class(self):
        if self.request.user.rol in ['ADMINISTRADOR', 'DOCENTE']:
            return PreguntaAdminSerializer
        return PreguntaSerializer

    def get_permissions(self):
        if self.request.method == 'POST':
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]

    def get_queryset(self):
        queryset = Pregunta.objects.filter(activo=True)
        mision_id = self.request.query_params.get('mision_id')
        if mision_id:
            queryset = queryset.filter(mision_id=mision_id)
        return queryset.order_by('mision', 'orden')


class PreguntaDetalleView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET/PUT/DELETE /api/game/preguntas/<id>/
    """
    queryset = Pregunta.objects.all()

    def get_serializer_class(self):
        return PreguntaAdminSerializer

    def get_permissions(self):
        if self.request.method in ['PUT', 'PATCH', 'DELETE']:
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]


# ─────────────────────────────────────────────────
# RESPUESTAS (opciones)
# ─────────────────────────────────────────────────
class RespuestaListView(generics.ListCreateAPIView):
    """
    GET  /api/game/respuestas/?pregunta_id=X
    POST /api/game/respuestas/ (admin/docente)
    """
    serializer_class = RespuestaAdminSerializer

    def get_permissions(self):
        if self.request.method == 'POST':
            return [IsAuthenticated(), EsDocenteOAdmin()]
        return [IsAuthenticated()]

    def get_queryset(self):
        queryset = Respuesta.objects.all()
        pregunta_id = self.request.query_params.get('pregunta_id')
        if pregunta_id:
            queryset = queryset.filter(pregunta_id=pregunta_id)
        return queryset


# ─────────────────────────────────────────────────
# RESPONDER PREGUNTA (solo estudiantes)
# ─────────────────────────────────────────────────
class ResponderPreguntaView(APIView):
    """
    POST /api/game/responder-pregunta/
    Body: { "pregunta_id": 1, "respuesta_id": 3 }
    Solo ESTUDIANTE puede responder.
    """
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = ResponderPreguntaSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        pregunta = serializer.validated_data['pregunta']
        respuesta = serializer.validated_data['respuesta']
        usuario = request.user

        es_correcta = respuesta.es_correcta
        puntos = pregunta.puntos if es_correcta else 0

        # Registrar la respuesta en el historial
        RespuestaUsuario.objects.create(
            usuario=usuario,
            pregunta=pregunta,
            respuesta_elegida=respuesta,
            es_correcta=es_correcta,
            puntos_obtenidos=puntos,
        )

        # Sumar puntos al usuario si es correcta
        if es_correcta:
            usuario.puntos_totales += puntos
            usuario.save(update_fields=['puntos_totales'])

            # Actualizar ranking y estadísticas
            _actualizar_estadisticas(usuario, es_correcta, puntos)

        return Response({
            'es_correcta': es_correcta,
            'puntos_obtenidos': puntos,
            'puntos_totales': usuario.puntos_totales,
            'retroalimentacion': respuesta.retroalimentacion if es_correcta else '',
            'mensaje': '¡Correcto! Ganaste puntos.' if es_correcta else 'Incorrecto. Inténtalo de nuevo.',
        }, status=status.HTTP_200_OK)


def _actualizar_estadisticas(usuario, es_correcta, puntos):
    """Funcion auxiliar para actualizar estadísticas tras responder"""
    from progress.models import Estadistica, Ranking

    # Actualizar estadísticas
    stats, _ = Estadistica.objects.get_or_create(usuario=usuario)
    stats.total_preguntas_respondidas += 1
    if es_correcta:
        stats.total_preguntas_correctas += 1
    else:
        stats.total_preguntas_incorrectas += 1
    stats.total_puntos = usuario.puntos_totales
    stats.actualizar_porcentaje()

    # Actualizar ranking
    ranking, _ = Ranking.objects.get_or_create(usuario=usuario)
    ranking.puntos = usuario.puntos_totales
    ranking.save()

    # Recalcular posiciones del ranking
    _recalcular_ranking()


def _recalcular_ranking():
    """Recalcula las posiciones del ranking"""
    from progress.models import Ranking
    rankings = Ranking.objects.order_by('-puntos')
    for i, r in enumerate(rankings, start=1):
        if r.posicion != i:
            r.posicion = i
            r.save(update_fields=['posicion'])


# ─────────────────────────────────────────────────
# HISTORIAL DE RESPUESTAS
# ─────────────────────────────────────────────────
class HistorialRespuestasView(generics.ListAPIView):
    """
    GET /api/game/historial-respuestas/
    Devuelve las respuestas del usuario autenticado.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = RespuestaUsuarioSerializer

    def get_queryset(self):
        return RespuestaUsuario.objects.filter(
            usuario=self.request.user
        ).select_related('pregunta', 'respuesta_elegida').order_by('-fecha_respuesta')