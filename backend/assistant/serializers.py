"""
Serializers de la app assistant
"""

from rest_framework import serializers
from .models import MensajeChat, Recomendacion, Notificacion


class MensajeChatSerializer(serializers.ModelSerializer):

    class Meta:
        model = MensajeChat
        fields = [
            'id',
            'usuario',
            'remitente',
            'contenido',
            'fecha_envio',
        ]
        read_only_fields = ['usuario', 'remitente', 'fecha_envio']


class EnviarMensajeSerializer(serializers.Serializer):
    """Para que el usuario envíe un mensaje al asistente"""
    contenido = serializers.CharField(
        min_length=1,
        max_length=2000
    )


class RecomendacionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Recomendacion
        fields = '__all__'
        read_only_fields = ['usuario', 'fecha_creacion']


class NotificacionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Notificacion
        fields = '__all__'
        read_only_fields = ['usuario', 'fecha_creacion']