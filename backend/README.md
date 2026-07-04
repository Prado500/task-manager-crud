---
# Backend - Supervisa Task API - v0.1.0
---
API RESTful **asíncrona** desarrollada para soportar el sistema de gestión de tareas. Este microservicio está construido con un enfoque estricto en rendimiento, tipado estático y separación de responsabilidades mediante *Clean Architecture*.

---
##  Stack Tecnológico
---
- **Framework Core:** FastAPI (Asíncrono)
- **Servidor ASGI:** Uvicorn
- **ORM & Base de Datos:** SQLAlchemy 2.0.42 (AsyncSession) + PostgreSQL (driver `asyncpg`)
- **Validación de Datos (DTOs):** Pydantic + Pydantic-Settings
- **Testing:** Pytest + HTTPX + Pytest-Asyncio
- **Gestión de Paquetes:** `pyproject.toml` (PEP 621)

---

##  Estructura del Proyecto (Clean Architecture)
---
El código fuente está centralizado en el directorio `app/` y encapsulado en capas lógicas para garantizar la modularidad y escalabilidad del sistema:

- `api/v1/`: Controladores (Routers) que exponen los endpoints HTTP y manejan las peticiones del cliente.
- `core/`: Configuraciones críticas del sistema (Variables de entorno, CORS).
- `database/`: Configuración del motor asíncrono y gestión del pool de conexiones.
- `models/`: Entidades de dominio mapeadas a tablas SQL mediante SQLAlchemy.
- `schemas/`: Contratos de datos (DTOs) en Pydantic para validación estricta de entradas y salidas.
- `repositories/`: Capa de persistencia (Abstracción de consultas a la base de datos).
- `services/`: Capa que contiene la lógica de negocio y reglas de validación.
- `tests/`: Suite de pruebas unitarias y de integración.

---

##  Entorno de Desarrollo Local y Ejecución (Recomendado: Docker)
---

La forma más segura, rápida y recomendada de evaluar este proyecto es utilizando contenedores. Esto garantiza que tanto la base de datos PostgreSQL como la API se levanten con la configuración exacta requerida.

Ubíquese en la **raíz absoluta del proyecto** (donde se encuentran el archivo `docker-compose.yml`, a la misma altura del directorio `backend/` y el directorio `frontend/`) y ejecute:

```bash
docker-compose up --build -d
```
*Una vez los contenedores estén en ejecución, la documentación interactiva de la API estará disponible en: http://localhost:8000/docs*

---
## Entorno de Desarrollo Local (Sin Docker)
---
Si desea ejecutar, depurar o modificar la API directamente en su máquina (por fuera de Docker), siga estos pasos.

⚠️ **Prerrequisito Crítico:**⚠️ El backend requiere una instancia de PostgreSQL activa para iniciar. Asegúrese de tener una base de datos corriendo localmente antes de ejecutar el servidor, de lo contrario la aplicación fallará al intentar construir las tablas.


### 1. Preparación del Entorno Virtual
Ubíquese en la carpeta `backend/` y cree un entorno virtual aislado:
```bash
python -m venv .venv
```
Active el entorno virtual (Comando para Windows):

```bash
.\.venv\Scripts\activate
```

### 2. Instalación de Dependencias
Instale el proyecto en "modo editable" incluyendo las herramientas de desarrollo y testing:

```bash
pip install -e .[dev]
```

### 3. Variables de Entorno

Cree un archivo .env en la raíz de la carpeta backend/ basándose en el archivo de ejemplo proporcionado:

**Comando para Símbolo del Sistema (Windows CMD):**

```bash
copy .env.example .env
```

**Comando para terminales Bash (Linux/Mac/GitBash):**

```bash
cp .env.example .env
```
*(Asegúrese de que las credenciales apunten a una instancia de PostgreSQL accesible).*


### 4. Ejecución del Servidor
Levante el servidor en modo desarrollo (con recarga automática ante cambios):

```bash
uvicorn app.main:app --reload
```

*La documentación interactiva estará disponible inmediatamente en: http://localhost:8000/docs*

---
## Pruebas Automatizadas
---
El proyecto incluye una suite de pruebas configurada para ejecutarse en un event loop asíncrono. Con el entorno virtual activado, ejecute:

```bash
pytest
```

---
##  Autoría 
---

Desarrollado por **David Alejandro De los Reyes Ostos**, estudiante de décimo semestre de ingeniería de sistemas y candidato a "Ingeniero en Formación".

Entregable técnico para Supervisa S.A. (2026).
