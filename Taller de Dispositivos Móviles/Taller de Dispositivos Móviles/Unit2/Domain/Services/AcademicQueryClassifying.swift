protocol AcademicQueryClassifying {
    /// Nombre empleado para identificar el motor de clasificación activo en la interfaz.
    var engineName: String { get }

    /// Indica si la clasificación está siendo realizada por un modelo CoreML.
    var usesCoreML: Bool { get }

    /// Función empleada para clasificar una consulta del estudiante dentro de una categoría académica.
    func classify(query: String) async throws -> AcademicClassification
}
