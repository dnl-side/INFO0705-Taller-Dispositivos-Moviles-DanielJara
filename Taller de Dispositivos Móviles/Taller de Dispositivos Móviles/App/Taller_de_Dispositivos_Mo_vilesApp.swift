import SwiftUI

@main
struct Taller_de_Dispositivos_Mo_vilesApp: App {
    private let container: DependencyContainer
    private let studentViewModel: StudentListViewModel
    private let dashboardViewModel: DanceDashboardViewModel

    init() {
        let container = DependencyContainer()
        self.container = container
        studentViewModel = container.makeStudentListViewModel()
        dashboardViewModel = container.makeDanceDashboardViewModel()
    }

    var body: some Scene {
        WindowGroup {
            DanceSchoolView(
                studentViewModel: studentViewModel,
                dashboardViewModel: dashboardViewModel
            )
        }
    }
}
