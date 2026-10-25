protocol AcademicResourceRepository {
    /// Función empleada para obtener el recurso académico correspondiente a una categoría junto con su origen de datos.
    func resource(for category: AcademicCategory) async throws -> AcademicResourceLoadResult
}
