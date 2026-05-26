"""
URLs de la app progress
"""

from django.urls import path
from .views import ProgresoView, EstadisticaView, RankingView

urlpatterns = [
    path('progreso/', ProgresoView.as_view(), name='progreso'),
    path('estadisticas/', EstadisticaView.as_view(), name='estadisticas'),
    path('ranking/', RankingView.as_view(), name='ranking'),
]