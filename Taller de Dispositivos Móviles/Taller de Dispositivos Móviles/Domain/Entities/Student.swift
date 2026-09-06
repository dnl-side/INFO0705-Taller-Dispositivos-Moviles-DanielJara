import Foundation

struct Student: Identifiable, Equatable {
    let id: UUID
    let name: String
    let technicalLevel: TechnicalLevel
    let classHistory: [UUID]

    init(
        id: UUID = UUID(),
        name: String,
        technicalLevel: TechnicalLevel,
        classHistory: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.technicalLevel = technicalLevel
        self.classHistory = classHistory
    }
}

enum TechnicalLevel: String, CaseIterable {
    case initial = "Inicial"
    case intermediate = "Intermedio"
    case advanced = "Avanzado"
}
