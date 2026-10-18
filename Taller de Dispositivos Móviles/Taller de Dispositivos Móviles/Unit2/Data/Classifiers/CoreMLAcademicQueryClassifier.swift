import Foundation
import NaturalLanguage

enum CoreMLAcademicQueryClassifierError: Error {
    case invalidPrediction
}

final class CoreMLAcademicQueryClassifier: AcademicQueryClassifying {
    private let model: NLModel?
    private let fallback: AcademicQueryClassifying

    /// Función de inicialización empleada para cargar el modelo CoreML compilado desde los recursos de la aplicación.
    init(
        bundle: Bundle = .main,
        fallback: AcademicQueryClassifying = KeywordAcademicQueryClassifier()
    ) {
        self.fallback = fallback

        if let modelURL = bundle.url(
            forResource: "AcademicQueryClassifier",
            withExtension: "mlmodelc"
        ) {
            model = try? NLModel(contentsOf: modelURL)
        } else {
            model = nil
        }
    }

    var engineName: String {
        model == nil ? fallback.engineName : "CoreML on-device"
    }

    var usesCoreML: Bool {
        model != nil
    }

    /// Función empleada para ejecutar la clasificación local mediante CoreML y utilizar el clasificador preliminar solo como respaldo.
    func classify(query: String) async throws -> AcademicClassification {
        guard let model else {
            return try await fallback.classify(query: query)
        }

        let hypotheses = model.predictedLabelHypotheses(
            for: query,
            maximumCount: 1
        )

        guard let bestPrediction = hypotheses.max(by: { $0.value < $1.value }),
              let category = AcademicCategory(rawValue: bestPrediction.key) else {
            throw CoreMLAcademicQueryClassifierError.invalidPrediction
        }

        return AcademicClassification(
            category: category,
            confidence: bestPrediction.value
        )
    }
}
