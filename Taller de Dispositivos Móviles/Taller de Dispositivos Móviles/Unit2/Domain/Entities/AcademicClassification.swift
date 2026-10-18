import Foundation

struct AcademicClassification: Equatable {
    let category: AcademicCategory
    let confidence: Double

    /// Función de inicialización empleada para representar el resultado de una clasificación académica.
    init(category: AcademicCategory, confidence: Double) {
        self.category = category
        self.confidence = min(max(confidence, 0), 1)
    }
}
