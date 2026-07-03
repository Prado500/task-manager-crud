\---

\# Frontend - Supervisa Task Client - v0.1.0

\---

Aplicación móvil \*\*multiplataforma\*\* (Web y Mobile) desarrollada para interactuar con el sistema de gestión de tareas. Este cliente está construido con un enfoque orientado al rendimiento, escalabilidad, tipado seguro y separación de responsabilidades mediante el patrón \*MVVM\* y \*Widget-Driven Design\*.



\---

\##  Stack Tecnológico

\---

\- \*\*Framework Core:\*\* Flutter (SDK 3.x)

\- \*\*Lenguaje:\*\* Dart (con Sound Null Safety)

\- \*\*Gestión de Estado:\*\* Provider (ChangeNotifier)

\- \*\*Cliente HTTP (Abstracción):\*\* Dio

\- \*\*Testing:\*\* Flutter Test

\- \*\*Gestión de Paquetes:\*\* `pubspec.yaml`



\---



\##  Estructura del Proyecto (MVVM)

\---

El código fuente está centralizado en el directorio `lib/` y encapsulado en capas lógicas para garantizar un bajo acoplamiento y alta cohesión (prescindiendo de sobre-ingeniería innecesaria):



\- `abstractions/`: Cliente HTTP (Dio) que actúa como puente directo con la API.

\- `core/`: Configuraciones críticas del cliente (AppTheme, constantes globales).

\- `models/`: Entidades de datos (DTOs) que mapean estrictamente el JSON del backend a Dart.

\- `viewmodels/`: Orquestadores de la lógica de negocio y estado reactivo.

\- `views/`: Pantallas principales construidas como `StatelessWidget` que consumen los ViewModels.

\- `widgets/`: Componentes visuales reutilizables bajo la filosofía de diseño atómico.

\- `test/`: Suite de pruebas unitarias replicando la estructura lógica de la aplicación.



\---



\##  Entorno de Desarrollo Local

\---

Si desea ejecutar, depurar o modificar la aplicación directamente en su máquina (con el backend ya en ejecución), siga estos pasos:



\### 1. Preparación del Entorno

Asegúrese de tener un emulador abierto (Android/iOS) o un dispositivo físico conectado con las opciones de desarrollador habilitadas.



\### 2. Instalación de Dependencias

Ubíquese en la carpeta `frontend/` y descargue los paquetes de Dart configurados en el proyecto:



```bash

flutter pub get

```

\### 3. Ejecución del Cliente

Levante la aplicación en modo desarrollo (con Hot-Reload habilitado):



```bash

flutter run

```



\*(Nota: El cliente está configurado para apuntar por defecto a la API local).\*



\---

&#x20;## Pruebas Automatizadas

\---



El proyecto incluye una suite de pruebas para verificar la lógica de negocio y la serialización bidireccional JSON. Ubíquese en la raíz de frontend/ y ejecute:



```bash

flutter test

```

\---

\##  Autoría 

\---



Desarrollado por \*\*David Alejandro De los Reyes Ostos\*\*, estudiante de décimo semestre de ingeniería de sistemas y candidato a "Ingeniero en Formación".



Entregable técnico para Supervisa S.A. (2026).



