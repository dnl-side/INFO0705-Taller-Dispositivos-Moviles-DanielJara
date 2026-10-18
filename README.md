# Taller de Dispositivos Móviles

Proyecto desarrollado para la asignatura INFO0705 Taller de Dispositivos Móviles.

## Plataforma

iOS

## Tecnologías

- Swift
- SwiftUI
- Xcode

## Organización

La aplicación funciona como contenedor de las actividades del ramo. Al iniciar se muestra un selector que permite ingresar a cada unidad de forma independiente.

- `App`: punto de entrada y selector de unidades.
- `Unit1`: aplicación de Escuela de Danza desarrollada con MVVM, Repository y funcionamiento offline.
- `Unit2`: microproyecto UNIACC Orienta, organizado con MVVM y Repository y preparado para la integración de CoreML y Firebase.
- `Assets.xcassets`: recursos generales de la aplicación.

## Unidad 1

Incluye consulta de estudiantes, clases, registro de asistencia, seguimiento de progreso, retroalimentación artística y registros audiovisuales. La coordinación de datos utiliza Repository, caché local, una fuente remota simulada y sincronización de asistencias pendientes.

## Unidad 2

UNIACC Orienta busca facilitar el acceso a servicios académicos a partir de consultas breves. La base actual separa clasificación, recursos académicos, ViewModel y fuentes de datos mediante protocolos e inyección de dependencias.

La integración final de la Unidad 2 reemplazará el clasificador preliminar por CoreML on-device y conectará el repositorio de recursos a Firebase/Firestore manteniendo la misma separación de capas.
