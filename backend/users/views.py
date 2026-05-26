"""
Views de la app users
"""

from rest_framework import status, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken

from .models import Usuario
from .serializers import (
    CustomTokenObtainPairSerializer,
    RegistroSerializer,
    PerfilSerializer,
    EditarUsuarioSerializer,
    EstudianteListSerializer,
)
from .permissions import EsDocenteOAdmin, EsAdministrador


# ─────────────────────────────────────────────────
# LOGIN JWT
# ─────────────────────────────────────────────────
class LoginView(TokenObtainPairView):
    """
    POST /api/users/login/
    Body: { "email": "...", "password": "..." }
    Devuelve: access, refresh, datos del usuario
    """
    permission_classes = [AllowAny]
    serializer_class = CustomTokenObtainPairSerializer


# ─────────────────────────────────────────────────
# REGISTRO
# ─────────────────────────────────────────────────
class RegistroView(APIView):
    """
    POST /api/users/register/
    Crea un nuevo usuario (por defecto: ESTUDIANTE)
    """
    permission_classes = [AllowAny]
    parser_classes = [JSONParser, MultiPartParser, FormParser]

    def post(self, request):
        serializer = RegistroSerializer(data=request.data)
        if serializer.is_valid():
            usuario = serializer.save()
            # Generar tokens automáticamente tras el registro
            refresh = RefreshToken.for_user(usuario)
            return Response({
                'mensaje': 'Usuario registrado exitosamente.',
                'access': str(refresh.access_token),
                'refresh': str(refresh),
                'usuario': {
                    'id': usuario.id,
                    'email': usuario.email,
                    'nombre_completo': usuario.nombre_completo,
                    'rol': usuario.rol,
                }
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ─────────────────────────────────────────────────
# PERFIL
# ─────────────────────────────────────────────────
class PerfilView(APIView):
    """
    GET /api/users/perfil/
    Devuelve el perfil del usuario autenticado.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request):
        serializer = PerfilSerializer(request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)


# ─────────────────────────────────────────────────
# EDITAR USUARIO
# ─────────────────────────────────────────────────
class EditarUsuarioView(APIView):
    """
    PUT/PATCH /api/users/editar_usuario/
    Edita nombre, carrera, avatar, codigo.
    """
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser, JSONParser]

    def put(self, request):
        serializer = EditarUsuarioSerializer(
            request.user,
            data=request.data,
            partial=False
        )
        if serializer.is_valid():
            serializer.save()
            return Response({
                'mensaje': 'Perfil actualizado correctamente.',
                'data': serializer.data
            }, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request):
        serializer = EditarUsuarioSerializer(
            request.user,
            data=request.data,
            partial=True
        )
        if serializer.is_valid():
            serializer.save()
            return Response({
                'mensaje': 'Perfil actualizado correctamente.',
                'data': serializer.data
            }, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# ─────────────────────────────────────────────────
# OBTENER ESTUDIANTES (solo docentes y admin)
# ─────────────────────────────────────────────────
class ObtenerEstudiantesView(generics.ListAPIView):
    """
    GET /api/users/obtener_estudiantes/
    Solo accesible por DOCENTE o ADMINISTRADOR.
    """
    permission_classes = [IsAuthenticated, EsDocenteOAdmin]
    serializer_class = EstudianteListSerializer

    def get_queryset(self):
        return Usuario.objects.filter(
            rol='ESTUDIANTE',
            is_active=True
        ).order_by('nombre_completo')