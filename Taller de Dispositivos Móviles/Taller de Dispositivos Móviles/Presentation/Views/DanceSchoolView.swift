import SwiftUI

struct DanceSchoolView: View {
    private let studentViewModel: StudentListViewModel
    private let dashboardViewModel: DanceDashboardViewModel

    init(
        studentViewModel: StudentListViewModel,
        dashboardViewModel: DanceDashboardViewModel
    ) {
        self.studentViewModel = studentViewModel
        self.dashboardViewModel = dashboardViewModel
    }

    var body: some View {
        TabView {
            StudentListView(viewModel: studentViewModel)
                .tabItem {
                    Label("Estudiantes", systemImage: "person.3")
                }

            DanceDashboardView(viewModel: dashboardViewModel)
                .tabItem {
                    Label("Seguimiento", systemImage: "chart.line.uptrend.xyaxis")
                }
        }
        .tint(AutumnTheme.maple)
        .toolbarBackground(AutumnTheme.surface, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
        .preferredColorScheme(.light)
    }
}
