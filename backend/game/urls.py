"""
URLs de la app game
"""

from django.urls import path
from .views import (
    NivelListView,
    NivelDetalleView,
    MisionListView,
    MisionDetalleView,
    PreguntaListView,
    PreguntaDetalleView,
    RespuestaListView,
    ResponderPreguntaView,
    HistorialRespuestasView,
)

urlpatterns = [
    # Niveles
    path('niveles/', NivelListView.as_view(), name='nivel-list'),
    path('niveles/<int:pk>/', NivelDetalleView.as_view(), name='nivel-detalle'),

    # Misiones
    path('misiones/', MisionListView.as_view(), name='mision-list'),
    path('misiones/<int:pk>/', MisionDetalleView.as_view(), name='mision-detalle'),

    # Preguntas
    path('preguntas/', PreguntaListView.as_view(), name='pregunta-list'),
    path('preguntas/<int:pk>/', PreguntaDetalleView.as_view(), name='pregunta-detalle'),

    # Respuestas (opciones)
    path('respuestas/', RespuestaListView.as_view(), name='respuesta-list'),

    # Juego
    path('responder-pregunta/', ResponderPreguntaView.as_view(), name='responder-pregunta'),
    path('historial-respuestas/', HistorialRespuestasView.as_view(), name='historial-respuestas'),
]