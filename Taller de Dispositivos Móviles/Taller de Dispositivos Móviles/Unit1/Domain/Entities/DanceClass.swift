import Foundation

struct DanceClass: Identifiable, Equatable {
    let id: UUID
    let discipline: String
    let durationMinutes: Int
    let room: String
    let teacherID: UUID
    let schedule: String

    /// Función de inicialización empleada para crear una clase de danza y validar que su duración sea mayor a cero.
    init(
        id: UUID = UUID(),
        discipline: String,
        durationMinutes: Int,
        room: String,
        teacherID: UUID,
        schedule: String
    ) {
        precondition(durationMinutes > 0, "La duración de la clase debe ser mayor a cero.")

        self.id = id
        self.discipline = discipline
        self.durationMinutes = durationMinutes
        self.room = room
        self.teacherID = teacherID
        self.schedule = schedule
    }
}
