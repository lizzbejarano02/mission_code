"""
URLs de la app assistant
"""

from django.urls import path
from .views import (
    EnviarMensajeView,
    ObtenerMensajesView,
    ObtenerRecomendacionesView,
)

urlpatterns = [
    path('enviar_mensaje/', EnviarMensajeView.as_view(), name='enviar-mensaje'),
    path('obtener_mensajes/', ObtenerMensajesView.as_view(), name='obtener-mensajes'),
    path('obtener_recomendaciones/', ObtenerRecomendacionesView.as_view(), name='obtener-recomendaciones'),
]