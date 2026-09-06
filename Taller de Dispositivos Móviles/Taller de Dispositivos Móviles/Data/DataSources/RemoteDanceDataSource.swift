import Foundation

enum RemoteDanceDataSourceError: Error {
    case unavailable
}

final class RemoteDanceDataSource {
    private let shouldFail: Bool

    /// Función de inicialización empleada para configurar si la fuente remota simulada debe responder correctamente o fallar.
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    /// Función empleada para simular la descarga remota de las clases disponibles.
    func fetchClasses() async throws -> [DanceClass] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if shouldFail {
            throw RemoteDanceDataSourceError.unavailable
        }

        return DanceSampleData.classes
    }

    /// Función empleada para simular el envío de un registro de asistencia a una fuente remota.
    func uploadAttendance(_ record: AttendanceRecord) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)

        if shouldFail {
            throw RemoteDanceDataSourceError.unavailable
        }
    }

    /// Función empleada para simular la descarga del progreso de un estudiante en una disciplina determinada.
    func fetchProgress(for studentID: UUID, discipline: String) async throws -> [StudentProgress] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if shouldFail {
            throw RemoteDanceDataSourceError.unavailable
        }

        return DanceSampleData.progress.filter {
            $0.studentID == studentID && $0.discipline == discipline
        }
    }
}
