"""
Modelos de la app users
Incluye usuario personalizado y perfil
"""

from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone


# ─────────────────────────────────────────────────
# MANAGER PERSONALIZADO
# ─────────────────────────────────────────────────
class UsuarioManager(BaseUserManager):
    """Manager para el modelo Usuario personalizado"""

    def create_user(self, email, username, password=None, **extra_fields):
        if not email:
            raise ValueError('El email es obligatorio')
        if not username:
            raise ValueError('El username es obligatorio')

        email = self.normalize_email(email)
        extra_fields.setdefault('is_active', True)
        extra_fields.setdefault('rol', 'ESTUDIANTE')

        user = self.model(
            email=email,
            username=username,
            **extra_fields
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, username, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('rol', 'ADMINISTRADOR')
        extra_fields.setdefault('is_active', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser debe tener is_staff=True')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser debe tener is_superuser=True')

        return self.create_user(email, username, password, **extra_fields)


# ─────────────────────────────────────────────────
# MODELO USUARIO PERSONALIZADO
# ─────────────────────────────────────────────────
class Usuario(AbstractBaseUser, PermissionsMixin):
    """
    Modelo de usuario personalizado.
    Reemplaza al User de Django.
    AUTH_USER_MODEL = 'users.Usuario'
    """

    class Rol(models.TextChoices):
        ADMINISTRADOR = 'ADMINISTRADOR', 'Administrador'
        DOCENTE = 'DOCENTE', 'Docente'
        ESTUDIANTE = 'ESTUDIANTE', 'Estudiante'

    # Campos de identificación
    email = models.EmailField(
        unique=True,
        verbose_name='Correo electronico'
    )
    username = models.CharField(
        max_length=150,
        unique=True,
        verbose_name='Nombre de usuario'
    )

    # Campos de perfil
    nombre_completo = models.CharField(
        max_length=255,
        verbose_name='Nombre completo'
    )
    codigo_universitario = models.CharField(
        max_length=50,
        unique=True,
        null=True,
        blank=True,
        verbose_name='Codigo universitario'
    )
    carrera = models.CharField(
        max_length=200,
        blank=True,
        default='',
        verbose_name='Carrera'
    )
    avatar = models.ImageField(
        upload_to='avatars/',
        null=True,
        blank=True,
        verbose_name='Avatar'
    )

    # Rol del usuario
    rol = models.CharField(
        max_length=20,
        choices=Rol.choices,
        default=Rol.ESTUDIANTE,
        verbose_name='Rol'
    )

    # Gamificación
    puntos_totales = models.PositiveIntegerField(
        default=0,
        verbose_name='Puntos totales'
    )

    # Campos de Django auth
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(default=timezone.now)
    last_login = models.DateTimeField(null=True, blank=True)

    objects = UsuarioManager()

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'nombre_completo']

    class Meta:
        db_table = 'usuarios'
        verbose_name = 'Usuario'
        verbose_name_plural = 'Usuarios'
        ordering = ['-date_joined']

    def __str__(self):
        return f'{self.nombre_completo} ({self.email}) - {self.rol}'

    def es_administrador(self):
        return self.rol == self.Rol.ADMINISTRADOR

    def es_docente(self):
        return self.rol == self.Rol.DOCENTE

    def es_estudiante(self):
        return self.rol == self.Rol.ESTUDIANTE


# ─────────────────────────────────────────────────
# MODELO INSIGNIA
# ─────────────────────────────────────────────────
class Insignia(models.Model):
    """Insignias que pueden ganar los estudiantes"""

    nombre = models.CharField(max_length=100, verbose_name='Nombre')
    descripcion = models.TextField(verbose_name='Descripcion')
    icono = models.ImageField(
        upload_to='insignias/',
        null=True,
        blank=True,
        verbose_name='Icono'
    )
    puntos_requeridos = models.PositiveIntegerField(
        default=0,
        verbose_name='Puntos requeridos'
    )
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'insignias'
        verbose_name = 'Insignia'
        verbose_name_plural = 'Insignias'
        ordering = ['puntos_requeridos']

    def __str__(self):
        return self.nombre


# ─────────────────────────────────────────────────
# RELACIÓN USUARIO - INSIGNIA
# ─────────────────────────────────────────────────
class UsuarioInsignia(models.Model):
    """Tabla pivote: que insignias tiene cada usuario"""

    usuario = models.ForeignKey(
        Usuario,
        on_delete=models.CASCADE,
        related_name='insignias_obtenidas',
        verbose_name='Usuario'
    )
    insignia = models.ForeignKey(
        Insignia,
        on_delete=models.CASCADE,
        related_name='usuarios_con_insignia',
        verbose_name='Insignia'
    )
    fecha_obtenida = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'usuario_insignias'
        verbose_name = 'Insignia de usuario'
        verbose_name_plural = 'Insignias de usuarios'
        unique_together = ('usuario', 'insignia')
        ordering = ['-fecha_obtenida']

    def __str__(self):
        return f'{self.usuario.nombre_completo} - {self.insignia.nombre}'