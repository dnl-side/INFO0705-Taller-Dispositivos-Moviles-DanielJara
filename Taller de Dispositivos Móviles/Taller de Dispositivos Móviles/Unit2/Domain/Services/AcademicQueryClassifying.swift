protocol AcademicQueryClassifying {
    /// Función empleada para clasificar una consulta del estudiante dentro de una categoría académica.
    func classify(query: String) async throws -> AcademicClassification
}
