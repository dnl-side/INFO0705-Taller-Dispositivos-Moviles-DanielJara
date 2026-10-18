import Combine
import Foundation

@MainActor
final class UNIACCOrientaViewModel: ObservableObject {
    @Published private(set) var classification: AcademicClassification?
    @Published private(set) var resource: AcademicResource?
    @Published private(set) var lastProcessedQuery = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let classifier: AcademicQueryClassifying
    private let resourceRepository: AcademicResourceRepository

    /// Función de inicialización empleada para recibir el clasificador y el repositorio de recursos académicos.
    init(
        classifier: AcademicQueryClassifying,
        resourceRepository: AcademicResourceRepository
    ) {
        self.classifier = classifier
        self.resourceRepository = resourceRepository
    }

    /// Propiedad empleada para indicar el motor que está procesando las consultas.
    var classifierEngineName: String {
        classifier.engineName
    }

    /// Propiedad empleada para indicar si el modelo CoreML se encuentra cargado y activo.
    var usesCoreML: Bool {
        classifier.usesCoreML
    }

    /// Función empleada para clasificar una consulta entregada por la vista y recuperar el recurso correspondiente.
    func submitQuery(_ query: String) async {
        guard !isLoading else { return }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            errorMessage = "Escribe una consulta antes de continuar."
            classification = nil
            resource = nil
            lastProcessedQuery = ""
            return
        }

        isLoading = true
        errorMessage = nil
        classification = nil
        resource = nil
        lastProcessedQuery = trimmedQuery

        defer {
            isLoading = false
        }

        do {
            let result = try await classifier.classify(query: trimmedQuery)
            classification = result
            resource = try await resourceRepository.resource(for: result.category)
        } catch {
            classification = nil
            resource = nil
            errorMessage = "No fue posible procesar la consulta."
        }
    }

    /// Función empleada para limpiar el resultado anterior y dejar la vista preparada para una nueva consulta.
    func reset() {
        classification = nil
        resource = nil
        lastProcessedQuery = ""
        errorMessage = nil
    }
}
