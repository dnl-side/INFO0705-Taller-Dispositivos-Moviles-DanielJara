final class Unit3AcademicResourceRepositoryImpl: Unit3AcademicResourceRepository {
    private let localDataSource: Unit3LocalAcademicResourceDataSource
    private let remoteDataSource: Unit3FirestoreAcademicResourceDataSource

    init(
        localDataSource: Unit3LocalAcademicResourceDataSource,
        remoteDataSource: Unit3FirestoreAcademicResourceDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func resource(for category: Unit3AcademicCategory) async throws -> Unit3AcademicResourceLoadResult {
        do {
            return try await remoteDataSource.resource(for: category)
        } catch {
            return Unit3AcademicResourceLoadResult(
                resource: try localDataSource.resource(for: category),
                source: .localFallback
            )
        }
    }
}
