import Foundation

enum Unit3PerformanceOperation: String, CaseIterable, Codable, Hashable, Identifiable {
    case orientation = "Orientación completa"
    case classification = "Clasificación CoreML"
    case resourceLoad = "Carga de recurso"
    case protectedHistorySave = "Guardado cifrado"
    case protectedHistoryLoad = "Lectura cifrada"

    var id: String { rawValue }
}

struct Unit3PerformanceSample: Codable, Identifiable, Equatable {
    let id: UUID
    let operation: Unit3PerformanceOperation
    let durationMilliseconds: Double
    let createdAt: Date

    init(
        id: UUID = UUID(),
        operation: Unit3PerformanceOperation,
        durationMilliseconds: Double,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.operation = operation
        self.durationMilliseconds = durationMilliseconds
        self.createdAt = createdAt
    }
}
