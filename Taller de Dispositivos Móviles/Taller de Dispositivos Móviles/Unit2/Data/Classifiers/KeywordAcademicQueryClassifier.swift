import Foundation

enum AcademicQueryClassifierError: Error {
    case emptyQuery
}

final class KeywordAcademicQueryClassifier: AcademicQueryClassifying {
    let engineName = "Clasificador preliminar"
    let usesCoreML = false

    private let keywords: [AcademicCategory: [String]] = [
        .evaluations: ["evaluacion", "evaluaciones", "nota", "notas", "calificacion", "calificaciones", "prueba", "examen", "puntaje", "promedio"],
        .enrollment: ["matricula", "matricular", "matricularme", "inscripcion", "inscribir", "inscribirme", "continuidad"],
        .certificates: ["certificado", "certificados", "constancia", "alumno regular"],
        .finance: ["pago", "pagos", "pagar", "arancel", "cuota", "cuotas", "deuda", "finanzas", "cobro"],
        .technicalSupport: ["error", "acceso", "entrar", "clave", "contrasena", "plataforma", "soporte", "aula virtual", "portal"],
        .academicSupport: ["ayuda academica", "acompanamiento", "tutor", "orientacion", "apoyo academico"],
        .library: ["biblioteca", "libro", "libros", "bibliografia", "articulo", "articulos"]
    ]

    /// Función empleada como respaldo cuando el modelo CoreML todavía no se encuentra incorporado al proyecto.
    func classify(query: String) async throws -> AcademicClassification {
        let normalizedQuery = AcademicQueryNormalizer.normalize(query)

        guard !normalizedQuery.isEmpty else {
            throw AcademicQueryClassifierError.emptyQuery
        }

        let paddedQuery = " \(normalizedQuery) "

        let ranking = AcademicCategory.allCases
            .map { category -> (category: AcademicCategory, score: Int) in
                let score = (keywords[category] ?? []).reduce(0) { partialResult, word in
                    partialResult + (paddedQuery.contains(" \(word) ") ? 1 : 0)
                }
                return (category, score)
            }
            .filter { $0.score > 0 }
            .sorted { $0.score > $1.score }

        guard let best = ranking.first else {
            return AcademicClassification(
                category: .academicSupport,
                confidence: 0,
                isReliable: false
            )
        }

        let isTied = ranking.dropFirst().first?.score == best.score
        let confidence = min(0.55 + (Double(best.score) * 0.12), 0.91)

        return AcademicClassification(
            category: best.category,
            confidence: confidence,
            alternatives: ranking.dropFirst().prefix(2).map { $0.category },
            isReliable: !isTied
        )
    }
}
