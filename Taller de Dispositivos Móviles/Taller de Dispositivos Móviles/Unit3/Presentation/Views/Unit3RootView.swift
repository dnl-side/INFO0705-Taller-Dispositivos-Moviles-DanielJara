import SwiftUI

struct Unit3RootView: View {
    @StateObject private var orientationViewModel: Unit3OrientationViewModel
    @StateObject private var historyViewModel: ProtectedHistoryViewModel
    @StateObject private var performanceTracker: Unit3PerformanceTracker

    init() {
        let container = Unit3DependencyContainer()

        _orientationViewModel = StateObject(
            wrappedValue: container.makeOrientationViewModel()
        )
        _historyViewModel = StateObject(
            wrappedValue: container.makeProtectedHistoryViewModel()
        )
        _performanceTracker = StateObject(
            wrappedValue: container.performanceTracker
        )
    }

    var body: some View {
        ZStack {
            Unit3Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    technologySummary

                    NavigationLink {
                        Unit3OrientationView(viewModel: orientationViewModel)
                    } label: {
                        featureCard(
                            title: "Orientación académica",
                            subtitle: "CoreML, Firestore y funcionamiento offline",
                            icon: "brain.head.profile",
                            accent: Unit3Theme.primary
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Abre la orientación académica de la Unidad 3.")

                    NavigationLink {
                        ProtectedHistoryView(viewModel: historyViewModel)
                    } label: {
                        featureCard(
                            title: "Historial protegido",
                            subtitle: "AES-GCM, Keychain y autenticación del dispositivo",
                            icon: "lock.shield",
                            accent: Unit3Theme.security
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Abre el historial cifrado y solicita autenticación.")

                    NavigationLink {
                        Unit3DiagnosticsView(tracker: performanceTracker)
                    } label: {
                        featureCard(
                            title: "Diagnóstico y rendimiento",
                            subtitle: "Métricas internas y signposts para Instruments",
                            icon: "gauge.with.dots.needle.67percent",
                            accent: Unit3Theme.performance
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Muestra tiempos medidos y guía de profiling.")

                    Text("La Unidad 3 se inicializa al entrar a esta pantalla, evitando mantener sus monitores y servicios activos mientras se utilizan otras unidades.")
                        .font(.footnote)
                        .foregroundStyle(Unit3Theme.secondaryText)
                        .accessibilityLabel("Optimización de ciclo de vida. Los servicios de la Unidad 3 se crean únicamente al ingresar a la unidad.")
                }
                .padding(20)
            }
        }
        .navigationTitle("Unidad 3")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await orientationViewModel.prepare()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("UNIACC Orienta Secure")
                .font(.largeTitle.bold())
                .foregroundStyle(Unit3Theme.primaryText)

            Text("Evolución del microproyecto centrada en optimización, seguridad, accesibilidad y mejora continua.")
                .font(.subheadline)
                .foregroundStyle(Unit3Theme.secondaryText)
        }
        .accessibilityElement(children: .combine)
    }

    private var technologySummary: some View {
        HStack(spacing: 10) {
            Label("CoreML", systemImage: "brain")
            Label("AES-GCM", systemImage: "lock")
            Label("Profiling", systemImage: "waveform.path.ecg")
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(Unit3Theme.primary)
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Tecnologías principales: CoreML, cifrado AES GCM y profiling.")
    }

    private func featureCard(
        title: String,
        subtitle: String,
        icon: String,
        accent: Color
    ) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(accent)
                .frame(width: 52, height: 52)
                .background(accent.opacity(0.10), in: RoundedRectangle(cornerRadius: 16))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Unit3Theme.primaryText)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Unit3Theme.secondaryText)
                    .multilineTextAlignment(.leading)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .foregroundStyle(accent)
                .accessibilityHidden(true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 88)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(accent.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle)")
    }
}
