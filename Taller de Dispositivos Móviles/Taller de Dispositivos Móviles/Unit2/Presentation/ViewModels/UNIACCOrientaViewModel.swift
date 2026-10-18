import Combine
import Foundation

@MainActor
final class UNIACCOrientaViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var classification: AcademicClassification?
    @Published private(set) var resource: AcademicResource?
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

    /// Función empleada para clasificar la consulta y recuperar el recurso correspondiente.
    func submitQuery() async {
        guard !isLoading else { return }

        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            errorMessage = "Escribe una consulta antes de continuar."
            classification = nil
            resource = nil
            return
        }

        isLoading = true
        errorMessage = nil

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

    /// Función empleada para cargar rápidamente una consulta de ejemplo en la interfaz.
    func useExample(_ example: String) {
        query = example
        classification = nil
        resource = nil
        errorMessage = nil
    }

    /// Función empleada para limpiar la consulta y su resultado.
    func reset() {
        query = ""
        classification = nil
        resource = nil
        errorMessage = nil
    }
}
