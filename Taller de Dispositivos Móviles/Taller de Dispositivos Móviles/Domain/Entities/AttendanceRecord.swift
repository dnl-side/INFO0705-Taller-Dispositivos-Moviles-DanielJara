import Foundation

enum AttendanceStatus: String, CaseIterable, Hashable {
    case attended = "Asistió"
    case late = "Atraso"
    case absent = "Ausente"
    case injury = "Lesión"
    case medicalObservation = "Observación médica"
}

struct AttendanceRecord: Identifiable, Equatable {
    let id: UUID
    let studentID: UUID
    let classID: UUID
    let date: Date
    let status: AttendanceStatus
    let note: String?
    let syncState: SyncState

    /// Función de inicialización empleada para crear un registro de asistencia con su estado y condición de sincronización.
    init(
        id: UUID = UUID(),
        studentID: UUID,
        classID: UUID,
        date: Date = Date(),
        status: AttendanceStatus,
        note: String? = nil,
        syncState: SyncState = .pending
    ) {
        self.id = id
        self.studentID = studentID
        self.classID = classID
        self.date = date
        self.status = status
        self.note = note
        self.syncState = syncState
    }

    /// Función empleada para generar una copia del registro marcada como sincronizada.
    func markingSynced() -> AttendanceRecord {
        AttendanceRecord(
            id: id,
            studentID: studentID,
            classID: classID,
            date: date,
            status: status,
            note: note,
            syncState: .synced
        )
    }
}
