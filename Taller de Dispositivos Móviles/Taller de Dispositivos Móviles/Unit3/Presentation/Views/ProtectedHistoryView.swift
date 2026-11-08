import SwiftUI

struct ProtectedHistoryView: View {
    @ObservedObject private var viewModel: ProtectedHistoryViewModel
    @State private var confirmDeletion = false

    init(viewModel: ProtectedHistoryViewModel) {
        self.viewModel = viewModel
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
        ScrollView {
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

                technicalEvidenceSection
            }
            .padding(24)
            .frame(maxWidth: 520)
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            viewModel.refresh()
        }
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

                    technicalEvidenceSection

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

    @ViewBuilder
    private var technicalEvidenceSection: some View {
        if let evidence = viewModel.technicalEvidence {
            VStack(alignment: .leading, spacing: 12) {
                Label("Evidencia técnica del cifrado", systemImage: "checkmark.shield")
                    .font(.headline)
                    .foregroundStyle(Unit3Theme.security)

                Text(evidence.algorithm)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Unit3Theme.secondaryText)

                HStack {
                    Text("Archivo cifrado")
                    Spacer()
                    Text("\(evidence.encryptedByteCount) bytes")
                }
                .font(.caption)

                Text("Contenido almacenado · Base64 (vista parcial)")
                    .font(.caption.bold())
                    .foregroundStyle(Unit3Theme.secondaryText)

                Text(evidence.encryptedBase64)
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        Unit3Theme.background,
                        in: RoundedRectangle(cornerRadius: 12)
                    )
                    .accessibilityLabel("Vista parcial del contenido cifrado en Base64.")

                Text("La clave de cifrado permanece en Keychain y no se muestra.")
                    .font(.caption2)
                    .foregroundStyle(Unit3Theme.secondaryText)

                if let decryptedJSON = evidence.decryptedJSON {
                    Divider()

                    Text("Contenido descifrado después de autenticar")
                        .font(.caption.bold())
                        .foregroundStyle(Unit3Theme.secondaryText)

                    Text(decryptedJSON)
                        .font(.caption.monospaced())
                        .textSelection(.enabled)
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Unit3Theme.security.opacity(0.06),
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .accessibilityLabel("Contenido descifrado del historial.")
                } else {
                    Text("Autentícate para visualizar la representación descifrada.")
                        .font(.caption)
                        .foregroundStyle(Unit3Theme.secondaryText)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Unit3Theme.surface,
                in: RoundedRectangle(cornerRadius: 18)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Unit3Theme.security.opacity(0.18), lineWidth: 1)
            }
        }
    }
}
