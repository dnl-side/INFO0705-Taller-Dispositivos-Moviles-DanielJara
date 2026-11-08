import Foundation

struct ProtectedHistoryEntry: Codable, Equatable, Identifiable {
    let id: UUID
    let query: String
    let category: Unit3AcademicCategory
    let createdAt: Date

    init(
        id: UUID = UUID(),
        query: String,
        category: Unit3AcademicCategory,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.query = query
        self.category = category
        self.createdAt = createdAt
    }
}
