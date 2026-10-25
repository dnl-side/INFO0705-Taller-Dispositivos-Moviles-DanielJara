import SwiftUI

@main
struct Taller_de_Dispositivos_Mo_vilesApp: App {
    private let unit1StudentViewModel: StudentListViewModel
    private let unit1DashboardViewModel: DanceDashboardViewModel
    private let unit2ViewModel: UNIACCOrientaViewModel

    /// Función de inicialización empleada para preparar las dependencias de ambas unidades.
    init() {
        _ = FirebaseBootstrapper.configureIfAvailable()

        let unit1Container = Unit1DependencyContainer()
        let unit2Container = Unit2DependencyContainer()

        unit1StudentViewModel = unit1Container.makeStudentListViewModel()
        unit1DashboardViewModel = unit1Container.makeDanceDashboardViewModel()
        unit2ViewModel = unit2Container.makeUNIACCOrientaViewModel()
    }

    /// Propiedad empleada para mostrar el selector principal de unidades al iniciar la aplicación.
    var body: some Scene {
        WindowGroup {
            UnitSelectionView(
                unit1StudentViewModel: unit1StudentViewModel,
                unit1DashboardViewModel: unit1DashboardViewModel,
                unit2ViewModel: unit2ViewModel
            )
        }
    }
}
