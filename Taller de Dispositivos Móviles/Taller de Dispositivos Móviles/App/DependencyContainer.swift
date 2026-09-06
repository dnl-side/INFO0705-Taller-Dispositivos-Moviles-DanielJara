@MainActor
final class DependencyContainer {
    let studentRepository: StudentRepository
    let danceRepository: DanceRepository

    /// Función de inicialización empleada para crear los repositorios y conectar sus fuentes de datos.
    init() {
        studentRepository = StudentRepositoryImpl(
            localDataSource: LocalStudentDataSource(),
            remoteDataSource: RemoteStudentDataSource()
        )

        danceRepository = DanceRepositoryImpl(
            localDataSource: LocalDanceDataSource(),
            remoteDataSource: RemoteDanceDataSource()
        )
    }

    /// Función empleada para construir el ViewModel de la lista de estudiantes con su repositorio.
    func makeStudentListViewModel() -> StudentListViewModel {
        StudentListViewModel(repository: studentRepository)
    }

    /// Función empleada para construir el ViewModel de seguimiento con los repositorios que necesita.
    func makeDanceDashboardViewModel() -> DanceDashboardViewModel {
        DanceDashboardViewModel(
            studentRepository: studentRepository,
            danceRepository: danceRepository
        )
    }
}
