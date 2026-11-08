import Combine
import Foundation

@MainActor
final class ProtectedHistoryViewModel: ObservableObject {
    @Published private(set) var entries: [ProtectedHistoryEntry] = []
    @Published private(set) var isUnlocked = false
    @Published private(set) var isAuthenticating = false
    @Published private(set) var errorMessage: String?

    private let historyRepository: Unit3ProtectedHistoryRepository
    private let biometricAuthenticator: Unit3BiometricAuthenticating
    private let analyticsTracker: Unit3AnalyticsTracking
    private let performanceTracker: Unit3PerformanceTracker

    init(
        historyRepository: Unit3ProtectedHistoryRepository,
        biometricAuthenticator: Unit3BiometricAuthenticating,
        analyticsTracker: Unit3AnalyticsTracking,
        performanceTracker: Unit3PerformanceTracker
    ) {
        self.historyRepository = historyRepository
        self.biometricAuthenticator = biometricAuthenticator
        self.analyticsTracker = analyticsTracker
        self.performanceTracker = performanceTracker
    }

    var authenticationMethodName: String {
        biometricAuthenticator.methodName
    }

    func unlock() async {
        guard !isAuthenticating else { return }

        isAuthenticating = true
        errorMessage = nil

        defer {
            isAuthenticating = false
        }

        do {
            try await biometricAuthenticator.authenticate(
                reason: "Desbloquea tu historial académico protegido."
            )

            entries = try await performanceTracker.measure(.protectedHistoryLoad) {
                try historyRepository.entries()
            }

            isUnlocked = true
            analyticsTracker.track(.historyUnlocked, parameters: [:])
        } catch {
            isUnlocked = false
            entries = []
            errorMessage = "No fue posible desbloquear el historial."
        }
    }

    func refresh() {
        guard isUnlocked else { return }

        do {
            entries = try historyRepository.entries()
        } catch {
            errorMessage = "No fue posible actualizar el historial."
        }
    }

    func clearHistory() {
        guard isUnlocked else { return }

        do {
            try historyRepository.removeAll()
            entries = []
        } catch {
            errorMessage = "No fue posible eliminar el historial."
        }
    }

    func lock() {
        entries = []
        errorMessage = nil
        isUnlocked = false
    }
}
