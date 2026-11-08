import SwiftUI

struct ProtectedHistoryView: View {
    @StateObject private var viewModel: ProtectedHistoryViewModel
    @State private var confirmDeletion = false

    init(viewModel: ProtectedHistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Unit3Theme.background
                .ignoresSafeArea()

            if viewModel.isUnlocked {
                unlockedContent
            } else {
                lockedContent
            }
        }
        .navigationTitle("Historial protegido")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.lock()
        }
        .alert("Eliminar historial", isPresented: $confirmDeletion) {
            Button("Cancelar", role: .cancel) {}
            Button("Eliminar", role: .destructive) {
                viewModel.clearHistory()
            }
        } message: {
            Text("Se eliminarán todas las consultas guardadas en el almacenamiento cifrado.")
        }
    }

    private var lockedContent: some View {
        VStack(spacing: 18) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 58))
                .foregroundStyle(Unit3Theme.security)
                .accessibilityHidden(true)

            Text("Historial cifrado")
                .font(.title2.bold())

            Text("Las consultas guardadas se cifran con AES-GCM. La clave permanece en Keychain y el acceso requiere autenticación del dispositivo.")
                .font(.subheadline)
                .foregroundStyle(Unit3Theme.secondaryText)
                .multilineTextAlignment(.center)

            Label(viewModel.authenticationMethodName, systemImage: "person.badge.key")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Unit3Theme.security)

            Button {
                Task {
                    await viewModel.unlock()
                }
            } label: {
                Label(
                    viewModel.isAuthenticating ? "Verificando..." : "Desbloquear historial",
                    systemImage: "lock.open"
                )
                .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .tint(Unit3Theme.security)
            .disabled(viewModel.isAuthenticating)
            .accessibilityHint("Solicita biometría o autenticación del dispositivo.")

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(Unit3Theme.warning)
            }
        }
        .padding(24)
        .frame(maxWidth: 520)
    }

    private var unlockedContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label("Desbloqueado", systemImage: "lock.open.fill")
                        .font(.headline)
                        .foregroundStyle(Unit3Theme.security)

                    Spacer()

                    Button("Bloquear") {
                        viewModel.lock()
                    }
                    .buttonStyle(.bordered)
                    .frame(minHeight: 44)
                }

                if viewModel.entries.isEmpty {
                    ContentUnavailableView(
                        "Sin consultas guardadas",
                        systemImage: "lock.doc",
                        description: Text("Guarda una orientación desde la pantalla principal para crear tu historial cifrado.")
                    )
                } else {
                    ForEach(viewModel.entries) { entry in
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                entry.category.displayName,
                                systemImage: entry.category.systemImage
                            )
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Unit3Theme.security)

                            Text(entry.query)
                                .font(.body)

                            Text(
                                entry.createdAt.formatted(
                                    date: .abbreviated,
                                    time: .shortened
                                )
                            )
                            .font(.caption)
                            .foregroundStyle(Unit3Theme.secondaryText)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 16))
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(
                            "\(entry.category.displayName). \(entry.query). Guardada \(entry.createdAt.formatted(date: .abbreviated, time: .shortened))."
                        )
                    }

                    Button(role: .destructive) {
                        confirmDeletion = true
                    } label: {
                        Label("Eliminar historial", systemImage: "trash")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(20)
        }
        .onAppear {
            viewModel.refresh()
        }
    }
}
