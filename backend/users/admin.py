from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import Usuario, Insignia, UsuarioInsignia


@admin.register(Usuario)
class UsuarioAdmin(UserAdmin):
    list_display = [
        'email', 'nombre_completo', 'username',
        'rol', 'puntos_totales', 'is_active', 'date_joined'
    ]
    list_filter = ['rol', 'is_active', 'is_staff', 'carrera']
    search_fields = ['email', 'nombre_completo', 'username', 'codigo_universitario']
    ordering = ['-date_joined']

    fieldsets = (
        ('Credenciales', {'fields': ('email', 'username', 'password')}),
        ('Información personal', {
            'fields': ('nombre_completo', 'codigo_universitario', 'carrera', 'avatar')
        }),
        ('Rol y gamificación', {'fields': ('rol', 'puntos_totales')}),
        ('Permisos', {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')
        }),
        ('Fechas', {'fields': ('date_joined', 'last_login')}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': (
                'email', 'username', 'nombre_completo',
                'rol', 'password1', 'password2'
            ),
        }),
    )

    readonly_fields = ['date_joined', 'last_login']


@admin.register(Insignia)
class InsigniaAdmin(admin.ModelAdmin):
    list_display = ['nombre', 'puntos_requeridos', 'fecha_creacion']
    search_fields = ['nombre']
    ordering = ['puntos_requeridos']


@admin.register(UsuarioInsignia)
class UsuarioInsigniaAdmin(admin.ModelAdmin):
    list_display = ['usuario', 'insignia', 'fecha_obtenida']
    list_filter = ['insignia']
    search_fields = ['usuario__nombre_completo', 'insignia__nombre']