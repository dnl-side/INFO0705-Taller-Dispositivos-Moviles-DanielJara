@MainActor
final class DependencyContainer {
    let studentRepository: StudentRepository
    let danceRepository: DanceRepository

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

    func makeStudentListViewModel() -> StudentListViewModel {
        StudentListViewModel(repository: studentRepository)
    }

    func makeDanceDashboardViewModel() -> DanceDashboardViewModel {
        DanceDashboardViewModel(
            studentRepository: studentRepository,
            danceRepository: danceRepository
        )
    }
}
