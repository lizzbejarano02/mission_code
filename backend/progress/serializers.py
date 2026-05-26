"""
Serializers de la app progress
"""

from rest_framework import serializers
from .models import ProgresoUsuario, Estadistica, Ranking
from users.serializers import EstudianteListSerializer


class ProgresoUsuarioSerializer(serializers.ModelSerializer):
    mision_nombre = serializers.CharField(
        source='mision.nombre',
        read_only=True
    )
    nivel_nombre = serializers.CharField(
        source='mision.nivel.nombre',
        read_only=True
    )

    class Meta:
        model = ProgresoUsuario
        fields = [
            'id',
            'usuario',
            'mision',
            'mision_nombre',
            'nivel_nombre',
            'estado',
            'porcentaje_completado',
            'puntos_ganados',
            'intentos',
            'fecha_inicio',
            'fecha_completado',
            'ultima_actividad',
        ]
        read_only_fields = ['usuario', 'puntos_ganados', 'ultima_actividad']


class EstadisticaSerializer(serializers.ModelSerializer):
    usuario_nombre = serializers.CharField(
        source='usuario.nombre_completo',
        read_only=True
    )

    class Meta:
        model = Estadistica
        fields = '__all__'
        read_only_fields = ['usuario']


class RankingSerializer(serializers.ModelSerializer):
    usuario_nombre = serializers.CharField(
        source='usuario.nombre_completo',
        read_only=True
    )
    carrera = serializers.CharField(
        source='usuario.carrera',
        read_only=True
    )
    avatar = serializers.ImageField(
        source='usuario.avatar',
        read_only=True
    )
    nivel_nombre = serializers.CharField(
        source='nivel_actual.nombre',
        read_only=True
    )

    class Meta:
        model = Ranking
        fields = [
            'id',
            'posicion',
            'usuario',
            'usuario_nombre',
            'carrera',
            'avatar',
            'puntos',
            'nivel_nombre',
            'fecha_actualizacion',
        ]
        read_only_fields = fields