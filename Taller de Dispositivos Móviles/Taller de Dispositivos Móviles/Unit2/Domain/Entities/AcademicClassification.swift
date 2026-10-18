import Foundation

struct AcademicClassification: Equatable {
    let category: AcademicCategory
    let confidence: Double
    let alternatives: [AcademicCategory]
    let isReliable: Bool

    /// Función de inicialización empleada para representar el resultado de una clasificación académica.
    /// `alternatives` contiene las siguientes categorías más probables y `isReliable` indica si la predicción puede mostrarse directamente.
    init(
        category: AcademicCategory,
        confidence: Double,
        alternatives: [AcademicCategory] = [],
        isReliable: Bool = true
    ) {
        self.category = category
        self.confidence = min(max(confidence, 0), 1)
        self.alternatives = alternatives.filter { $0 != category }
        self.isReliable = isReliable
    }
}
