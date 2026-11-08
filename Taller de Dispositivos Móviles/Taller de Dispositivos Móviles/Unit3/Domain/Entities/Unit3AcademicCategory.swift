import Foundation

enum Unit3AcademicCategory: String, CaseIterable, Codable, Identifiable {
    case evaluations
    case enrollment
    case certificates
    case finance
    case technicalSupport
    case academicSupport
    case library

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .evaluations: "Evaluaciones"
        case .enrollment: "Matrícula"
        case .certificates: "Certificados"
        case .finance: "Finanzas"
        case .technicalSupport: "Soporte técnico"
        case .academicSupport: "Acompañamiento académico"
        case .library: "Biblioteca y recursos"
        }
    }

    var systemImage: String {
        switch self {
        case .evaluations: "checklist"
        case .enrollment: "person.text.rectangle"
        case .certificates: "doc.text"
        case .finance: "creditcard"
        case .technicalSupport: "wrench.and.screwdriver"
        case .academicSupport: "person.2"
        case .library: "books.vertical"
        }
    }
}
