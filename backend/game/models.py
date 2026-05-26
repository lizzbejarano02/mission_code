"""
Modelos de la app game
Incluye: Nivel, Mision, Pregunta, Respuesta, RespuestaUsuario
"""

from django.db import models
from django.conf import settings


# ─────────────────────────────────────────────────
# NIVEL
# ─────────────────────────────────────────────────
class Nivel(models.Model):
    """Niveles del juego (ej: Fundamentos, Analisis, Disenio)"""

    nombre = models.CharField(max_length=200, verbose_name='Nombre')
    descripcion = models.TextField(verbose_name='Descripcion')
    orden = models.PositiveIntegerField(
        default=1,
        verbose_name='Orden de aparicion'
    )
    puntos_requeridos = models.PositiveIntegerField(
        default=0,
        verbose_name='Puntos requeridos para desbloquear'
    )
    imagen = models.ImageField(
        upload_to='niveles/',
        null=True,
        blank=True,
        verbose_name='Imagen del nivel'
    )
    activo = models.BooleanField(default=True, verbose_name='Activo')
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'niveles'
        verbose_name = 'Nivel'
        verbose_name_plural = 'Niveles'
        ordering = ['orden']

    def __str__(self):
        return f'Nivel {self.orden}: {self.nombre}'


# ─────────────────────────────────────────────────
# MISIÓN
# ─────────────────────────────────────────────────
class Mision(models.Model):
    """Misiones dentro de cada nivel"""

    class Dificultad(models.TextChoices):
        FACIL = 'FACIL', 'Facil'
        MEDIO = 'MEDIO', 'Medio'
        DIFICIL = 'DIFICIL', 'Dificil'

    nivel = models.ForeignKey(
        Nivel,
        on_delete=models.CASCADE,
        related_name='misiones',
        verbose_name='Nivel'
    )
    nombre = models.CharField(max_length=200, verbose_name='Nombre')
    descripcion = models.TextField(verbose_name='Descripción')
    dificultad = models.CharField(
        max_length=10,
        choices=Dificultad.choices,
        default=Dificultad.FACIL,
        verbose_name='Dificultad'
    )
    puntos_recompensa = models.PositiveIntegerField(
        default=10,
        verbose_name='Puntos de recompensa'
    )
    orden = models.PositiveIntegerField(default=1, verbose_name='Orden')
    activo = models.BooleanField(default=True, verbose_name='Activo')
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'misiones'
        verbose_name = 'Mision'
        verbose_name_plural = 'Misiones'
        ordering = ['nivel', 'orden']

    def __str__(self):
        return f'{self.nivel.nombre} → {self.nombre}'


# ─────────────────────────────────────────────────
# PREGUNTA
# ─────────────────────────────────────────────────
class Pregunta(models.Model):
    """Preguntas asociadas a una mision"""

    class TipoPregunta(models.TextChoices):
        SELECCION_MULTIPLE = 'SELECCION_MULTIPLE', 'Seleccion múltiple'
        VERDADERO_FALSO = 'VERDADERO_FALSO', 'Verdadero o Falso'
        COMPLETAR = 'COMPLETAR', 'Completar'

    mision = models.ForeignKey(
        Mision,
        on_delete=models.CASCADE,
        related_name='preguntas',
        verbose_name='Mision'
    )
    enunciado = models.TextField(verbose_name='Enunciado de la pregunta')
    tipo = models.CharField(
        max_length=30,
        choices=TipoPregunta.choices,
        default=TipoPregunta.SELECCION_MULTIPLE,
        verbose_name='Tipo de pregunta'
    )
    imagen = models.ImageField(
        upload_to='preguntas/',
        null=True,
        blank=True,
        verbose_name='Imagen de apoyo'
    )
    puntos = models.PositiveIntegerField(
        default=5,
        verbose_name='Puntos por respuesta correcta'
    )
    orden = models.PositiveIntegerField(default=1, verbose_name='Orden')
    activo = models.BooleanField(default=True, verbose_name='Activo')
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'preguntas'
        verbose_name = 'Pregunta'
        verbose_name_plural = 'Preguntas'
        ordering = ['mision', 'orden']

    def __str__(self):
        return f'[{self.mision.nombre}] {self.enunciado[:60]}...'


# ─────────────────────────────────────────────────
# RESPUESTA (opciones de cada pregunta)
# ─────────────────────────────────────────────────
class Respuesta(models.Model):
    """
    Opciones de respuesta para cada pregunta.
    Tabla SEPARADA de Pregunta (requerimiento explicito).
    """

    pregunta = models.ForeignKey(
        Pregunta,
        on_delete=models.CASCADE,
        related_name='respuestas',
        verbose_name='Pregunta'
    )
    texto = models.TextField(verbose_name='Texto de la respuesta')
    es_correcta = models.BooleanField(
        default=False,
        verbose_name='¿Es correcta?'
    )
    retroalimentacion = models.TextField(
        blank=True,
        default='',
        verbose_name='Retroalimentacion'
    )
    orden = models.PositiveIntegerField(default=1, verbose_name='Orden')

    class Meta:
        db_table = 'respuestas'
        verbose_name = 'Respuesta'
        verbose_name_plural = 'Respuestas'
        ordering = ['pregunta', 'orden']

    def __str__(self):
        correcta = '✓' if self.es_correcta else '✗'
        return f'{correcta} {self.texto[:50]}'


# ─────────────────────────────────────────────────
# RESPUESTA USUARIO (historial — solo registro)
# ─────────────────────────────────────────────────
class RespuestaUsuario(models.Model):
    """
    Historial de respuestas del usuario.
    NO tiene CRUD completo — solo se registra.
    """

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='respuestas_dadas',
        verbose_name='Usuario'
    )
    pregunta = models.ForeignKey(
        Pregunta,
        on_delete=models.CASCADE,
        related_name='respuestas_usuarios',
        verbose_name='Pregunta'
    )
    respuesta_elegida = models.ForeignKey(
        Respuesta,
        on_delete=models.CASCADE,
        related_name='elegida_por_usuarios',
        verbose_name='Respuesta elegida'
    )
    es_correcta = models.BooleanField(verbose_name='¿Fue correcta?')
    puntos_obtenidos = models.PositiveIntegerField(
        default=0,
        verbose_name='Puntos obtenidos'
    )
    fecha_respuesta = models.DateTimeField(
        auto_now_add=True,
        verbose_name='Fecha de respuesta'
    )

    class Meta:
        db_table = 'respuestas_usuario'
        verbose_name = 'Respuesta de usuario'
        verbose_name_plural = 'Respuestas de usuarios'
        ordering = ['-fecha_respuesta']
        # Un usuario puede responder la misma pregunta varias veces (reintentos)

    def __str__(self):
        estado = 'Correcta' if self.es_correcta else 'Incorrecta'
        return f'{self.usuario.nombre_completo} → {estado} ({self.puntos_obtenidos} pts)'