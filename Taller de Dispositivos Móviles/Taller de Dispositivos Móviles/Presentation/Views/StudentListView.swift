import SwiftUI

struct StudentListView: View {
    @StateObject private var viewModel: StudentListViewModel

    init(viewModel: StudentListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AutumnTheme.background
                    .ignoresSafeArea()

                Group {
                    if viewModel.isLoading && viewModel.students.isEmpty {
                        ProgressView("Cargando estudiantes...")
                            .tint(AutumnTheme.maple)
                            .foregroundStyle(AutumnTheme.primaryText)
                    } else if let errorMessage = viewModel.errorMessage,
                              viewModel.students.isEmpty {
                        ContentUnavailableView {
                            Label("Sin datos", systemImage: "exclamationmark.triangle")
                        } description: {
                            Text(errorMessage)
                        } actions: {
                            Button("Reintentar") {
                                Task {
                                    await viewModel.loadStudents()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(AutumnTheme.maple)
                        }
                        .foregroundStyle(AutumnTheme.primaryText)
                    } else {
                        List(viewModel.students) { student in
                            HStack(spacing: 14) {
                                Image(systemName: "person.fill")
                                    .font(.headline)
                                    .foregroundStyle(AutumnTheme.maple)
                                    .frame(width: 38, height: 38)
                                    .background(AutumnTheme.surfaceStrong, in: Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(student.name)
                                        .font(.headline)
                                        .foregroundStyle(AutumnTheme.primaryText)

                                    Text("Nivel técnico")
                                        .font(.caption)
                                        .foregroundStyle(AutumnTheme.secondaryText)
                                }

                                Spacer()

                                Text(student.technicalLevel.rawValue)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(levelColor(for: student.technicalLevel))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        levelColor(for: student.technicalLevel).opacity(0.12),
                                        in: Capsule()
                                    )
                            }
                            .padding(.vertical, 7)
                            .listRowBackground(AutumnTheme.surface)
                            .listRowSeparatorTint(AutumnTheme.surfaceStrong)
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
            }
            .navigationTitle("Estudiantes")
            .toolbarBackground(AutumnTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .tint(AutumnTheme.maple)
        .task {
            await viewModel.loadStudents()
        }
    }

    private func levelColor(for level: TechnicalLevel) -> Color {
        switch level {
        case .initial:
            AutumnTheme.goldenLeaf
        case .intermediate:
            AutumnTheme.persimmon
        case .advanced:
            AutumnTheme.moss
        }
    }
}

#Preview {
    let repository = StudentRepositoryImpl(
        localDataSource: LocalStudentDataSource(),
        remoteDataSource: RemoteStudentDataSource()
    )

    StudentListView(
        viewModel: StudentListViewModel(repository: repository)
    )
}
