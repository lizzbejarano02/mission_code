"""
Modelos de la app assistant
Incluye: MensajeChat, Recomendacion, Notificacion
"""

from django.db import models
from django.conf import settings


# ─────────────────────────────────────────────────
# MENSAJE DE CHAT
# ─────────────────────────────────────────────────
class MensajeChat(models.Model):
    """Mensajes del chat entre usuario y asistente IA"""

    class Remitente(models.TextChoices):
        USUARIO = 'USUARIO', 'Usuario'
        ASISTENTE = 'ASISTENTE', 'Asistente'

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='mensajes_chat',
        verbose_name='Usuario'
    )
    remitente = models.CharField(
        max_length=10,
        choices=Remitente.choices,
        default=Remitente.USUARIO,
        verbose_name='Remitente'
    )
    contenido = models.TextField(verbose_name='Contenido del mensaje')
    fecha_envio = models.DateTimeField(
        auto_now_add=True,
        verbose_name='Fecha de envio'
    )

    class Meta:
        db_table = 'mensajes_chat'
        verbose_name = 'Mensaje de chat'
        verbose_name_plural = 'Mensajes de chat'
        ordering = ['usuario', 'fecha_envio']

    def __str__(self):
        return f'[{self.remitente}] {self.usuario.nombre_completo}: {self.contenido[:50]}'


# ─────────────────────────────────────────────────
# RECOMENDACIÓN
# ─────────────────────────────────────────────────
class Recomendacion(models.Model):
    """Recomendaciones personalizadas para estudiantes"""

    class Tipo(models.TextChoices):
        MISION = 'MISION', 'Mision recomendada'
        REPASO = 'REPASO', 'Repaso de tema'
        RECURSO = 'RECURSO', 'Recurso externo'
        LOGRO = 'LOGRO', 'Logro próximo'

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='recomendaciones',
        verbose_name='Usuario'
    )
    tipo = models.CharField(
        max_length=10,
        choices=Tipo.choices,
        default=Tipo.MISION,
        verbose_name='Tipo de recomendación'
    )
    titulo = models.CharField(max_length=200, verbose_name='Titulo')
    descripcion = models.TextField(verbose_name='Descripcion')
    leida = models.BooleanField(default=False, verbose_name='¿Leida?')
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'recomendaciones'
        verbose_name = 'Recomendacion'
        verbose_name_plural = 'Recomendaciones'
        ordering = ['-fecha_creacion']

    def __str__(self):
        return f'{self.tipo}: {self.titulo} → {self.usuario.nombre_completo}'


# ─────────────────────────────────────────────────
# NOTIFICACIÓN
# ─────────────────────────────────────────────────
class Notificacion(models.Model):
    """Notificaciones del sistema para usuarios"""

    class Tipo(models.TextChoices):
        INSIGNIA = 'INSIGNIA', 'Nueva insignia'
        NIVEL = 'NIVEL', 'Nivel desbloqueado'
        MISION = 'MISION', 'Misión completada'
        RANKING = 'RANKING', 'Cambio en ranking'
        SISTEMA = 'SISTEMA', 'Notificacion del sistema'

    usuario = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='notificaciones',
        verbose_name='Usuario'
    )
    tipo = models.CharField(
        max_length=10,
        choices=Tipo.choices,
        default=Tipo.SISTEMA,
        verbose_name='Tipo'
    )
    titulo = models.CharField(max_length=200, verbose_name='Titulo')
    mensaje = models.TextField(verbose_name='Mensaje')
    leida = models.BooleanField(default=False, verbose_name='¿Leida?')
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notificaciones'
        verbose_name = 'Notificacion'
        verbose_name_plural = 'Notificaciones'
        ordering = ['-fecha_creacion']

    def __str__(self):
        estado = 'Leida' if self.leida else 'No leida'
        return f'[{estado}] {self.titulo} → {self.usuario.nombre_completo}'