import Combine
import Foundation

@MainActor
final class UNIACCOrientaViewModel: ObservableObject {
    @Published private(set) var classification: AcademicClassification?
    @Published private(set) var resource: AcademicResource?
    @Published private(set) var resourceSource: AcademicResourceSource?
    @Published private(set) var connectivityStatus: ConnectivityStatus
    @Published private(set) var lastProcessedQuery = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var suggestedCategories: [AcademicCategory] = []
    @Published private(set) var needsCategorySelection = false
    @Published private(set) var isManualSelection = false

    private let classifier: AcademicQueryClassifying
    private let resourceRepository: AcademicResourceRepository
    private var cancellables = Set<AnyCancellable>()

    /// Función de inicialización empleada para recibir clasificación, datos y estado de conectividad.
    init(
        classifier: AcademicQueryClassifying,
        resourceRepository: AcademicResourceRepository,
        connectivityMonitor: ConnectivityMonitoring
    ) {
        self.classifier = classifier
        self.resourceRepository = resourceRepository
        connectivityStatus = connectivityMonitor.currentStatus

        connectivityMonitor.statusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.connectivityStatus = status
            }
            .store(in: &cancellables)
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
            clearResult()
            lastProcessedQuery = ""
            errorMessage = "Escribe una consulta antes de continuar."
            return
        }

        isLoading = true
        clearResult()
        lastProcessedQuery = trimmedQuery

        defer {
            isLoading = false
        }

        do {
            let result = try await classifier.classify(query: trimmedQuery)
            classification = result

            if result.isReliable {
                let loadResult = try await resourceRepository.resource(for: result.category)
                resource = loadResult.resource
                resourceSource = loadResult.source
                suggestedCategories = rankedCategories(
                    preferred: result.alternatives,
                    excluding: result.category
                )
            } else {
                needsCategorySelection = true
                suggestedCategories = rankedCategories(
                    preferred: result.confidence > 0 ? [result.category] + result.alternatives : []
                )
            }
        } catch {
            clearResult()
            errorMessage = "No fue posible procesar la consulta."
        }
    }

    /// Función empleada para mostrar el recurso de una categoría elegida por el estudiante cuando la sugerencia no es la adecuada.
    func selectCategory(_ category: AcademicCategory) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let loadResult = try await resourceRepository.resource(for: category)

            resource = loadResult.resource
            resourceSource = loadResult.source
            classification = AcademicClassification(category: category, confidence: 1)
            isManualSelection = true
            needsCategorySelection = false
            suggestedCategories = rankedCategories(
                preferred: suggestedCategories,
                excluding: category
            )
        } catch {
            errorMessage = "No fue posible cargar el recurso seleccionado."
        }
    }

    /// Función empleada para limpiar el resultado anterior y dejar la vista preparada para una nueva consulta.
    func reset() {
        clearResult()
        lastProcessedQuery = ""
    }

    /// Función empleada para eliminar el resultado visible sin modificar la consulta procesada.
    private func clearResult() {
        classification = nil
        resource = nil
        resourceSource = nil
        errorMessage = nil
        suggestedCategories = []
        needsCategorySelection = false
        isManualSelection = false
    }

    /// Función empleada para ordenar todas las categorías comenzando por las sugeridas por el clasificador.
    private func rankedCategories(
        preferred: [AcademicCategory],
        excluding excludedCategory: AcademicCategory? = nil
    ) -> [AcademicCategory] {
        let remaining = AcademicCategory.allCases.filter { !preferred.contains($0) }
        return (preferred + remaining).filter { $0 != excludedCategory }
    }
}
