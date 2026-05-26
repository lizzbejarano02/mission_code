# 🎮 MISSION CODE :Plataforma Gamificada para Aprendizaje de Ingeniería de Software

## 📖 Descripción
Proyecto desarrollado con **Django + Django REST Framework + Flutter + MySQL Workbench** para crear una plataforma gamificada orientada al aprendizaje de Ingeniería de Software mediante niveles, misiones y retos interactivos.

La plataforma incluye:
- Sistema de autenticación
- Roles (Administrador, Docente y Estudiante)
- Gestión de niveles y misiones
- Preguntas y respuestas
- Sistema de progreso
- Ranking e insignias
- API REST
- Panel administrativo

---

# 🛠️ Tecnologías Utilizadas

## Backend
- Python 3.12+
- Django
- Django REST Framework
- MySQL
- XAMPP
- MySQL Workbench

## Frontend
- Flutter
- Dart

## Base de Datos
- MySQL Server
- MySQL Workbench

---

# 💻 Programas Necesarios

## 1. Python
Descargar desde:
https://www.python.org/downloads/

Verificar instalación:
```bash
python --version
```

---

## 2. Flutter SDK
Descargar desde:
https://flutter.dev/docs/get-started/install

Verificar instalación:
```bash
flutter doctor
```

---

## 3. Visual Studio Code
Descargar desde:
https://code.visualstudio.com/

### Extensiones recomendadas
- Python
- Flutter
- Dart
- Thunder Client

---

## 4. XAMPP
Descargar desde:
https://www.apachefriends.org/index.html

Servicios utilizados:
- Apache
- MySQL

---

## 5. MySQL Workbench
Descargar desde:
https://dev.mysql.com/downloads/workbench/

Utilizado para:
- Crear la base de datos
- Diseñar el modelo entidad relación
- Ejecutar consultas SQL
- Administrar tablas y relaciones

---

# 📦 Instalación del Backend

## Crear entorno virtual
```bash
python -m venv env
```

## Activar entorno virtual

### Windows
```bash
env\Scripts\activate
```

### Linux/Mac
```bash
source env/bin/activate
```

---

## Instalar dependencias
```bash
pip install django
pip install djangorestframework
pip install mysqlclient
pip install pillow
pip install django-cors-headers
pip install djangorestframework-simplejwt
```

---

# 📱 Instalación del Frontend

## Obtener dependencias
```bash
flutter pub get
```

## Dependencias recomendadas
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod:
  go_router:
  dio:
  shared_preferences:
  flutter_secure_storage:
```

---

# 🗄️ Configuración de la Base de Datos

## Crear Base de Datos en MySQL Workbench

```sql
CREATE DATABASE plataforma_gamificada;
```

---

# ⚙️ Configuración de Django

## Configurar `settings.py`

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'plataforma_gamificada',
        'USER': 'root',
        'PASSWORD': '',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

---

# 🔄 Migraciones

```bash
python manage.py makemigrations
python manage.py migrate
```

---

# 👤 Crear Superusuario

```bash
python manage.py createsuperuser
```

---

# 🚀 Ejecutar Backend

```bash
python manage.py runserver
```

Servidor:
```txt
http://127.0.0.1:8000/
```

---

# 📲 Ejecutar Frontend Flutter

```bash
flutter run
```

---

# 📁 Estructura del Proyecto

```plaintext
backend/
│
├── users/
├── game/
├── progress/
├── assistant/
│
frontend/
│
database/
```

---

# 👥 Roles del Sistema

## Administrador
- Gestión completa del sistema
- CRUD de usuarios
- Gestión de niveles y misiones
- Estadísticas y ranking

## Docente
- Consulta de estudiantes
- Seguimiento de progreso
- Gestión académica

## Estudiante
- Resolver misiones
- Subir de nivel
- Obtener insignias
- Ver progreso personal

---

# 🔗 API REST

## Usuarios
```plaintext
POST /registro_usuario/
POST /login_usuario/
GET /obtener_estudiantes/
```

## Niveles
```plaintext
GET /niveles/
POST /crear-nivel/
```

## Misiones
```plaintext
GET /misiones/
POST /crear-mision/
```

---

# 🧪 Herramientas Utilizadas

- Thunder Client
- MySQL Workbench
- Django Admin

---

# ✨ Características Principales

- Sistema de autenticación JWT
- Roles y permisos personalizados
- API REST con Django REST Framework
- Plataforma gamificada
- Sistema de niveles y misiones
- Seguimiento de progreso
- Interfaz Flutter
- Base de datos relacional en MySQL

---

# 📌 Autor

Proyecto académico desarrollado para la enseñanza gamificada de Ingeniería de Software.
