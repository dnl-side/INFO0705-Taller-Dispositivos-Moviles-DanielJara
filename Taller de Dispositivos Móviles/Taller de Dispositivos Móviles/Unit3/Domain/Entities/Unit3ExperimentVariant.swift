import Foundation

enum Unit3ExperimentVariant: String, CaseIterable {
    case focused
    case expanded

    var displayName: String {
        switch self {
        case .focused: "Alternativas priorizadas"
        case .expanded: "Todas las categorías"
        }
    }
}
