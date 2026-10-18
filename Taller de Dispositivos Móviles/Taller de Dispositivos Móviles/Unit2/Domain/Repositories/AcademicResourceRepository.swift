protocol AcademicResourceRepository {
    /// Función empleada para obtener el recurso académico correspondiente a una categoría sin depender de su origen concreto.
    func resource(for category: AcademicCategory) async throws -> AcademicResource
}
