import SwiftUI

struct UnitSelectionView: View {
    private let unit1StudentViewModel: StudentListViewModel
    private let unit1DashboardViewModel: DanceDashboardViewModel
    private let unit2ViewModel: UNIACCOrientaViewModel

    /// Función de inicialización empleada para recibir los ViewModels necesarios para abrir cada unidad.
    init(
        unit1StudentViewModel: StudentListViewModel,
        unit1DashboardViewModel: DanceDashboardViewModel,
        unit2ViewModel: UNIACCOrientaViewModel
    ) {
        self.unit1StudentViewModel = unit1StudentViewModel
        self.unit1DashboardViewModel = unit1DashboardViewModel
        self.unit2ViewModel = unit2ViewModel
    }

    /// Propiedad empleada para mostrar la pantalla inicial de selección entre Unidad 1 y Unidad 2.
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.96, green: 0.95, blue: 0.92)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Taller de Dispositivos Móviles")
                                .font(.largeTitle.bold())
                                .foregroundStyle(Color(red: 0.20, green: 0.18, blue: 0.17))

                            Text("Selecciona la unidad que deseas revisar.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        NavigationLink {
                            DanceSchoolView(
                                studentViewModel: unit1StudentViewModel,
                                dashboardViewModel: unit1DashboardViewModel
                            )
                        } label: {
                            UnitSelectionCard(
                                unit: "Unidad 1",
                                title: "Escuela de Danza",
                                description: "MVVM, Repository, seguimiento de estudiantes y funcionamiento offline.",
                                icon: "figure.dance",
                                accent: Color(red: 0.66, green: 0.30, blue: 0.20)
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            UNIACCOrientaView(viewModel: unit2ViewModel)
                        } label: {
                            UnitSelectionCard(
                                unit: "Unidad 2",
                                title: "UNIACC Orienta",
                                description: "Base del microproyecto con clasificación de consultas y recursos académicos.",
                                icon: "sparkles.rectangle.stack",
                                accent: Color(red: 0.18, green: 0.43, blue: 0.63)
                            )
                        }
                        .buttonStyle(.plain)

                        Text("Cada unidad mantiene su arquitectura y dominio de forma independiente dentro del mismo proyecto.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    .padding(24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct UnitSelectionCard: View {
    let unit: String
    let title: String
    let description: String
    let icon: String
    let accent: Color

    /// Propiedad empleada para representar visualmente una unidad disponible dentro del selector.
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(accent)
                .frame(width: 52, height: 52)
                .background(accent.opacity(0.12), in: RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 5) {
                Text(unit.uppercased())
                    .font(.caption.weight(.bold))
                    .foregroundStyle(accent)

                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(Color(red: 0.20, green: 0.18, blue: 0.17))

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(accent)
        }
        .padding(18)
        .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 22))
        .overlay {
            RoundedRectangle(cornerRadius: 22)
                .stroke(accent.opacity(0.22), lineWidth: 1)
        }
    }
}

#Preview {
    let unit1 = Unit1DependencyContainer()
    let unit2 = Unit2DependencyContainer()

    UnitSelectionView(
        unit1StudentViewModel: unit1.makeStudentListViewModel(),
        unit1DashboardViewModel: unit1.makeDanceDashboardViewModel(),
        unit2ViewModel: unit2.makeUNIACCOrientaViewModel()
    )
}
