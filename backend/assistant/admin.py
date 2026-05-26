from django.contrib import admin
from .models import MensajeChat, Recomendacion, Notificacion


@admin.register(MensajeChat)
class MensajeChatAdmin(admin.ModelAdmin):
    list_display = ['usuario', 'remitente', 'contenido', 'fecha_envio']
    list_filter = ['remitente']
    search_fields = ['usuario__nombre_completo', 'contenido']
    readonly_fields = ['fecha_envio']


@admin.register(Recomendacion)
class RecomendacionAdmin(admin.ModelAdmin):
    list_display = ['usuario', 'tipo', 'titulo', 'leida', 'fecha_creacion']
    list_filter = ['tipo', 'leida']
    search_fields = ['usuario__nombre_completo', 'titulo']


@admin.register(Notificacion)
class NotificacionAdmin(admin.ModelAdmin):
    list_display = ['usuario', 'tipo', 'titulo', 'leida', 'fecha_creacion']
    list_filter = ['tipo', 'leida']
    search_fields = ['usuario__nombre_completo', 'titulo']