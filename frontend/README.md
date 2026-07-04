---
# Frontend - Supervisa Task Client - v0.1.0
---
Aplicación móvil **multiplataforma** (Web y Mobile) desarrollada para interactuar con el sistema de gestión de tareas. Este cliente está construido con un enfoque orientado al rendimiento, escalabilidad, tipado seguro y separación de responsabilidades mediante el patrón *MVVM* y *Widget-Driven Design*.

---
##  Stack Tecnológico
---
- **Framework Core:** Flutter (SDK 3.x)

- **Lenguaje:** Dart (con Sound Null Safety)

- **Gestión de Estado:** Provider (ChangeNotifier)

- **Cliente HTTP (Abstracción):** Dio

- **Variables de Entorno:** flutter_dotenv

- **Testing:** Flutter Test

- **Gestión de Paquetes:** `pubspec.yaml`

---
##  Estructura del Proyecto (MVVM)
---
El código fuente está centralizado en el directorio `lib/` y encapsulado en capas lógicas para garantizar un bajo acoplamiento y alta cohesión (prescindiendo de sobre-ingeniería innecesaria):

- `abstractions/`: Cliente HTTP (Dio) que actúa como puente directo con la API.

- `core/`: Configuraciones críticas del cliente (AppTheme, constantes globales).

- `models/`: Entidades de datos (DTOs) que mapean estrictamente el JSON del backend a Dart.

- `viewmodels/`: Orquestadores de la lógica de negocio y estado reactivo.

- `views/`: Pantallas principales construidas como `StatelessWidget` y `StatefulWidget` que consumen los ViewModels.

- `widgets/`: Componentes visuales reutilizables bajo la filosofía de diseño atómico.

- `test/`: Suite de pruebas unitarias replicando la estructura lógica de la aplicación.

---
##  Entorno de Desarrollo Local y Ejecución
---
La aplicación requiere que el backend (FastAPI) esté en ejecución. *Puede levantar el backend usando el comando docker-compose --up estando en la  raiz del monorepo*. Dependiendo de cómo decida correr el frontend, la configuración de red debe ajustarse mediante variables de entorno para que el cliente pueda alcanzar el servidor local.

### 1. Preparación del Entorno (.env)
Ubíquese en la carpeta `frontend/` e instale las dependencias:

```bash
flutter pub get
```
Cree un archivo .env en la raíz de la carpeta `frontend/` basándose en el archivo .env.example proporcionado:

```bash
cp .env.example .env
```
### 2. Métodos de Ejecución
Existen tres (3) maneras de compilar y probar esta aplicación, cada una requiere una configuración específica en el archivo .env de uso local:

### Opción A: Emulador de Android (Recomendado vía IntelliJ / Android Studio)
Los emuladores de Android corren en una máquina virtual aislada. Para que el emulador encuentre el `localhost` de la computadora anfitriona, se debe usar una IP de puente específica.

Si desea utilizar esta opción:

**1.** Abra su archivo .env y configure la variable así:

`API_BASE_URL=http://10.0.2.2:8000/api/v1`

**2.** Abra su IDE (IntelliJ o Android Studio).

**3.** Inicie un Android Virtual Device (AVD) desde el Device Manager.

**4.** Ejecute la aplicación utilizando el botón Play (Run) del IDE, o mediante consola:

```bash
flutter run
```

### Opción B: Dispositivo Físico (Android / iOS)
Para compilar la aplicación en su propio teléfono móvil, el dispositivo y la computadora deben estar conectados a la misma red Wi-Fi.

**1.** Averigüe la dirección IP local de su computadora (Ej. 192.168.1.25).

**2.** Abra su archivo .env y configure la variable apuntando a esa IP:

`API_BASE_URL=http://<SU_IP_LOCAL>:8000/api/v1`

**3.** Conecte su dispositivo por USB y asegúrese de tener habilitado el modo Depuración USB (Android) o el Modo Desarrollador (iOS).

**4.** Seleccione su dispositivo físico y compile:

```bash
flutter run -d <ID_DEL_DISPOSITIVO>
```

### Opción C: Navegador Web (Chrome / Edge)
Flutter permite compilar el proyecto como una Single Page Application (SPA) para la web.

**1.** Abra su archivo .env y configure la variable apuntando al localhost estándar:

`API_BASE_URL=http://127.0.0.1:8000/api/v1`

**2.** Ejecute el siguiente comando para levantar el servidor web de desarrollo:

```bash
flutter run -d chrome
```

(Nota: El backend FastAPI ya está configurado con las políticas CORS allow_origins=["*"] necesarias para soportar peticiones desde el navegador web).

---
## Pruebas Automatizadas
---
El proyecto incluye una suite de pruebas unitarias diseñadas para garantizar la integridad de la lógica de negocio y el manejo de estado (ViewModel) en total aislamiento de la capa de red.

**Estrategia de Testing (Inyección de Dependencias Nativa):**
Para asegurar una ejecución determinista y rápida sin saturar el proyecto con librerías externas de generación de *mocks* (como Mockito), se aprovechó la inyección de dependencias nativa por constructor del `TaskViewModel`. Se implementó un *mock* manual (`MockSupervisaApiAbstraction`) que simula el comportamiento y las latencias de la API, permitiendo validar las transiciones de estado del cliente de forma completamente aislada.

**Casos de Prueba Implementados:**

* `fetchTasks successfully updates state with tasks from API`: Verifica que una respuesta exitosa de la capa de red actualice correctamente la lista de tareas local y gestione las banderas de carga (`isLoading`).

* `fetchTasks handles network exceptions gracefully`: Evalúa la resiliencia del ViewModel, asegurando que las excepciones o caídas del servidor sean capturadas limpiamente y transformadas en mensajes de error reactivos para la UI (`errorMessage`) sin interrumpir la ejecución de la aplicación.

* `Insights getters calculate correct statistics based on internal list`: Valida la precisión matemática de las propiedades de estado derivado (total de tareas, desglose por prioridad y tasa de completadas) que alimentan el panel analítico del usuario.

Para ejecutar la suite completa, abra su terminal, asegúrese de estar ubicado en el directorio `frontend/` y ejecute el siguiente comando (no requiere emuladores ni backend activo):

```bash
flutter test
```
---
## Autoría
---

Desarrollado por David Alejandro De los Reyes Ostos, estudiante de décimo semestre de ingeniería de sistemas y candidato a "Ingeniero en Formación".

Entregable técnico para Supervisa S.A. (2026).