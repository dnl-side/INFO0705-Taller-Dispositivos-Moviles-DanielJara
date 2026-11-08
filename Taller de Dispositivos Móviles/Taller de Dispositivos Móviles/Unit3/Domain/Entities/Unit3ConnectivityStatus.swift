import Foundation

enum Unit3ConnectivityStatus: Equatable {
    case unknown
    case online
    case offline

    var displayName: String {
        switch self {
        case .unknown: "Verificando"
        case .online: "En línea"
        case .offline: "Sin conexión"
        }
    }
}
