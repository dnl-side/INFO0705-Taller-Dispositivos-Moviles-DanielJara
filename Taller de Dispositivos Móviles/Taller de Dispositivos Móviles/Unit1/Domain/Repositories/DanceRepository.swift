import Foundation

protocol DanceRepository {
    /// Función empleada para solicitar las clases disponibles sin depender del origen concreto de los datos.
    func getClasses() async throws -> [DanceClass]

    /// Función empleada para solicitar los registros de asistencia de una clase.
    func getAttendance(for classID: UUID) async -> [AttendanceRecord]

    /// Función empleada para guardar un registro de asistencia mediante la abstracción del repositorio.
    func saveAttendance(_ record: AttendanceRecord) async throws

    /// Función empleada para solicitar el progreso de un estudiante en una disciplina.
    func getProgress(for studentID: UUID, discipline: String) async throws -> [StudentProgress]

    /// Función empleada para solicitar la retroalimentación artística de un estudiante.
    func getFeedback(for studentID: UUID) async -> [ArtisticFeedback]

    /// Función empleada para solicitar los registros audiovisuales de una clase.
    func getMedia(for classID: UUID) async -> [MediaRecord]

    /// Función empleada para iniciar la sincronización de asistencias que se encuentran pendientes.
    func synchronizePendingAttendance() async
}
