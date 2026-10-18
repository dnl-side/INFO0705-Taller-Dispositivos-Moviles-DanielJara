import Foundation

struct AcademicResource: Identifiable, Equatable {
    let id: UUID
    let category: AcademicCategory
    let title: String
    let summary: String
    let steps: [String]
    let channel: String

    /// Función de inicialización empleada para representar un recurso académico asociado a una categoría.
    init(
        id: UUID = UUID(),
        category: AcademicCategory,
        title: String,
        summary: String,
        steps: [String],
        channel: String
    ) {
        self.id = id
        self.category = category
        self.title = title
        self.summary = summary
        self.steps = steps
        self.channel = channel
    }
}
