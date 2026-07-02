
# Supervisa Task Manager - Prueba Técnica

Solución a la prueba técnica de admisión para el cargo de Ingeniero en Formación en Supervisa S.A.S. Un sistema CRUD completo para la gestión de tareas estructurado como un monorepo (Backend + Mobile App).


---
##  Guía de Inicio Rápido
---
Para su probar la aplicación en su totalidad, el proyecto está dividido en dos flujos de ejecución: el entorno de servidor (Dockerizado) y el entorno cliente (Nativo/Emulador).

### 1. Prerrequisitos del Sistema

- **Docker y Docker Compose** 
- **Flutter SDK Versión 3.x o superior**
- **Android Studio** (con un emulador Android configurado) o Xcode (para simulador iOS).
- Puertos **`8000`** (API) y **`5432`** (PostgreSQL) disponibles.



### 2. Levantar el Backend y Base de Datos 
El backend está completamente contenerizado para evitar configuraciones locales.

1. Abra una terminal en la raíz del proyecto.
2. Ejecute el siguiente comando:
   ```bash
   docker-compose up -d --build
   ```
Verifique que el servicio esté corriendo accediendo a la documentación de la API en su navegador:

Swagger UI: http://localhost:8000/docs

### 3. Ejecutar el Cliente 
Con el backend corriendo en el puerto 8000, ahora puede levantar el cliente Flutter.

Asegúrese de tener su emulador abierto (Android/iOS) o un dispositivo físico conectado.

Abra una nueva pestaña en su terminal y navegue a la carpeta del frontend:

```bash
cd frontend

```
Instale las dependencias de Dart:

```bash
flutter pub get
```
Ejecute la aplicación:

```bash
flutter run
```

Nota para el evaluador: La aplicación está configurada por defecto para apuntar a http://localhost:8000 (o http://10.0.2.2:8000 en emuladores Android) para comunicarse con la API local.

---
##  Arquitectura y Documentación Detallada
---

El proyecto está estructurado como un monorepo que contiene tanto la API backend como el cliente móvil. Para su facilidad se colocó el docker-compose.yml a la altura de la carpeta raiz del proyecto (por fuera de la carpeta **backend**), para pueda levantarlo apenas accede al directorio principal. Para el  **backend** se utilizó el stack de **FastAPI** bajo *Clean Architecture* estrícta y para el cliente se desarrolló un proyecto **Flutter**  compilable a multiplataforma (Web y Mobile) bajo *MVVM* y *Widget-Driven Desing*.

Para informacón detallada sobre las decisiones arquitectónicas, patrones de diseño y cómo ejecutar los entornos de desarrollo locales (sin Docker) o las pruebas unitarias, por favor consulte la documentación específica de cada módulo:

📄 Documentación del Backend disponible en: **backend/README.md** 

📄 Documentación del Frontend disponible en: **frontend/README.md**

---
##  Autoría 
---

Desarrollado por **David Alejandro De los Reyes Ostos**, estudiante de décimo semestre de ingeniería de sistemas y candidato a "Ingeniero en Formación".

Entregable técnico para Supervisa S.A. (2026).
