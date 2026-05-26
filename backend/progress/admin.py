from django.contrib import admin
from .models import ProgresoUsuario, Estadistica, Ranking


@admin.register(ProgresoUsuario)
class ProgresoUsuarioAdmin(admin.ModelAdmin):
    list_display = [
        'usuario', 'mision', 'estado',
        'porcentaje_completado', 'puntos_ganados', 'ultima_actividad'
    ]
    list_filter = ['estado', 'mision__nivel']
    search_fields = ['usuario__nombre_completo', 'mision__nombre']
    readonly_fields = ['ultima_actividad']


@admin.register(Estadistica)
class EstadisticaAdmin(admin.ModelAdmin):
    list_display = [
        'usuario', 'total_preguntas_respondidas',
        'total_preguntas_correctas', 'porcentaje_aciertos', 'total_puntos'
    ]
    search_fields = ['usuario__nombre_completo']
    readonly_fields = ['fecha_actualizacion']


@admin.register(Ranking)
class RankingAdmin(admin.ModelAdmin):
    list_display = ['posicion', 'usuario', 'puntos', 'nivel_actual', 'fecha_actualizacion']
    ordering = ['posicion']
    readonly_fields = ['fecha_actualizacion']