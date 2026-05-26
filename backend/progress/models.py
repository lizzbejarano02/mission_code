"""
Modelos de la app progress
Incluye: ProgresoUsuario, Estadistica, Ranking
"""

from django.db import models
from django.conf import settings
from game.models import Nivel, Mision


# ─────────────────────────────────────────────────
# PROGRESO USUARIO
# ─────────────────────────────────────────────────
class ProgresoUsuario(models.Model):
    """Progreso de cada usuario en cada mision"""

    class Estado(models.TextChoices):
        NO_INICIADO = 'NO_INICIADO', 'No iniciado'
        EN_PROGRESO = 'EN_PROGRESO', 'En progreso'
        COMPLETADO = 'COMPLETADO', 'Completado'

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='progresos',
        verbose_name='Usuario'
    )
    mision = models.ForeignKey(
        Mision,
        on_delete=models.CASCADE,
        related_name='progresos_usuarios',
        verbose_name='Mision'
    )
    estado = models.CharField(
        max_length=20,
        choices=Estado.choices,
        default=Estado.NO_INICIADO,
        verbose_name='Estado'
    )
    porcentaje_completado = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0.00,
        verbose_name='Porcentaje completado'
    )
    puntos_ganados = models.PositiveIntegerField(
        default=0,
        verbose_name='Puntos ganados en esta mision'
    )
    intentos = models.PositiveIntegerField(
        default=0,
        verbose_name='Numero de intentos'
    )
    fecha_inicio = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Fecha de inicio'
    )
    fecha_completado = models.DateTimeField(
        null=True,
        blank=True,
        verbose_name='Fecha de completado'
    )
    ultima_actividad = models.DateTimeField(
        auto_now=True,
        verbose_name='Última actividad'
    )

    class Meta:
        db_table = 'progreso_usuario'
        verbose_name = 'Progreso de usuario'
        verbose_name_plural = 'Progresos de usuarios'
        unique_together = ('usuario', 'mision')
        ordering = ['-ultima_actividad']

    def __str__(self):
        return f'{self.usuario.nombre_completo} → {self.mision.nombre}: {self.estado}'


# ─────────────────────────────────────────────────
# ESTADÍSTICA
# ─────────────────────────────────────────────────
class Estadistica(models.Model):
    """Estadisticas globales y por usuario"""

    usuario = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='estadistica',
        verbose_name='Usuario'
    )
    total_preguntas_respondidas = models.PositiveIntegerField(default=0)
    total_preguntas_correctas = models.PositiveIntegerField(default=0)
    total_preguntas_incorrectas = models.PositiveIntegerField(default=0)
    total_misiones_completadas = models.PositiveIntegerField(default=0)
    total_niveles_completados = models.PositiveIntegerField(default=0)
    total_puntos = models.PositiveIntegerField(default=0)
    porcentaje_aciertos = models.DecimalField(
        max_digits=5,
        decimal_places=2,
        default=0.00
    )
    tiempo_total_minutos = models.PositiveIntegerField(
        default=0,
        verbose_name='Tiempo total en minutos'
    )
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'estadisticas'
        verbose_name = 'Estadistica'
        verbose_name_plural = 'Estadisticas'

    def __str__(self):
        return f'Estadisticas de {self.usuario.nombre_completo}'

    def actualizar_porcentaje(self):
        """Recalcula el porcentaje de aciertos"""
        if self.total_preguntas_respondidas > 0:
            self.porcentaje_aciertos = (
                self.total_preguntas_correctas / self.total_preguntas_respondidas
            ) * 100
        else:
            self.porcentaje_aciertos = 0
        self.save()


# ─────────────────────────────────────────────────
# RANKING
# ─────────────────────────────────────────────────
class Ranking(models.Model):
    """Ranking de estudiantes por puntos"""

    usuario = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='ranking',
        verbose_name='Usuario'
    )
    posicion = models.PositiveIntegerField(
        default=0,
        verbose_name='Posicion en el ranking'
    )
    puntos = models.PositiveIntegerField(
        default=0,
        verbose_name='Puntos totales'
    )
    nivel_actual = models.ForeignKey(
        Nivel,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='usuarios_en_nivel',
        verbose_name='Nivel actual'
    )
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'ranking'
        verbose_name = 'Ranking'
        verbose_name_plural = 'Rankings'
        ordering = ['posicion']

    def __str__(self):
        return f'#{self.posicion} - {self.usuario.nombre_completo} ({self.puntos} pts)'