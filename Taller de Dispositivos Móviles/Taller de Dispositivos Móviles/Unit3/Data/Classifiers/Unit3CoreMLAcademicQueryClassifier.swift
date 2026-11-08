import Foundation
import NaturalLanguage

enum Unit3CoreMLAcademicQueryClassifierError: Error {
    case invalidPrediction
}

final class Unit3CoreMLAcademicQueryClassifier: Unit3QueryClassifying {
    private static let modelResourceName = "AcademicQueryClassifierV4"
    private static let minimumConfidence = 0.25
    private static let minimumMargin = 0.10

    private let model: NLModel?
    private let fallback: Unit3QueryClassifying

    init(
        bundle: Bundle = .main,
        fallback: Unit3QueryClassifying = Unit3KeywordAcademicQueryClassifier()
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

    func classify(query: String) async throws -> Unit3AcademicClassification {
        guard let model else {
            return try await fallback.classify(query: query)
        }

        let normalized = Unit3AcademicQueryNormalizer.normalize(query)
        guard !normalized.isEmpty else {
            throw Unit3AcademicQueryClassifierError.emptyQuery
        }

        let ranking = model
            .predictedLabelHypotheses(
                for: normalized,
                maximumCount: Unit3AcademicCategory.allCases.count
            )
            .compactMap { label, probability -> (Unit3AcademicCategory, Double)? in
                guard let category = Unit3AcademicCategory(rawValue: label) else { return nil }
                return (category, probability)
            }
            .sorted { lhs, rhs in
                if lhs.1 != rhs.1 { return lhs.1 > rhs.1 }
                return Self.order(of: lhs.0) < Self.order(of: rhs.0)
            }

        guard let best = ranking.first else {
            throw Unit3CoreMLAcademicQueryClassifierError.invalidPrediction
        }

        let secondProbability = ranking.dropFirst().first?.1 ?? 0
        let isReliable = best.1 >= Self.minimumConfidence
            && best.1 - secondProbability >= Self.minimumMargin

        return Unit3AcademicClassification(
            category: best.0,
            confidence: best.1,
            alternatives: ranking.dropFirst().prefix(2).map { $0.0 },
            isReliable: isReliable
        )
    }

    private static func order(of category: Unit3AcademicCategory) -> Int {
        Unit3AcademicCategory.allCases.firstIndex(of: category) ?? Int.max
    }
}
