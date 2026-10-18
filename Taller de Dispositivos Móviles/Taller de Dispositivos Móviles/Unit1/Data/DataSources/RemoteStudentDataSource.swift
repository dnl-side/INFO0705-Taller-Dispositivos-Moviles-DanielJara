import Foundation

enum RemoteStudentDataSourceError: Error {
    case unavailable
}

final class RemoteStudentDataSource {
    private let shouldFail: Bool

    /// Función de inicialización empleada para configurar si la fuente remota simulada debe responder correctamente o fallar.
    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    /// Función empleada para simular la descarga remota de la lista de estudiantes.
    func fetchStudents() async throws -> [Student] {
        try await Task.sleep(nanoseconds: 800_000_000)

        if shouldFail {
            throw RemoteStudentDataSourceError.unavailable
        }

        return DanceSampleData.students
    }
}
