@MainActor
final class Unit2DependencyContainer {
    private let classifier: AcademicQueryClassifying
    private let resourceRepository: AcademicResourceRepository
    private let connectivityMonitor: ConnectivityMonitoring

    /// Función de inicialización empleada para componer las dependencias de la Unidad 2.
    init() {
        classifier = CoreMLAcademicQueryClassifier(
            fallback: KeywordAcademicQueryClassifier()
        )

        connectivityMonitor = NetworkConnectivityMonitor()

        resourceRepository = AcademicResourceRepositoryImpl(
            localDataSource: LocalAcademicResourceDataSource(),
            remoteDataSource: FirestoreAcademicResourceDataSource()
        )
    }

    /// Función empleada para construir el ViewModel principal de UNIACC Orienta.
    func makeUNIACCOrientaViewModel() -> UNIACCOrientaViewModel {
        UNIACCOrientaViewModel(
            classifier: classifier,
            resourceRepository: resourceRepository,
            connectivityMonitor: connectivityMonitor
        )
    }
}
