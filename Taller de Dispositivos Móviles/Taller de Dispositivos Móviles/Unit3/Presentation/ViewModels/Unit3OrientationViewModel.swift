import Combine
import Foundation

@MainActor
final class Unit3OrientationViewModel: ObservableObject {
    @Published private(set) var classification: Unit3AcademicClassification?
    @Published private(set) var resource: Unit3AcademicResource?
    @Published private(set) var resourceSource: Unit3AcademicResourceSource?
    @Published private(set) var connectivityStatus: Unit3ConnectivityStatus
    @Published private(set) var lastProcessedQuery = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var historyMessage: String?
    @Published private(set) var suggestedCategories: [Unit3AcademicCategory] = []
    @Published private(set) var needsCategorySelection = false
    @Published private(set) var isManualSelection = false
    @Published private(set) var experimentVariant: Unit3ExperimentVariant

    private let classifier: Unit3QueryClassifying
    private let resourceRepository: Unit3AcademicResourceRepository
    private let historyRepository: Unit3ProtectedHistoryRepository
    private let connectivityMonitor: Unit3ConnectivityMonitoring
    private let analyticsTracker: Unit3AnalyticsTracking
    private let experimentProvider: Unit3ExperimentProviding
    private let performanceTracker: Unit3PerformanceTracker
    private var cancellables = Set<AnyCancellable>()

    init(
        classifier: Unit3QueryClassifying,
        resourceRepository: Unit3AcademicResourceRepository,
        historyRepository: Unit3ProtectedHistoryRepository,
        connectivityMonitor: Unit3ConnectivityMonitoring,
        analyticsTracker: Unit3AnalyticsTracking,
        experimentProvider: Unit3ExperimentProviding,
        performanceTracker: Unit3PerformanceTracker
    ) {
        self.classifier = classifier
        self.resourceRepository = resourceRepository
        self.historyRepository = historyRepository
        self.connectivityMonitor = connectivityMonitor
        self.analyticsTracker = analyticsTracker
        self.experimentProvider = experimentProvider
        self.performanceTracker = performanceTracker
        connectivityStatus = connectivityMonitor.currentStatus
        experimentVariant = experimentProvider.currentVariant

        connectivityMonitor.statusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.connectivityStatus = status
            }
            .store(in: &cancellables)
    }

    var classifierEngineName: String {
        classifier.engineName
    }

    var usesCoreML: Bool {
        classifier.usesCoreML
    }

    func prepare() async {
        await experimentProvider.refresh()
        experimentVariant = experimentProvider.currentVariant
    }

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

        analyticsTracker.track(
            .orientationStarted,
            parameters: ["variant": experimentVariant.rawValue]
        )

        defer {
            isLoading = false
        }

        do {
            try await performanceTracker.measure(.orientation) {
                let result = try await performanceTracker.measure(.classification) {
                    try await classifier.classify(query: trimmedQuery)
                }

                classification = result

                if result.isReliable {
                    analyticsTracker.track(
                        .classificationAccepted,
                        parameters: ["category": result.category.rawValue]
                    )

                    try await loadResource(for: result.category)
                    needsCategorySelection = false
                } else {
                    needsCategorySelection = true
                    suggestedCategories = categoriesForLowConfidence(result)
                }
            }
        } catch {
            clearResult()
            errorMessage = "No fue posible procesar la consulta."
        }
    }

    func selectCategory(_ category: Unit3AcademicCategory) async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        historyMessage = nil

        defer {
            isLoading = false
        }

        do {
            try await loadResource(for: category)
            classification = Unit3AcademicClassification(
                category: category,
                confidence: 1
            )
            isManualSelection = true
            needsCategorySelection = false

            analyticsTracker.track(
                .classificationCorrected,
                parameters: ["category": category.rawValue]
            )
        } catch {
            errorMessage = "No fue posible cargar el recurso seleccionado."
        }
    }

    func saveCurrentResultToProtectedHistory() async {
        guard
            let classification,
            resource != nil,
            !lastProcessedQuery.isEmpty
        else {
            return
        }

        let entry = ProtectedHistoryEntry(
            query: lastProcessedQuery,
            category: classification.category
        )

        do {
            try await performanceTracker.measure(.protectedHistorySave) {
                try historyRepository.add(entry)
            }

            historyMessage = "Consulta guardada de forma cifrada."
            analyticsTracker.track(
                .historySaved,
                parameters: ["category": classification.category.rawValue]
            )
        } catch {
            historyMessage = "No fue posible guardar la consulta."
        }
    }

    func reset() {
        clearResult()
        lastProcessedQuery = ""
    }

    private func loadResource(for category: Unit3AcademicCategory) async throws {
        let loadResult = try await performanceTracker.measure(.resourceLoad) {
            try await resourceRepository.resource(for: category)
        }

        resource = loadResult.resource
        resourceSource = loadResult.source
        suggestedCategories = Unit3AcademicCategory.allCases.filter { $0 != category }

        analyticsTracker.track(
            .resourceLoaded,
            parameters: [
                "category": category.rawValue,
                "source": loadResult.source.rawValue
            ]
        )

        if loadResult.source == .cache {
            analyticsTracker.track(
                .cacheUsed,
                parameters: ["category": category.rawValue]
            )
        }

        analyticsTracker.track(
            .orientationCompleted,
            parameters: ["category": category.rawValue]
        )
    }

    private func categoriesForLowConfidence(
        _ result: Unit3AcademicClassification
    ) -> [Unit3AcademicCategory] {
        let preferred = [result.category] + result.alternatives

        switch experimentVariant {
        case .focused:
            return Array(preferred.prefix(3))
        case .expanded:
            let remaining = Unit3AcademicCategory.allCases.filter {
                !preferred.contains($0)
            }
            return preferred + remaining
        }
    }

    private func clearResult() {
        classification = nil
        resource = nil
        resourceSource = nil
        errorMessage = nil
        historyMessage = nil
        suggestedCategories = []
        needsCategorySelection = false
        isManualSelection = false
    }
}
