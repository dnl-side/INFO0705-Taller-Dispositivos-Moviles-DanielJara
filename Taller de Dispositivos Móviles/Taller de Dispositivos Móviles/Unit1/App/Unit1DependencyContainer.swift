@MainActor
final class Unit1DependencyContainer {
    let studentRepository: StudentRepository
    let danceRepository: DanceRepository

    /// Función de inicialización empleada para crear los repositorios y conectar las fuentes de datos de la Unidad 1.
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

    /// Función empleada para construir el ViewModel de la lista de estudiantes.
    func makeStudentListViewModel() -> StudentListViewModel {
        StudentListViewModel(repository: studentRepository)
    }

    /// Función empleada para construir el ViewModel de seguimiento de la escuela de danza.
    func makeDanceDashboardViewModel() -> DanceDashboardViewModel {
        DanceDashboardViewModel(
            studentRepository: studentRepository,
            danceRepository: danceRepository
        )
    }
}
