"""
Permisos personalizados del sistema.
Se usan con permission_classes en cada ViewSet/APIView.
"""

from rest_framework.permissions import BasePermission


class EsAdministrador(BasePermission):
    """
    Permite acceso solo a usuarios con rol ADMINISTRADOR.
    Uso: permission_classes = [IsAuthenticated, EsAdministrador]
    """
    message = 'Solo los administradores pueden realizar esta accion.'

    def has_permission(self, request, view):
        return (
            request.user and
            request.user.is_authenticated and
            request.user.rol == 'ADMINISTRADOR'
        )


class EsDocente(BasePermission):
    """
    Permite acceso solo a usuarios con rol DOCENTE.
    """
    message = 'Solo los docentes pueden realizar esta accion.'

    def has_permission(self, request, view):
        return (
            request.user and
            request.user.is_authenticated and
            request.user.rol == 'DOCENTE'
        )


class EsDocenteOAdmin(BasePermission):
    """
    Permite acceso a DOCENTE o ADMINISTRADOR.
    Uso: permission_classes = [IsAuthenticated, EsDocenteOAdmin]
    """
    message = 'Solo docentes o administradores pueden realizar esta accion.'

    def has_permission(self, request, view):
        return (
            request.user and
            request.user.is_authenticated and
            request.user.rol in ['DOCENTE', 'ADMINISTRADOR']
        )


class EsEstudiante(BasePermission):
    """
    Permite acceso solo a usuarios con rol ESTUDIANTE.
    """
    message = 'Solo los estudiantes pueden realizar esta accion.'

    def has_permission(self, request, view):
        return (
            request.user and
            request.user.is_authenticated and
            request.user.rol == 'ESTUDIANTE'
        )


class EsUsuarioAutenticado(BasePermission):
    """
    Permite acceso a cualquier usuario autenticado (cualquier rol).
    """
    message = 'Debes estar autenticado para realizar esta accion.'

    def has_permission(self, request, view):
        return (
            request.user and
            request.user.is_authenticated
        )


class EsDocenteOAdminOReadOnly(BasePermission):
    """
    Lectura: cualquier autenticado.
    Escritura: solo DOCENTE o ADMINISTRADOR.
    """
    message = 'No tienes permiso para modificar este recurso.'

    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        if request.method in ['GET', 'HEAD', 'OPTIONS']:
            return True
        return request.user.rol in ['DOCENTE', 'ADMINISTRADOR']