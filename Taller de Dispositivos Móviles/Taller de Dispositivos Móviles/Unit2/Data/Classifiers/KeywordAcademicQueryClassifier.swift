import Foundation

enum AcademicQueryClassifierError: Error {
    case emptyQuery
}

final class KeywordAcademicQueryClassifier: AcademicQueryClassifying {
    let engineName = "Clasificador preliminar"
    let usesCoreML = false

    private let keywords: [AcademicCategory: [String]] = [
        .evaluations: ["evaluacion", "evaluaciones", "nota", "notas", "calificacion", "prueba", "examen"],
        .enrollment: ["matricula", "matricular", "inscripcion", "inscribir", "continuidad"],
        .certificates: ["certificado", "certificados", "documento", "constancia", "alumno regular"],
        .finance: ["pago", "pagos", "arancel", "cuota", "deuda", "finanzas"],
        .technicalSupport: ["error", "acceso", "entrar", "clave", "contrasena", "plataforma", "soporte", "aula virtual"],
        .academicSupport: ["ayuda academica", "acompanamiento", "tutor", "orientacion", "asignatura"],
        .library: ["biblioteca", "libro", "libros", "bibliografia", "recurso", "articulo"]
    ]

    /// Función empleada como respaldo cuando el modelo CoreML todavía no se encuentra incorporado al proyecto.
    func classify(query: String) async throws -> AcademicClassification {
        let normalizedQuery = query
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedQuery.isEmpty else {
            throw AcademicQueryClassifierError.emptyQuery
        }

        let scores = keywords.mapValues { words in
            words.reduce(0) { partialResult, word in
                partialResult + (normalizedQuery.contains(word) ? 1 : 0)
            }
        }

        if let bestMatch = scores.max(by: { $0.value < $1.value }),
           bestMatch.value > 0 {
            let confidence = min(0.55 + (Double(bestMatch.value) * 0.12), 0.91)
            return AcademicClassification(category: bestMatch.key, confidence: confidence)
        }

        return AcademicClassification(category: .academicSupport, confidence: 0.40)
    }
}
