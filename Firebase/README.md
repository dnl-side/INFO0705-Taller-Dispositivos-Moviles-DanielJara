# Configuración Firebase - Unidad 2

Proyecto Firebase: `uniacc-orienta-danieljara`

Base Firestore: `(default)` · Standard · Native mode · `asia-northeast1` (Tokyo)

La Unidad 2 utiliza Cloud Firestore como fuente remota de recursos académicos y autenticación anónima para restringir las lecturas a sesiones válidas de la aplicación.

## Servicios requeridos

- Cloud Firestore
- Firebase Authentication con proveedor Anonymous
- Firebase Apple SDK 13.1.1 o superior: FirebaseCore, FirebaseAuth y FirebaseFirestore

## Aplicación iOS

El Bundle Identifier registrado en Firebase debe coincidir con el target de Xcode:

`com.Taller-de-Dispositivos-Mo-viles`

El archivo descargado desde Firebase debe llamarse exactamente:

`GoogleService-Info.plist`

y debe quedar dentro de:

`Taller de Dispositivos Móviles/Taller de Dispositivos Móviles/`

## Firestore

Colección:

`academic_resources`

Los identificadores de documento deben coincidir con los valores de `AcademicCategory`:

- evaluations
- enrollment
- certificates
- finance
- technicalSupport
- academicSupport
- library

Cada documento contiene:

- `title`: String
- `summary`: String
- `steps`: Array<String>
- `channel`: String

`Firebase/academic_resources.json` conserva los valores de referencia utilizados por el prototipo.

## Seguridad

Las reglas incluidas en `Firebase/firestore.rules` permiten lectura únicamente a sesiones autenticadas y bloquean todas las escrituras desde la aplicación cliente.

El prototipo usa autenticación anónima para obtener una sesión Firebase sin solicitar credenciales al estudiante. En una implementación institucional real, esta sesión puede reemplazarse por autenticación federada o SSO institucional sin modificar la capa de presentación.
