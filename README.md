# Taller de Dispositivos Móviles

Proyecto desarrollado para la asignatura INFO0705 Taller de Dispositivos Móviles.

## Plataforma

iOS

## Tecnologías

- Swift
- SwiftUI
- Xcode

## Arquitectura

La aplicación se organiza en capas lógicas basadas en MVVM y Clean Architecture:

- `App`: composición e inyección de dependencias.
- `Presentation`: vistas y ViewModels.
- `Domain`: entidades y contratos de repositorio.
- `Data`: implementación de repositorios, caché local y fuentes remotas simuladas.

## Alcance actual

Base funcional para la gestión de una escuela de danza. Incluye consulta de estudiantes, clases, registro de asistencia, seguimiento de progreso, retroalimentación artística y modelo para registros audiovisuales. El acceso a datos se realiza mediante Repository, con soporte para caché local, simulación remota y sincronización de asistencia pendiente.
