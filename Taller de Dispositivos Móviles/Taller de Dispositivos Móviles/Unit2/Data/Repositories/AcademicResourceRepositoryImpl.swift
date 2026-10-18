final class AcademicResourceRepositoryImpl: AcademicResourceRepository {
    private let localDataSource: LocalAcademicResourceDataSource

    /// Función de inicialización empleada para recibir la fuente local utilizada durante la base funcional de la Unidad 2.
    init(localDataSource: LocalAcademicResourceDataSource) {
        self.localDataSource = localDataSource
    }

    /// Función empleada para obtener el recurso académico disponible para una categoría.
    func resource(for category: AcademicCategory) async throws -> AcademicResource {
        try localDataSource.resource(for: category)
    }
}
