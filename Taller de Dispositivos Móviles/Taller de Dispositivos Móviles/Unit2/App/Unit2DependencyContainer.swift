@MainActor
final class Unit2DependencyContainer {
    private let classifier: AcademicQueryClassifying
    private let resourceRepository: AcademicResourceRepository

    /// Función de inicialización empleada para componer las dependencias de la Unidad 2.
    init() {
        classifier = KeywordAcademicQueryClassifier()
        resourceRepository = AcademicResourceRepositoryImpl(
            localDataSource: LocalAcademicResourceDataSource()
        )
    }

    /// Función empleada para construir el ViewModel principal de UNIACC Orienta.
    func makeUNIACCOrientaViewModel() -> UNIACCOrientaViewModel {
        UNIACCOrientaViewModel(
            classifier: classifier,
            resourceRepository: resourceRepository
        )
    }
}
