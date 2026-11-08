import Foundation

final class Unit3KeywordAcademicQueryClassifier: Unit3QueryClassifying {
    private let keywords: [Unit3AcademicCategory: [String]] = [
        .evaluations: ["evaluacion", "evaluaciones", "calificacion", "calificaciones", "nota", "notas", "examen", "prueba"],
        .enrollment: ["matricula", "inscripcion", "inscribir", "continuidad", "semestre"],
        .certificates: ["certificado", "certificados", "constancia", "documento", "alumno regular"],
        .finance: ["pago", "pagos", "arancel", "cuota", "deuda", "finanzas"],
        .technicalSupport: ["clave", "contrasena", "portal", "aula", "acceso", "ingresar", "soporte"],
        .academicSupport: ["apoyo", "acompanamiento", "orientacion", "tutor", "avance"],
        .library: ["biblioteca", "libro", "libros", "paper", "papers", "bibliografia", "recurso"]
    ]

    var engineName: String { "Clasificador de respaldo" }
    var usesCoreML: Bool { false }

    func classify(query: String) async throws -> Unit3AcademicClassification {
        let normalized = Unit3AcademicQueryNormalizer.normalize(query)
        guard !normalized.isEmpty else {
            throw Unit3AcademicQueryClassifierError.emptyQuery
        }

        let ranked = Unit3AcademicCategory.allCases
            .map { category in
                let score = keywords[category, default: []].reduce(0) { partial, keyword in
                    partial + (normalized.contains(keyword) ? 1 : 0)
                }
                return (category, score)
            }
            .sorted { lhs, rhs in
                if lhs.1 != rhs.1 { return lhs.1 > rhs.1 }
                return Self.order(of: lhs.0) < Self.order(of: rhs.0)
            }

        guard let best = ranked.first, best.1 > 0 else {
            return Unit3AcademicClassification(
                category: .academicSupport,
                confidence: 0,
                alternatives: [],
                isReliable: false
            )
        }

        let alternatives = ranked
            .dropFirst()
            .filter { $0.1 > 0 }
            .prefix(2)
            .map { $0.0 }

        return Unit3AcademicClassification(
            category: best.0,
            confidence: min(0.55 + Double(best.1 - 1) * 0.12, 0.91),
            alternatives: alternatives,
            isReliable: true
        )
    }

    private static func order(of category: Unit3AcademicCategory) -> Int {
        Unit3AcademicCategory.allCases.firstIndex(of: category) ?? Int.max
    }
}
