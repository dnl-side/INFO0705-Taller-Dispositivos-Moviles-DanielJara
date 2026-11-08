import Foundation

struct Unit3AcademicResource: Identifiable, Equatable {
    let id: UUID
    let category: Unit3AcademicCategory
    let title: String
    let summary: String
    let steps: [String]
    let channel: String

    init(
        id: UUID = UUID(),
        category: Unit3AcademicCategory,
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
