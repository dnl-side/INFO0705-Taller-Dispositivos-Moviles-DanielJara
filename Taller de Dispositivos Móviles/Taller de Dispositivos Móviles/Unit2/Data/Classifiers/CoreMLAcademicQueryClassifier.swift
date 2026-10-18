import Foundation
import NaturalLanguage

enum CoreMLAcademicQueryClassifierError: Error {
    case invalidPrediction
}

final class CoreMLAcademicQueryClassifier: AcademicQueryClassifying {
    private static let modelResourceName = "AcademicQueryClassifierV4"

    /// Confianza mínima para mostrar directamente el recurso. Con siete categorías el azar equivale a 14,29 %.
    private static let minimumConfidence = 0.25

    /// Diferencia mínima entre la primera y la segunda categoría para considerar que no existe un empate.
    private static let minimumMargin = 0.10

    private let model: NLModel?
    private let fallback: AcademicQueryClassifying

    /// Función de inicialización empleada para cargar la versión normalizada del modelo CoreML desde los recursos de la aplicación.
    init(
        bundle: Bundle = .main,
        fallback: AcademicQueryClassifying = KeywordAcademicQueryClassifier()
    ) {
        self.fallback = fallback

        if let modelURL = bundle.url(
            forResource: Self.modelResourceName,
            withExtension: "mlmodelc"
        ) {
            model = try? NLModel(contentsOf: modelURL)
        } else {
            model = nil
        }
    }

    var engineName: String {
        model == nil ? fallback.engineName : "CoreML on-device · v1.4 ES"
    }

    var usesCoreML: Bool {
        model != nil
    }

    /// Función empleada para ejecutar la clasificación local mediante CoreML y utilizar el clasificador preliminar solo como respaldo.
    func classify(query: String) async throws -> AcademicClassification {
        guard let model else {
            return try await fallback.classify(query: query)
        }

        let normalizedQuery = AcademicQueryNormalizer.normalize(query)
        guard !normalizedQuery.isEmpty else {
            throw AcademicQueryClassifierError.emptyQuery
        }

        let ranking = model
            .predictedLabelHypotheses(
                for: normalizedQuery,
                maximumCount: AcademicCategory.allCases.count
            )
            .compactMap { label, probability -> (category: AcademicCategory, probability: Double)? in
                guard let category = AcademicCategory(rawValue: label) else { return nil }
                return (category, probability)
            }
            .sorted { lhs, rhs in
                if lhs.probability != rhs.probability {
                    return lhs.probability > rhs.probability
                }
                return Self.order(of: lhs.category) < Self.order(of: rhs.category)
            }

        guard let best = ranking.first else {
            throw CoreMLAcademicQueryClassifierError.invalidPrediction
        }

        let secondProbability = ranking.dropFirst().first?.probability ?? 0
        let isReliable = best.probability >= Self.minimumConfidence
            && best.probability - secondProbability >= Self.minimumMargin

        return AcademicClassification(
            category: best.category,
            confidence: best.probability,
            alternatives: ranking.dropFirst().prefix(2).map { $0.category },
            isReliable: isReliable
        )
    }

    /// Función empleada para desempatar de forma estable según el orden declarado de las categorías.
    private static func order(of category: AcademicCategory) -> Int {
        AcademicCategory.allCases.firstIndex(of: category) ?? Int.max
    }
}
