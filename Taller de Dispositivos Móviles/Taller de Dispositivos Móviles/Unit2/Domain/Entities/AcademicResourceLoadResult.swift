import Foundation

enum AcademicResourceSource: String, Equatable {
    case cloud
    case cache
    case localFallback

    /// Nombre empleado para mostrar el origen de los datos recuperados.
    var displayName: String {
        switch self {
        case .cloud:
            "Firestore"
        case .cache:
            "Caché Firestore"
        case .localFallback:
            "Respaldo local"
        }
    }
}

struct AcademicResourceLoadResult: Equatable {
    let resource: AcademicResource
    let source: AcademicResourceSource
    let fallbackReason: String?

    /// Función de inicialización empleada para asociar un recurso académico con su origen de datos.
    init(
        resource: AcademicResource,
        source: AcademicResourceSource,
        fallbackReason: String? = nil
    ) {
        self.resource = resource
        self.source = source
        self.fallbackReason = fallbackReason
    }
}
