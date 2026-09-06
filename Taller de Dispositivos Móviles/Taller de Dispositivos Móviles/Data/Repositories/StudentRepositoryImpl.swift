final class StudentRepositoryImpl: StudentRepository {
    private let localDataSource: LocalStudentDataSource
    private let remoteDataSource: RemoteStudentDataSource

    init(
        localDataSource: LocalStudentDataSource,
        remoteDataSource: RemoteStudentDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

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
