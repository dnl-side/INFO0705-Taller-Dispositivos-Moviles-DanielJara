import Foundation

final class AcademicResourceRepositoryImpl: AcademicResourceRepository {
    private let localDataSource: LocalAcademicResourceDataSource
    private let remoteDataSource: FirestoreAcademicResourceDataSource

    /// Función de inicialización empleada para recibir las fuentes remota y local coordinadas por el Repository.
    init(
        localDataSource: LocalAcademicResourceDataSource,
        remoteDataSource: FirestoreAcademicResourceDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    /// Función empleada para priorizar Firestore y utilizar el respaldo local si la nube no está disponible.
    func resource(for category: AcademicCategory) async throws -> AcademicResourceLoadResult {
        do {
            return try await remoteDataSource.resource(for: category)
        } catch {
            let resource = try localDataSource.resource(for: category)
            let nsError = error as NSError
            let reason = nsError.domain
                + " ["
                + String(nsError.code)
                + "]: "
                + nsError.localizedDescription

            return AcademicResourceLoadResult(
                resource: resource,
                source: .localFallback,
                fallbackReason: reason
            )
        }
    }
}
