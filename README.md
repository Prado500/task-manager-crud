---
# Supervisa Task Manager - Prueba Técnica
---

Solución a la prueba técnica de admisión para el cargo de **Ingeniero en Formación** en Supervisa S.A. Un sistema CRUD completo para la gestión de tareas estructurado como un monorepo (Backend + Mobile App).

---
##  Guía de Inicio Rápido
---
Para evaluar la aplicación en su totalidad, el proyecto está dividido en dos flujos de ejecución: la infraestructura del servidor (Dockerizada para evaluación inmediata) y el entorno cliente (Emulador/Nativo).

### 1. Prerrequisitos del Sistema
- **Docker y Docker Compose** instalados y en ejecución.

- **Flutter SDK** (Versión 3.x o superior).

- **Android Studio / IntelliJ IDEA** con un *Android Virtual Device (AVD)* configurado (Recomendado).

- Puertos **`8000`** (API) y **`5432`** (PostgreSQL) disponibles.

### 2. Levantar el Backend y Base de Datos (Vía Docker)
El backend está completamente contenerizado para evitar configuraciones locales tediosas y garantizar la integridad de la base de datos PostgreSQL.

**1.** Abra una terminal en la **raíz absoluta** de este proyecto (estando a la misma altura de los directorios `backend/` y `frontend/`).

**2.** Ejecute el siguiente comando para construir e iniciar los contenedores en segundo plano:
   ```bash
   docker-compose up -d --build
   ```
*Verifique que el servicio esté corriendo accediendo a la documentación interactiva de la API en su navegador: Swagger UI: http://localhost:8000/docs*

### 3. Ejecutar el Cliente Flutter (Vía Emulador Android)

Con el backend corriendo en el puerto 8000, levante el cliente móvil.

⚠️ **Paso Crítico ⚠️ - Configuración de Red: El cliente requiere saber a qué entorno conectarse:**

**1.** Abra una nueva terminal y navegue a la carpeta del frontend (Asegúrese de estar en el directorio `frontend/`):

```bash
cd frontend
```
**2.** Instale las dependencias de Dart:

```bash
flutter pub get
```
**3.** Configure las variables de entorno: 

Copie el archivo de ejemplo para habilitar la conexión de red correcta. Para probar en un emulador de Android, el sistema utilizará por defecto la IP de puente 10.0.2.2 configurada en el archivo.

```bash
cp .env.example .env
```

*(Para Windows CMD: copy .env.example .env)*

**4.** Abra su emulador de Android (AVD) desde Android Studio o su IDE de preferencia.

**5.** Ejecute la aplicación:

```bash
flutter run
```
---
## Arquitectura y Documentación Detallada
---
El proyecto está estructurado como un monorepo. Para facilitar el despliegue de la infraestructura, el archivo docker-compose.yml se ubicó en la raíz.

Las decisiones arquitectónicas, principios de diseño, e instrucciones adicionales para la ejecución del proyecto en dispositivos físicos/web y/o sin uso de docker, asi como las guías para pruebas unitarias, han sido documentadas a profundidad en sus respectivos módulos. Puede hacer clic en los siguientes enlaces para acceder a la documentación:

📄 **[Documentación detallada del Backend (FastAPI + Clean Architecture)  disponible en: backend/README.md](backend/README.md)**   

📄 **[Documentación detallada del Frontend (Flutter + MVVM + WDD)  disponible en: frontend/README.md](frontend/README.md)** 

---
## Autoría
---
Desarrollado por David Alejandro De los Reyes Ostos, estudiante de décimo semestre de ingeniería de sistemas y candidato a "Ingeniero en Formación".

Entregable técnico para Supervisa S.A. (2026).


