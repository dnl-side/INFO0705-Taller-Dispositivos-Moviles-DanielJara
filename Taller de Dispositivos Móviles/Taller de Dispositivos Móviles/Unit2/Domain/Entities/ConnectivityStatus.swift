enum ConnectivityStatus: Equatable {
    case unknown
    case online
    case offline

    /// Nombre empleado para mostrar el estado de conectividad de forma legible.
    var displayName: String {
        switch self {
        case .unknown:
            "Verificando"
        case .online:
            "En línea"
        case .offline:
            "Sin conexión"
        }
    }
}
