"""
Serializers de la app users
"""

from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth.password_validation import validate_password
from .models import Usuario, Insignia, UsuarioInsignia


# ─────────────────────────────────────────────────
# JWT TOKEN PERSONALIZADO
# ─────────────────────────────────────────────────
class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """
    Agrega datos del usuario al token JWT.
    Devuelve: access, refresh + info del usuario.
    """

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        # Datos adicionales en el token
        token['nombre_completo'] = user.nombre_completo
        token['rol'] = user.rol
        token['email'] = user.email
        return token

    def validate(self, attrs):
        data = super().validate(attrs)
        # Agregar datos del usuario en la respuesta
        data['usuario'] = {
            'id': self.user.id,
            'email': self.user.email,
            'username': self.user.username,
            'nombre_completo': self.user.nombre_completo,
            'rol': self.user.rol,
            'puntos_totales': self.user.puntos_totales,
            'codigo_universitario': self.user.codigo_universitario,
            'carrera': self.user.carrera,
        }
        return data


# ─────────────────────────────────────────────────
# REGISTRO DE USUARIO
# ─────────────────────────────────────────────────
class RegistroSerializer(serializers.ModelSerializer):
    """Serializer para registrar nuevos usuarios"""

    password = serializers.CharField(
        write_only=True,
        required=True,
        validators=[validate_password],
        style={'input_type': 'password'}
    )
    password2 = serializers.CharField(
        write_only=True,
        required=True,
        style={'input_type': 'password'},
        label='Confirmar contrasenia'
    )

    class Meta:
        model = Usuario
        fields = [
            'email',
            'username',
            'nombre_completo',
            'codigo_universitario',
            'carrera',
            'rol',
            'password',
            'password2',
        ]
        extra_kwargs = {
            'rol': {'required': False},
            'carrera': {'required': False},
            'codigo_universitario': {'required': False},
        }

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError(
                {'password': 'Las contrasenias no coinciden.'}
            )
        return attrs

    def create(self, validated_data):
        validated_data.pop('password2')
        password = validated_data.pop('password')

        usuario = Usuario(**validated_data)
        usuario.set_password(password)
        usuario.save()
        return usuario


# ─────────────────────────────────────────────────
# PERFIL DE USUARIO
# ─────────────────────────────────────────────────
class PerfilSerializer(serializers.ModelSerializer):
    """Serializer para ver y editar el perfil"""

    class Meta:
        model = Usuario
        fields = [
            'id',
            'email',
            'username',
            'nombre_completo',
            'codigo_universitario',
            'carrera',
            'avatar',
            'rol',
            'puntos_totales',
            'date_joined',
            'last_login',
        ]
        read_only_fields = [
            'id',
            'email',
            'rol',
            'puntos_totales',
            'date_joined',
            'last_login',
        ]


# ─────────────────────────────────────────────────
# EDITAR USUARIO
# ─────────────────────────────────────────────────
class EditarUsuarioSerializer(serializers.ModelSerializer):
    """Serializer para editar datos del usuario"""

    class Meta:
        model = Usuario
        fields = [
            'nombre_completo',
            'codigo_universitario',
            'carrera',
            'avatar',
        ]


# ─────────────────────────────────────────────────
# LISTA DE ESTUDIANTES (solo para docentes/admin)
# ─────────────────────────────────────────────────
class EstudianteListSerializer(serializers.ModelSerializer):
    """Vista resumida de estudiantes para docentes"""

    class Meta:
        model = Usuario
        fields = [
            'id',
            'nombre_completo',
            'email',
            'codigo_universitario',
            'carrera',
            'puntos_totales',
            'is_active',
        ]
        read_only_fields = fields


# ─────────────────────────────────────────────────
# INSIGNIA
# ─────────────────────────────────────────────────
class InsigniaSerializer(serializers.ModelSerializer):

    class Meta:
        model = Insignia
        fields = '__all__'


class UsuarioInsigniaSerializer(serializers.ModelSerializer):
    insignia = InsigniaSerializer(read_only=True)

    class Meta:
        model = UsuarioInsignia
        fields = ['id', 'insignia', 'fecha_obtenida']