@MainActor
final class Unit3DependencyContainer {
    let performanceTracker: Unit3PerformanceTracker

    private let classifier: Unit3QueryClassifying
    private let resourceRepository: Unit3AcademicResourceRepository
    private let historyRepository: Unit3ProtectedHistoryRepository
    private let biometricAuthenticator: Unit3BiometricAuthenticating
    private let analyticsTracker: Unit3AnalyticsTracking
    private let experimentProvider: Unit3ExperimentProviding
    private let connectivityMonitor: Unit3ConnectivityMonitoring

    init() {
        performanceTracker = Unit3PerformanceTracker()

        classifier = Unit3CoreMLAcademicQueryClassifier(
            fallback: Unit3KeywordAcademicQueryClassifier()
        )

        connectivityMonitor = Unit3NetworkConnectivityMonitor()

        resourceRepository = Unit3AcademicResourceRepositoryImpl(
            localDataSource: Unit3LocalAcademicResourceDataSource(),
            remoteDataSource: Unit3FirestoreAcademicResourceDataSource()
        )

        historyRepository = EncryptedProtectedHistoryRepository()
        biometricAuthenticator = LocalBiometricAuthenticationService()
        analyticsTracker = FirebaseUnit3AnalyticsTracker()
        experimentProvider = FirebaseUnit3ExperimentService()
    }

    func makeOrientationViewModel() -> Unit3OrientationViewModel {
        Unit3OrientationViewModel(
            classifier: classifier,
            resourceRepository: resourceRepository,
            historyRepository: historyRepository,
            connectivityMonitor: connectivityMonitor,
            analyticsTracker: analyticsTracker,
            experimentProvider: experimentProvider,
            performanceTracker: performanceTracker
        )
    }

    func makeProtectedHistoryViewModel() -> ProtectedHistoryViewModel {
        ProtectedHistoryViewModel(
            historyRepository: historyRepository,
            biometricAuthenticator: biometricAuthenticator,
            analyticsTracker: analyticsTracker,
            performanceTracker: performanceTracker
        )
    }
}
