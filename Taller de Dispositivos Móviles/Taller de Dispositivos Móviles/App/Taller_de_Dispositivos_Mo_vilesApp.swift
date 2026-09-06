import SwiftUI

@main
struct Taller_de_Dispositivos_Mo_vilesApp: App {
    private let container: DependencyContainer
    private let studentViewModel: StudentListViewModel
    private let dashboardViewModel: DanceDashboardViewModel

    /// Función de inicialización empleada para preparar las dependencias y los ViewModels principales de la aplicación.
    init() {
        let container = DependencyContainer()
        self.container = container
        studentViewModel = container.makeStudentListViewModel()
        dashboardViewModel = container.makeDanceDashboardViewModel()
    }

    /// Propiedad empleada para definir la vista principal que se muestra al iniciar la aplicación.
    var body: some Scene {
        WindowGroup {
            DanceSchoolView(
                studentViewModel: studentViewModel,
                dashboardViewModel: dashboardViewModel
            )
        }
    }
}
