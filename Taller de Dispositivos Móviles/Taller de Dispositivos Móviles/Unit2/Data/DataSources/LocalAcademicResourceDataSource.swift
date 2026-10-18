enum LocalAcademicResourceError: Error {
    case resourceNotFound
}

final class LocalAcademicResourceDataSource {
    private let resources: [AcademicResource]

    /// Función de inicialización empleada para recibir los recursos disponibles en la fuente local.
    init(resources: [AcademicResource] = AcademicSampleData.resources) {
        self.resources = resources
    }

    /// Función empleada para obtener localmente el recurso correspondiente a una categoría.
    func resource(for category: AcademicCategory) throws -> AcademicResource {
        guard let resource = resources.first(where: { $0.category == category }) else {
            throw LocalAcademicResourceError.resourceNotFound
        }

        return resource
    }
}
