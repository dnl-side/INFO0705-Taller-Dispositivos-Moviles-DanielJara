import SwiftUI

struct StudentListView: View {
    @StateObject private var viewModel: StudentListViewModel

    init(viewModel: StudentListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.students.isEmpty {
                    ProgressView("Cargando estudiantes...")
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
                    }
                } else {
                    List(viewModel.students) { student in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(student.name)
                                .font(.headline)

                            Text("Nivel técnico: \(student.technicalLevel.rawValue)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Estudiantes")
        }
        .task {
            await viewModel.loadStudents()
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
