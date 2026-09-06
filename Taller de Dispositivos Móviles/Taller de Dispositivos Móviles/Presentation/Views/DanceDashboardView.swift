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
                        Label(statusMessage, systemImage: "leaf.fill")
                            .font(.footnote)
                            .foregroundStyle(AutumnTheme.primaryText)
                            .listRowBackground(AutumnTheme.statusBackground)
                    }
                }

                Section {
                    ForEach(viewModel.classes) { danceClass in
                        HStack(spacing: 12) {
                            Image(systemName: "calendar")
                                .foregroundStyle(AutumnTheme.maple)
                                .frame(width: 34, height: 34)
                                .background(AutumnTheme.surfaceStrong, in: Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(danceClass.discipline)
                                    .font(.headline)
                                    .foregroundStyle(AutumnTheme.primaryText)
                                Text("\(danceClass.schedule) · \(danceClass.room)")
                                    .font(.subheadline)
                                    .foregroundStyle(AutumnTheme.secondaryText)
                                Text("Duración: \(danceClass.durationMinutes) minutos")
                                    .font(.caption)
                                    .foregroundStyle(AutumnTheme.secondaryText)
                            }
                        }
                        .padding(.vertical, 5)
                        .listRowBackground(AutumnTheme.surface)
                        .listRowSeparatorTint(AutumnTheme.surfaceStrong)
                    }
                } header: {
                    sectionHeader("Clases", icon: "calendar")
                }

                if let currentClass = viewModel.currentClass {
                    Section {
                        ForEach(viewModel.students) { student in
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(student.name)
                                        .font(.headline)
                                        .foregroundStyle(AutumnTheme.primaryText)

                                    Text(viewModel.attendanceStatus(for: student)?.rawValue ?? "Sin registrar")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(
                                            attendanceColor(
                                                for: viewModel.attendanceStatus(for: student)
                                            )
                                        )
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
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(AutumnTheme.moss)
                                        .padding(6)
                                        .background(AutumnTheme.moss.opacity(0.10), in: Circle())
                                }
                                .accessibilityLabel("Registrar asistencia de \(student.name)")
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(AutumnTheme.surface)
                            .listRowSeparatorTint(AutumnTheme.surfaceStrong)
                        }
                    } header: {
                        sectionHeader("Asistencia · \(currentClass.discipline)", icon: "checkmark.circle")
                    }
                }

                Section {
                    if viewModel.progress.isEmpty {
                        Text("Aún no hay datos de progreso descargados.")
                            .foregroundStyle(AutumnTheme.secondaryText)
                            .listRowBackground(AutumnTheme.surface)
                    } else {
                        ForEach(viewModel.progress) { progress in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text("Semana \(progress.week)")
                                        .font(.headline)
                                        .foregroundStyle(AutumnTheme.primaryText)

                                    Spacer()

                                    Text("\(progress.trainingHours, specifier: "%.1f") h")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(AutumnTheme.goldenLeaf)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 5)
                                        .background(AutumnTheme.goldenLeaf.opacity(0.12), in: Capsule())
                                }

                                Text(progress.discipline)
                                    .font(.caption)
                                    .foregroundStyle(AutumnTheme.maple)

                                Text(progress.summary)
                                    .font(.subheadline)
                                    .foregroundStyle(AutumnTheme.secondaryText)
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(AutumnTheme.surface)
                            .listRowSeparatorTint(AutumnTheme.surfaceStrong)
                        }
                    }
                } header: {
                    sectionHeader("Progreso · Camila Soto", icon: "chart.line.uptrend.xyaxis")
                }

                Section {
                    if viewModel.feedback.isEmpty {
                        Text("Sin retroalimentación registrada.")
                            .foregroundStyle(AutumnTheme.secondaryText)
                            .listRowBackground(AutumnTheme.surface)
                    } else {
                        ForEach(viewModel.feedback) { feedback in
                            VStack(alignment: .leading, spacing: 7) {
                                Text(feedback.technicalCorrection)
                                    .font(.headline)
                                    .foregroundStyle(AutumnTheme.primaryText)
                                feedbackLine("Proyección", feedback.projectionNote)
                                feedbackLine("Postura", feedback.postureNote)
                                feedbackLine("Expresión", feedback.expressiveNote)
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(AutumnTheme.surface)
                            .listRowSeparatorTint(AutumnTheme.surfaceStrong)
                        }
                    }
                } header: {
                    sectionHeader("Retroalimentación artística", icon: "quote.bubble")
                }

                Section {
                    if viewModel.media.isEmpty {
                        Text("Sin registros audiovisuales descargados.")
                            .foregroundStyle(AutumnTheme.secondaryText)
                            .listRowBackground(AutumnTheme.surface)
                    } else {
                        ForEach(viewModel.media) { media in
                            HStack(spacing: 12) {
                                Image(systemName: "video.fill")
                                    .foregroundStyle(AutumnTheme.persimmon)
                                    .frame(width: 34, height: 34)
                                    .background(AutumnTheme.persimmon.opacity(0.12), in: Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(media.localFileName)
                                        .font(.headline)
                                        .foregroundStyle(AutumnTheme.primaryText)
                                    Text(media.tags.joined(separator: " · "))
                                        .font(.caption)
                                        .foregroundStyle(AutumnTheme.secondaryText)
                                }
                            }
                            .padding(.vertical, 5)
                            .listRowBackground(AutumnTheme.surface)
                            .listRowSeparatorTint(AutumnTheme.surfaceStrong)
                        }
                    }
                } header: {
                    sectionHeader("Registro audiovisual", icon: "video")
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AutumnTheme.background)
            .navigationTitle("Seguimiento")
            .toolbarBackground(AutumnTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.synchronize()
                        }
                    } label: {
                        Label("Sincronizar", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .tint(AutumnTheme.maple)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Actualizando datos...")
                        .tint(AutumnTheme.maple)
                        .foregroundStyle(AutumnTheme.primaryText)
                        .padding()
                        .background(AutumnTheme.surface, in: RoundedRectangle(cornerRadius: 14))
                        .shadow(color: AutumnTheme.primaryText.opacity(0.10), radius: 10, y: 4)
                }
            }
        }
        .tint(AutumnTheme.maple)
        .task {
            await viewModel.loadDashboard()
        }
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(AutumnTheme.maple)
            .textCase(nil)
    }

    private func feedbackLine(_ title: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 5) {
            Text("\(title):")
                .fontWeight(.semibold)
                .foregroundStyle(AutumnTheme.moss)
            Text(value)
                .foregroundStyle(AutumnTheme.secondaryText)
        }
        .font(.subheadline)
    }

    private func attendanceColor(for status: AttendanceStatus?) -> Color {
        switch status {
        case .attended:
            AutumnTheme.moss
        case .late:
            AutumnTheme.goldenLeaf
        case .absent:
            AutumnTheme.maple
        case .injury, .medicalObservation:
            AutumnTheme.persimmon
        case nil:
            AutumnTheme.secondaryText
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
