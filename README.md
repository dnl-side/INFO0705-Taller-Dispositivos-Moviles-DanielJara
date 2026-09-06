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
- `Data`: implementación de repositorios y fuentes de datos.

## Alcance actual

Implementación base del patrón Repository para consultar estudiantes, coordinando una fuente local en memoria y una fuente remota simulada. La capa de presentación depende de la abstracción definida en `Domain` y no de la implementación concreta del repositorio.
