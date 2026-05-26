"""
Serializers de la app game
"""

from rest_framework import serializers
from .models import Nivel, Mision, Pregunta, Respuesta, RespuestaUsuario


# ─────────────────────────────────────────────────
# RESPUESTA (opción de pregunta)
# ─────────────────────────────────────────────────
class RespuestaSerializer(serializers.ModelSerializer):

    class Meta:
        model = Respuesta
        fields = ['id', 'texto', 'orden']
        # IMPORTANTE: NO exponemos es_correcta aquí
        # El frontend no debe saber cuál es la correcta antes de responder


class RespuestaAdminSerializer(serializers.ModelSerializer):
    """Solo para admin/docente — muestra la respuesta correcta"""

    class Meta:
        model = Respuesta
        fields = '__all__'


# ─────────────────────────────────────────────────
# PREGUNTA
# ─────────────────────────────────────────────────
class PreguntaSerializer(serializers.ModelSerializer):
    respuestas = RespuestaSerializer(many=True, read_only=True)

    class Meta:
        model = Pregunta
        fields = [
            'id',
            'mision',
            'enunciado',
            'tipo',
            'imagen',
            'puntos',
            'orden',
            'respuestas',
        ]


class PreguntaAdminSerializer(serializers.ModelSerializer):
    """Para admin/docente — incluye datos completos"""
    respuestas = RespuestaAdminSerializer(many=True, read_only=True)

    class Meta:
        model = Pregunta
        fields = '__all__'


# ─────────────────────────────────────────────────
# MISIÓN
# ─────────────────────────────────────────────────
class MisionSerializer(serializers.ModelSerializer):
    total_preguntas = serializers.SerializerMethodField()

    class Meta:
        model = Mision
        fields = [
            'id',
            'nivel',
            'nombre',
            'descripcion',
            'dificultad',
            'puntos_recompensa',
            'orden',
            'activo',
            'total_preguntas',
        ]

    def get_total_preguntas(self, obj):
        return obj.preguntas.filter(activo=True).count()


class MisionDetalleSerializer(serializers.ModelSerializer):
    preguntas = PreguntaSerializer(many=True, read_only=True)

    class Meta:
        model = Mision
        fields = '__all__'


# ─────────────────────────────────────────────────
# NIVEL
# ─────────────────────────────────────────────────
class NivelSerializer(serializers.ModelSerializer):
    total_misiones = serializers.SerializerMethodField()

    class Meta:
        model = Nivel
        fields = [
            'id',
            'nombre',
            'descripcion',
            'orden',
            'puntos_requeridos',
            'imagen',
            'activo',
            'total_misiones',
        ]

    def get_total_misiones(self, obj):
        return obj.misiones.filter(activo=True).count()


class NivelDetalleSerializer(serializers.ModelSerializer):
    misiones = MisionSerializer(many=True, read_only=True)

    class Meta:
        model = Nivel
        fields = '__all__'


# ─────────────────────────────────────────────────
# RESPONDER PREGUNTA
# ─────────────────────────────────────────────────
class ResponderPreguntaSerializer(serializers.Serializer):
    """Serializer para que el estudiante responda una pregunta"""

    pregunta_id = serializers.IntegerField()
    respuesta_id = serializers.IntegerField()

    def validate(self, attrs):
        try:
            pregunta = Pregunta.objects.get(
                id=attrs['pregunta_id'],
                activo=True
            )
        except Pregunta.DoesNotExist:
            raise serializers.ValidationError(
                {'pregunta_id': 'Pregunta no encontrada o inactiva.'}
            )

        try:
            respuesta = Respuesta.objects.get(
                id=attrs['respuesta_id'],
                pregunta=pregunta
            )
        except Respuesta.DoesNotExist:
            raise serializers.ValidationError(
                {'respuesta_id': 'Respuesta no pertenece a esta pregunta.'}
            )

        attrs['pregunta'] = pregunta
        attrs['respuesta'] = respuesta
        return attrs


# ─────────────────────────────────────────────────
# HISTORIAL DE RESPUESTAS
# ─────────────────────────────────────────────────
class RespuestaUsuarioSerializer(serializers.ModelSerializer):
    pregunta_enunciado = serializers.CharField(
        source='pregunta.enunciado',
        read_only=True
    )
    respuesta_texto = serializers.CharField(
        source='respuesta_elegida.texto',
        read_only=True
    )

    class Meta:
        model = RespuestaUsuario
        fields = [
            'id',
            'pregunta',
            'pregunta_enunciado',
            'respuesta_elegida',
            'respuesta_texto',
            'es_correcta',
            'puntos_obtenidos',
            'fecha_respuesta',
        ]
        read_only_fields = fields