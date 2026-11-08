import Foundation

struct Unit3AcademicClassification: Equatable {
    let category: Unit3AcademicCategory
    let confidence: Double
    let alternatives: [Unit3AcademicCategory]
    let isReliable: Bool

    init(
        category: Unit3AcademicCategory,
        confidence: Double,
        alternatives: [Unit3AcademicCategory] = [],
        isReliable: Bool = true
    ) {
        self.category = category
        self.confidence = min(max(confidence, 0), 1)
        self.alternatives = alternatives.filter { $0 != category }
        self.isReliable = isReliable
    }
}
