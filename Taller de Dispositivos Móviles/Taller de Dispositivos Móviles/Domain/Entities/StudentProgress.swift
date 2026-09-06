import Foundation

struct StudentProgress: Identifiable, Equatable {
    let id: UUID
    let studentID: UUID
    let discipline: String
    let week: Int
    let trainingHours: Double
    let summary: String
    let recordedAt: Date

    init(
        id: UUID = UUID(),
        studentID: UUID,
        discipline: String,
        week: Int,
        trainingHours: Double,
        summary: String,
        recordedAt: Date = Date()
    ) {
        precondition(week > 0, "La semana debe ser mayor a cero.")
        precondition(trainingHours >= 0, "Las horas de entrenamiento no pueden ser negativas.")

        self.id = id
        self.studentID = studentID
        self.discipline = discipline
        self.week = week
        self.trainingHours = trainingHours
        self.summary = summary
        self.recordedAt = recordedAt
    }
}
