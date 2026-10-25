# Taller de Dispositivos Móviles

Proyecto desarrollado para la asignatura INFO0705 Taller de Dispositivos Móviles.

## Plataforma

iOS

## Tecnologías

- Swift
- SwiftUI
- Xcode
- CoreML / NaturalLanguage
- Firebase / Firestore (Unidad 2)

## Organización

La aplicación funciona como contenedor de las actividades del ramo. Al iniciar se muestra un selector que permite ingresar a cada unidad de forma independiente.

- `App`: punto de entrada y selector de unidades.
- `Unit1`: aplicación de Escuela de Danza desarrollada con MVVM, Repository y funcionamiento offline.
- `Unit2`: microproyecto UNIACC Orienta, organizado con MVVM y Repository.
- `Training/Unit2`: datos y script utilizados para entrenar el clasificador de texto CoreML.
- `Assets.xcassets`: recursos generales de la aplicación.

## Unidad 1

Incluye consulta de estudiantes, clases, registro de asistencia, seguimiento de progreso, retroalimentación artística y registros audiovisuales. La coordinación de datos utiliza Repository, caché local, una fuente remota simulada y sincronización de asistencias pendientes.

## Unidad 2

UNIACC Orienta busca facilitar el acceso a servicios académicos a partir de consultas breves. La clasificación se integra mediante un contrato independiente del ViewModel. El modelo `AcademicQueryClassifierV4.mlmodel` procesa las consultas localmente mediante CoreML; si el recurso no se encuentra disponible, se conserva un clasificador preliminar como respaldo. Las consultas se normalizan (sin tildes, mayúsculas ni signos) antes de clasificarse, y cuando la confianza es baja la aplicación permite elegir la categoría manualmente en lugar de mostrar un recurso incorrecto.

Los recursos académicos se obtienen mediante `AcademicResourceRepository`: Firestore actúa como fuente cloud, la caché de Firestore permite reutilizar datos disponibles sin conexión y `LocalAcademicResourceDataSource` queda como respaldo si el servicio remoto no está disponible. La interfaz informa además el estado de conectividad y el origen del recurso mostrado.


## Validación Unidad 2

La integración se validó en iOS Simulator con Firebase Apple SDK 13.1.1:

- clasificación local mediante CoreML V4;
- autenticación anónima en Firebase;
- lectura de los siete recursos desde Cloud Firestore;
- detección de conectividad con Network.framework;
- lectura desde caché persistente de Firestore al perder conexión;
- recuperación automática de la fuente cloud al restablecer la red;
- respaldo local cuando la fuente remota no se encuentra disponible.
