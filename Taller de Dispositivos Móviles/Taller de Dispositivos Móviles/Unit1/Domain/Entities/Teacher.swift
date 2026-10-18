import Foundation

struct Teacher: Identifiable, Equatable {
    let id: UUID
    let name: String
    let specialty: String
    let availableSchedules: [String]

    /// Función de inicialización empleada para crear un profesor con su especialidad y horarios disponibles.
    init(
        id: UUID = UUID(),
        name: String,
        specialty: String,
        availableSchedules: [String]
    ) {
        self.id = id
        self.name = name
        self.specialty = specialty
        self.availableSchedules = availableSchedules
    }
}
