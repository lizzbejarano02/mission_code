from django.contrib import admin
from .models import Nivel, Mision, Pregunta, Respuesta, RespuestaUsuario


class MisionInline(admin.TabularInline):
    model = Mision
    extra = 0
    fields = ['nombre', 'dificultad', 'puntos_recompensa', 'orden', 'activo']


class RespuestaInline(admin.TabularInline):
    model = Respuesta
    extra = 4
    fields = ['texto', 'es_correcta', 'orden']


@admin.register(Nivel)
class NivelAdmin(admin.ModelAdmin):
    list_display = ['nombre', 'orden', 'puntos_requeridos', 'activo']
    list_filter = ['activo']
    search_fields = ['nombre']
    ordering = ['orden']
    inlines = [MisionInline]


@admin.register(Mision)
class MisionAdmin(admin.ModelAdmin):
    list_display = ['nombre', 'nivel', 'dificultad', 'puntos_recompensa', 'orden', 'activo']
    list_filter = ['nivel', 'dificultad', 'activo']
    search_fields = ['nombre', 'nivel__nombre']
    ordering = ['nivel', 'orden']


@admin.register(Pregunta)
class PreguntaAdmin(admin.ModelAdmin):
    list_display = ['enunciado', 'mision', 'tipo', 'puntos', 'activo']
    list_filter = ['tipo', 'activo', 'mision__nivel']
    search_fields = ['enunciado', 'mision__nombre']
    inlines = [RespuestaInline]


@admin.register(Respuesta)
class RespuestaAdmin(admin.ModelAdmin):
    list_display = ['texto', 'pregunta', 'es_correcta', 'orden']
    list_filter = ['es_correcta']
    search_fields = ['texto', 'pregunta__enunciado']


@admin.register(RespuestaUsuario)
class RespuestaUsuarioAdmin(admin.ModelAdmin):
    list_display = [
        'usuario', 'pregunta', 'es_correcta',
        'puntos_obtenidos', 'fecha_respuesta'
    ]
    list_filter = ['es_correcta']
    search_fields = ['usuario__nombre_completo']
    readonly_fields = [
        'usuario', 'pregunta', 'respuesta_elegida',
        'es_correcta', 'puntos_obtenidos', 'fecha_respuesta'
    ]