final class StudentRepositoryImpl: StudentRepository {
    private let localDataSource: LocalStudentDataSource
    private let remoteDataSource: RemoteStudentDataSource

    /// Función de inicialización empleada para recibir las fuentes de datos local y remota utilizadas por el repositorio.
    init(
        localDataSource: LocalStudentDataSource,
        remoteDataSource: RemoteStudentDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    /// Función empleada para obtener estudiantes desde la fuente remota y usar la copia local si la operación falla.
    func getStudents() async throws -> [Student] {
        let cachedStudents = localDataSource.getStudents()

        do {
            let remoteStudents = try await remoteDataSource.fetchStudents()
            localDataSource.saveStudents(remoteStudents)
            return remoteStudents
        } catch {
            if !cachedStudents.isEmpty {
                return cachedStudents
            }

            throw error
        }
    }
}
