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

UNIACC Orienta busca facilitar el acceso a servicios académicos a partir de consultas breves. La clasificación se integra mediante un contrato independiente del ViewModel. Cuando el modelo `AcademicQueryClassifier.mlmodel` está presente, las consultas se procesan localmente con CoreML; mientras no exista el recurso compilado, se conserva un clasificador preliminar como respaldo. Las consultas se normalizan (sin tildes, mayúsculas ni signos) antes de clasificarse, y cuando la confianza es baja la aplicación permite elegir la categoría manualmente en lugar de mostrar un recurso incorrecto.

Los recursos académicos continúan detrás de `AcademicResourceRepository`, preparado para sustituir la fuente local por Firebase/Firestore sin modificar la capa de presentación.
