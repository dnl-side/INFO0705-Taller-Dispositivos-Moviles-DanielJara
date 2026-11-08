import SwiftUI

struct Unit3OrientationView: View {
    @ObservedObject private var viewModel: Unit3OrientationViewModel
    @State private var queryText = ""
    @FocusState private var queryFocused: Bool

    private let examples = [
        "¿Ya publicaron la nota del último trabajo?",
        "Necesito un certificado de alumno regular",
        "Mi contraseña funciona pero el aula no abre"
    ]

    init(viewModel: Unit3OrientationViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Unit3Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    statusCard
                    queryCard
                    examplesSection

                    if viewModel.isLoading {
                        ProgressView("Procesando consulta...")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .accessibilityLabel("Procesando consulta")
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .foregroundStyle(Unit3Theme.warning)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 16))
                    }

                    if viewModel.needsCategorySelection {
                        categorySelectionCard
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
        .navigationTitle("Orientación")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Motor")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Unit3Theme.secondaryText)

                    Text(viewModel.classifierEngineName)
                        .font(.subheadline.weight(.semibold))
                }

                Spacer()

                Text(viewModel.usesCoreML ? "ON-DEVICE" : "RESPALDO")
                    .font(.caption2.bold())
                    .foregroundStyle(viewModel.usesCoreML ? Unit3Theme.security : Unit3Theme.warning)
            }

            Divider()

            HStack {
                Label(
                    viewModel.connectivityStatus.displayName,
                    systemImage: viewModel.connectivityStatus == .offline ? "wifi.slash" : "wifi"
                )

                Spacer()

                Text(viewModel.resourceSource?.displayName ?? "Sin consulta")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(Unit3Theme.secondaryText)

            HStack {
                Text("Variante UX")
                Spacer()
                Text(viewModel.experimentVariant.displayName)
            }
            .font(.caption)
            .foregroundStyle(Unit3Theme.secondaryText)
        }
        .padding(16)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "Motor \(viewModel.classifierEngineName). Conectividad \(viewModel.connectivityStatus.displayName). Origen de datos \(viewModel.resourceSource?.displayName ?? "sin consulta"). Variante \(viewModel.experimentVariant.displayName)."
        )
    }

    private var queryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("¿Qué necesitas resolver?", systemImage: "text.bubble")
                .font(.headline)

            TextField(
                "Ejemplo: Necesito revisar una evaluación",
                text: $queryText,
                axis: .vertical
            )
            .lineLimit(3...6)
            .textFieldStyle(.roundedBorder)
            .focused($queryFocused)
            .accessibilityLabel("Consulta académica")
            .accessibilityHint("Escribe brevemente lo que necesitas resolver.")

            HStack {
                Button("Limpiar") {
                    queryFocused = false
                    queryText = ""
                    viewModel.reset()
                }
                .buttonStyle(.bordered)
                .frame(minHeight: 44)
                .disabled(queryText.isEmpty)

                Spacer()

                Button {
                    queryFocused = false
                    Task {
                        await viewModel.submitQuery(queryText)
                    }
                } label: {
                    Label("Orientar", systemImage: "arrow.right.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(Unit3Theme.primary)
                .frame(minHeight: 44)
                .disabled(viewModel.isLoading)
                .accessibilityHint("Clasifica la consulta y recupera el recurso académico.")
            }
        }
        .padding(16)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 18))
    }

    private var examplesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Consultas de ejemplo")
                .font(.caption.bold())
                .foregroundStyle(Unit3Theme.secondaryText)

            ForEach(examples, id: \.self) { example in
                Button {
                    queryText = example
                    viewModel.reset()
                } label: {
                    HStack {
                        Text(example)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "arrow.up.left")
                            .accessibilityHidden(true)
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Unit3Theme.primary)
                .accessibilityLabel("Usar ejemplo: \(example)")
            }
        }
    }

    private var categorySelectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("La clasificación necesita confirmación", systemImage: "questionmark.circle")
                .font(.headline)

            Text("Selecciona la categoría que mejor representa tu consulta.")
                .font(.subheadline)
                .foregroundStyle(Unit3Theme.secondaryText)

            categoryGrid(viewModel.suggestedCategories)
        }
        .padding(16)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 18))
    }

    private func resultCard(
        classification: Unit3AcademicClassification,
        resource: Unit3AcademicResource
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: classification.category.systemImage)
                    .font(.title2)
                    .foregroundStyle(Unit3Theme.primary)
                    .frame(width: 44, height: 44)
                    .background(Unit3Theme.primary.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(classification.category.displayName)
                        .font(.headline)

                    Text(classificationDescription(classification))
                        .font(.caption)
                        .foregroundStyle(Unit3Theme.secondaryText)
                }
            }
            .accessibilityElement(children: .combine)

            Divider()

            Text(resource.title)
                .font(.title3.bold())

            Text(resource.summary)
                .font(.subheadline)
                .foregroundStyle(Unit3Theme.secondaryText)

            ForEach(Array(resource.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(index + 1)")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .frame(width: 26, height: 26)
                        .background(Unit3Theme.primary, in: Circle())
                        .accessibilityHidden(true)

                    Text(step)
                        .font(.subheadline)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Paso \(index + 1). \(step)")
            }

            Label(resource.channel, systemImage: "building.2")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Unit3Theme.primary)

            Button {
                Task {
                    await viewModel.saveCurrentResultToProtectedHistory()
                }
            } label: {
                Label("Guardar en historial protegido", systemImage: "lock.doc")
                    .frame(maxWidth: .infinity, minHeight: 44)
            }
            .buttonStyle(.borderedProminent)
            .tint(Unit3Theme.security)
            .accessibilityHint("Cifra y guarda esta consulta en el dispositivo.")

            if let historyMessage = viewModel.historyMessage {
                Text(historyMessage)
                    .font(.caption)
                    .foregroundStyle(Unit3Theme.secondaryText)
                    .accessibilityLabel(historyMessage)
            }

            if !viewModel.suggestedCategories.isEmpty && !viewModel.needsCategorySelection {
                Divider()
                Text("Otras categorías")
                    .font(.caption.bold())
                    .foregroundStyle(Unit3Theme.secondaryText)
                categoryGrid(Array(viewModel.suggestedCategories.prefix(4)))
            }
        }
        .padding(16)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 18))
    }

    private func categoryGrid(_ categories: [Unit3AcademicCategory]) -> some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 10
        ) {
            ForEach(categories) { category in
                Button {
                    Task {
                        await viewModel.selectCategory(category)
                    }
                } label: {
                    Label(category.displayName, systemImage: category.systemImage)
                        .font(.caption.weight(.semibold))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        .padding(.horizontal, 10)
                }
                .buttonStyle(.bordered)
                .tint(Unit3Theme.primary)
                .accessibilityLabel("Categoría \(category.displayName)")
            }
        }
    }

    private func classificationDescription(
        _ classification: Unit3AcademicClassification
    ) -> String {
        if viewModel.isManualSelection {
            return "Categoría confirmada manualmente"
        }

        return "Confianza CoreML: \(Int(classification.confidence * 100)) %"
    }
}
