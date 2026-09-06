import SwiftUI

@main
struct Taller_de_Dispositivos_Mo_vilesApp: App {
    private let viewModel: StudentListViewModel

    init() {
        let localDataSource = LocalStudentDataSource()
        let remoteDataSource = RemoteStudentDataSource()
        let repository = StudentRepositoryImpl(
            localDataSource: localDataSource,
            remoteDataSource: remoteDataSource
        )

        viewModel = StudentListViewModel(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            StudentListView(viewModel: viewModel)
        }
    }
}
