import SwiftUI

struct DanceDashboardView: View {
    @StateObject private var viewModel: DanceDashboardViewModel

    init(viewModel: DanceDashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                if let statusMessage = viewModel.statusMessage {
                    Section {
                        Label(statusMessage, systemImage: "info.circle")
                            .font(.footnote)
                    }
                }

                Section("Clases") {
                    ForEach(viewModel.classes) { danceClass in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(danceClass.discipline)
                                .font(.headline)
                            Text("\(danceClass.schedule) · \(danceClass.room)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Duración: \(danceClass.durationMinutes) minutos")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }

                if let currentClass = viewModel.currentClass {
                    Section("Asistencia · \(currentClass.discipline)") {
                        ForEach(viewModel.students) { student in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(student.name)
                                        .font(.headline)
                                    Text(viewModel.attendanceStatus(for: student)?.rawValue ?? "Sin registrar")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                Spacer()

                                Menu {
                                    ForEach(AttendanceStatus.allCases, id: \.self) { status in
                                        Button(status.rawValue) {
                                            Task {
                                                await viewModel.setAttendance(status, for: student)
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                        .font(.title3)
                                }
                                .accessibilityLabel("Registrar asistencia de \(student.name)")
                            }
                        }
                    }
                }

                Section("Progreso · Camila Soto") {
                    if viewModel.progress.isEmpty {
                        Text("Aún no hay datos de progreso descargados.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.progress) { progress in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Semana \(progress.week) · \(progress.discipline)")
                                    .font(.headline)
                                Text(progress.summary)
                                Text("Entrenamiento: \(progress.trainingHours, specifier: "%.1f") h")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Retroalimentación artística") {
                    if viewModel.feedback.isEmpty {
                        Text("Sin retroalimentación registrada.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.feedback) { feedback in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(feedback.technicalCorrection)
                                    .font(.headline)
                                Text("Proyección: \(feedback.projectionNote)")
                                Text("Postura: \(feedback.postureNote)")
                                Text("Expresión: \(feedback.expressiveNote)")
                            }
                            .font(.subheadline)
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Registro audiovisual") {
                    if viewModel.media.isEmpty {
                        Text("Sin registros audiovisuales descargados.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.media) { media in
                            VStack(alignment: .leading, spacing: 4) {
                                Label(media.localFileName, systemImage: "video")
                                    .font(.headline)
                                Text(media.tags.joined(separator: " · "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Seguimiento")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.synchronize()
                        }
                    } label: {
                        Label("Sincronizar", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Actualizando datos...")
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .task {
            await viewModel.loadDashboard()
        }
    }
}

#Preview {
    let studentRepository = StudentRepositoryImpl(
        localDataSource: LocalStudentDataSource(),
        remoteDataSource: RemoteStudentDataSource()
    )
    let danceRepository = DanceRepositoryImpl(
        localDataSource: LocalDanceDataSource(),
        remoteDataSource: RemoteDanceDataSource()
    )

    DanceDashboardView(
        viewModel: DanceDashboardViewModel(
            studentRepository: studentRepository,
            danceRepository: danceRepository
        )
    )
}
