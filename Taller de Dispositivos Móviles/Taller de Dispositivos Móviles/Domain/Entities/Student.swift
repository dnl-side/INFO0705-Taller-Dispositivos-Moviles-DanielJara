import Foundation

struct Student: Identifiable, Equatable {
    let id: UUID
    let name: String
    let technicalLevel: TechnicalLevel

    init(id: UUID = UUID(), name: String, technicalLevel: TechnicalLevel) {
        self.id = id
        self.name = name
        self.technicalLevel = technicalLevel
    }
}

enum TechnicalLevel: String, CaseIterable {
    case initial = "Inicial"
    case intermediate = "Intermedio"
    case advanced = "Avanzado"
}
