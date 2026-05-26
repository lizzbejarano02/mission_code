"""
URLs de la app users
"""

from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    LoginView,
    RegistroView,
    PerfilView,
    EditarUsuarioView,
    ObtenerEstudiantesView,
)

urlpatterns = [
    path('register/', RegistroView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('perfil/', PerfilView.as_view(), name='perfil'),
    path('editar_usuario/', EditarUsuarioView.as_view(), name='editar_usuario'),
    path('obtener_estudiantes/', ObtenerEstudiantesView.as_view(), name='obtener_estudiantes'),
    path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]