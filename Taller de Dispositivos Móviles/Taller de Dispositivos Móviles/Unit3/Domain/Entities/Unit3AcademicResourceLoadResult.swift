import Foundation

enum Unit3AcademicResourceSource: String, Equatable {
    case cloud
    case cache
    case localFallback

    var displayName: String {
        switch self {
        case .cloud: "Firestore"
        case .cache: "Caché Firestore"
        case .localFallback: "Respaldo local"
        }
    }
}

struct Unit3AcademicResourceLoadResult: Equatable {
    let resource: Unit3AcademicResource
    let source: Unit3AcademicResourceSource
}
