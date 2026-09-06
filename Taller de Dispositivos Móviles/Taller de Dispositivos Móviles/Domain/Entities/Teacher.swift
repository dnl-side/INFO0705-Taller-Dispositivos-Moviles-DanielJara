import Foundation

struct Teacher: Identifiable, Equatable {
    let id: UUID
    let name: String
    let specialty: String
    let availableSchedules: [String]

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
