import Foundation

enum AcademicCategory: String, CaseIterable, Identifiable {
    case evaluations
    case enrollment
    case certificates
    case finance
    case technicalSupport
    case academicSupport
    case library

    var id: String { rawValue }

    /// Propiedad empleada para mostrar un nombre legible de cada categoría académica.
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

    /// Propiedad empleada para asociar un símbolo visual a cada categoría.
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
