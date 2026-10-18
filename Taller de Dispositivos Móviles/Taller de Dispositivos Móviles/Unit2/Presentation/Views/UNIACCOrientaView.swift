import SwiftUI

struct UNIACCOrientaView: View {
    @StateObject private var viewModel: UNIACCOrientaViewModel
    @State private var queryText = ""
    @FocusState private var queryFieldFocused: Bool
    @State private var queryFieldID = UUID()

    private let examples = [
        "¿Ya publicaron la nota del último trabajo?",
        "¿Cómo puedo acreditar que actualmente estudio aquí?",
        "Mi contraseña funciona pero el aula no abre"
    ]

    /// Función de inicialización empleada para recibir el ViewModel de orientación académica.
    init(viewModel: UNIACCOrientaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /// Propiedad empleada para definir la interfaz principal del microproyecto de la Unidad 2.
    var body: some View {
        ZStack {
            Unit2Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    classifierStatus
                    queryCard
                    examplesSection

                    if viewModel.isLoading {
                        ProgressView("Procesando consulta...")
                            .tint(Unit2Theme.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .foregroundStyle(Unit2Theme.secondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                Unit2Theme.secondary.opacity(0.08),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                    }

                    if let classification = viewModel.classification,
                       let resource = viewModel.resource {
                        resultCard(
                            classification: classification,
                            resource: resource
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Unidad 2")
        .navigationBarTitleDisplayMode(.inline)
        .tint(Unit2Theme.primary)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("UNIACC Orienta")
                .font(.largeTitle.bold())
                .foregroundStyle(Unit2Theme.primaryText)

            Text("Orientación móvil para encontrar el servicio académico adecuado a partir de una consulta breve.")
                .font(.subheadline)
                .foregroundStyle(Unit2Theme.secondaryText)
        }
    }

    private var classifierStatus: some View {
        HStack(spacing: 12) {
            Image(systemName: viewModel.usesCoreML ? "brain.head.profile.fill" : "hammer.fill")
                .foregroundStyle(viewModel.usesCoreML ? Color.green : Unit2Theme.accent)
                .frame(width: 38, height: 38)
                .background(
                    (viewModel.usesCoreML ? Color.green : Unit2Theme.accent).opacity(0.10),
                    in: RoundedRectangle(cornerRadius: 12)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text("Motor de clasificación")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Unit2Theme.secondaryText)

                Text(viewModel.classifierEngineName)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Unit2Theme.primaryText)
            }

            Spacer()

            Text(viewModel.usesCoreML ? "ON-DEVICE" : "BASE")
                .font(.caption2.bold())
                .foregroundStyle(viewModel.usesCoreML ? Color.green : Unit2Theme.accent)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(
                    (viewModel.usesCoreML ? Color.green : Unit2Theme.accent).opacity(0.10),
                    in: Capsule()
                )
        }
        .padding(14)
        .background(Unit2Theme.surface, in: RoundedRectangle(cornerRadius: 16))
    }

    private var queryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("¿En qué necesitas orientación?", systemImage: "text.bubble")
                .font(.headline)
                .foregroundStyle(Unit2Theme.primaryText)

            TextField(
                "Ejemplo: Necesito solicitar un certificado",
                text: $queryText,
                axis: .vertical
            )
            .lineLimit(3...6)
            .textFieldStyle(.roundedBorder)
            .focused($queryFieldFocused)
            .id(queryFieldID)

            HStack {
                if !queryText.isEmpty {
                    Button("Limpiar") {
                        clearQuery()
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                Button {
                    submitCurrentQuery()
                } label: {
                    Label("Orientar", systemImage: "arrow.right.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(Unit2Theme.primary)
                .disabled(viewModel.isLoading)
            }
        }
        .padding(18)
        .background(Unit2Theme.surface, in: RoundedRectangle(cornerRadius: 20))
    }

    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Consultas de ejemplo")
                .font(.caption.weight(.bold))
                .foregroundStyle(Unit2Theme.secondaryText)

            ForEach(examples, id: \.self) { example in
                Button {
                    queryFieldFocused = false
                    queryText = example
                    viewModel.reset()
                    queryFieldID = UUID()
                } label: {
                    HStack {
                        Text(example)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: "arrow.up.left")
                    }
                    .foregroundStyle(Unit2Theme.primary)
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private func resultCard(
        classification: AcademicClassification,
        resource: AcademicResource
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.lastProcessedQuery.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Consulta procesada")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Unit2Theme.secondaryText)

                    Text(viewModel.lastProcessedQuery)
                        .font(.subheadline)
                        .foregroundStyle(Unit2Theme.primaryText)
                }

                Divider()
            }

            HStack(spacing: 12) {
                Image(systemName: classification.category.systemImage)
                    .font(.title2)
                    .foregroundStyle(Unit2Theme.secondary)
                    .frame(width: 44, height: 44)
                    .background(
                        Unit2Theme.secondary.opacity(0.10),
                        in: RoundedRectangle(cornerRadius: 14)
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(classification.category.displayName)
                        .font(.headline)
                        .foregroundStyle(Unit2Theme.primaryText)

                    Text(
                        "\(viewModel.usesCoreML ? "Confianza CoreML" : "Coincidencia preliminar"): \(Int(classification.confidence * 100)) %"
                    )
                    .font(.caption)
                    .foregroundStyle(Unit2Theme.secondaryText)
                }
            }

            Divider()

            Text(resource.title)
                .font(.title3.bold())
                .foregroundStyle(Unit2Theme.primaryText)

            Text(resource.summary)
                .font(.subheadline)
                .foregroundStyle(Unit2Theme.secondaryText)

            VStack(alignment: .leading, spacing: 9) {
                ForEach(Array(resource.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .background(Unit2Theme.primary, in: Circle())

                        Text(step)
                            .font(.subheadline)
                            .foregroundStyle(Unit2Theme.primaryText)
                    }
                }
            }

            Label(resource.channel, systemImage: "building.2")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Unit2Theme.primary)
        }
        .padding(18)
        .background(Unit2Theme.surface, in: RoundedRectangle(cornerRadius: 20))
    }

    /// Función empleada para confirmar el texto visible después de liberar el foco y enviarlo al ViewModel.
    private func submitCurrentQuery() {
        queryFieldFocused = false

        Task { @MainActor in
            await Task.yield()
            await viewModel.submitQuery(queryText)
        }
    }

    /// Función empleada para eliminar de forma explícita tanto el texto visible como el resultado anterior.
    private func clearQuery() {
        queryFieldFocused = false
        queryText = ""
        viewModel.reset()
        queryFieldID = UUID()
    }
}

#Preview {
    UNIACCOrientaView(
        viewModel: Unit2DependencyContainer().makeUNIACCOrientaViewModel()
    )
}
