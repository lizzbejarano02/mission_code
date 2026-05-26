"""
Views de la app progress
"""

from rest_framework import generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

from .models import ProgresoUsuario, Estadistica, Ranking
from .serializers import ProgresoUsuarioSerializer, EstadisticaSerializer, RankingSerializer
from users.permissions import EsAdministrador, EsDocenteOAdmin


class ProgresoView(generics.ListAPIView):
    """
    GET /api/progress/progreso/
    Estudiante: ve su propio progreso.
    Admin/Docente: puede filtrar por usuario con usuario_id=X
    """
    permission_classes = [IsAuthenticated]
    serializer_class = ProgresoUsuarioSerializer

    def get_queryset(self):
        user = self.request.user
        if user.rol in ['ADMINISTRADOR', 'DOCENTE']:
            usuario_id = self.request.query_params.get('usuario_id')
            if usuario_id:
                return ProgresoUsuario.objects.filter(
                    usuario_id=usuario_id
                ).select_related('mision', 'mision__nivel')
            return ProgresoUsuario.objects.all().select_related('mision', 'mision__nivel')
        # Estudiante solo ve el suyo
        return ProgresoUsuario.objects.filter(
            usuario=user
        ).select_related('mision', 'mision__nivel')


class EstadisticaView(APIView):
    """
    GET /api/progress/estadisticas/
    Estudiante: sus estadísticas.
    Admin: puede ver todas con usuario_id=X
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user

        if user.rol == 'ADMINISTRADOR':
            usuario_id = request.query_params.get('usuario_id')
            if usuario_id:
                try:
                    stats = Estadistica.objects.get(usuario_id=usuario_id)
                    return Response(EstadisticaSerializer(stats).data)
                except Estadistica.DoesNotExist:
                    return Response(
                        {'error': 'No hay estadisticas para este usuario.'},
                        status=status.HTTP_404_NOT_FOUND
                    )
            # Devuelve todas las estadísticas
            stats = Estadistica.objects.all().select_related('usuario')
            return Response(EstadisticaSerializer(stats, many=True).data)

        # Estudiante y Docente solo ven las suyas
        stats, _ = Estadistica.objects.get_or_create(usuario=user)
        return Response(EstadisticaSerializer(stats).data)


class RankingView(generics.ListAPIView):
    """
    GET /api/progress/ranking/
    Muestra el ranking de los 50 mejores estudiantes.
    """
    permission_classes = [IsAuthenticated]
    serializer_class = RankingSerializer

    def get_queryset(self):
        return Ranking.objects.filter(
            usuario__rol='ESTUDIANTE',
            usuario__is_active=True
        ).select_related('usuario', 'nivel_actual').order_by('posicion')[:50]