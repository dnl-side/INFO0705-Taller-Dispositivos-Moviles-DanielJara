import Foundation
import SwiftUI

struct Unit3DiagnosticsView: View {
    @ObservedObject var tracker: Unit3PerformanceTracker

    var body: some View {
        ZStack {
            Unit3Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mediciones de sesión")
                            .font(.title2.bold())

                        Text("Estos tiempos complementan el profiling. La evidencia principal de CPU, memoria y red se obtiene con Instruments mediante los signposts Unit3Operation.")
                            .font(.subheadline)
                            .foregroundStyle(Unit3Theme.secondaryText)
                    }

                    HStack {
                        metricBadge(
                            title: "Muestras",
                            value: "\(tracker.samples.count)"
                        )

                        metricBadge(
                            title: "Operaciones",
                            value: "\(Set(tracker.samples.map(\.operation)).count)"
                        )
                    }

                    ForEach(Unit3PerformanceOperation.allCases) { operation in
                        operationCard(operation)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Label("Prueba con Instruments", systemImage: "waveform.path.ecg")
                            .font(.headline)

                        Text("En Xcode utiliza Product > Profile y registra Time Profiler o Points of Interest. Los intervalos Unit3Operation permiten localizar clasificación, carga de recursos y operaciones del historial cifrado.")
                            .font(.subheadline)
                            .foregroundStyle(Unit3Theme.secondaryText)

                        Text("Para la entrega se compararán recorridos equivalentes antes y después de cada optimización.")
                            .font(.caption)
                            .foregroundStyle(Unit3Theme.secondaryText)
                    }
                    .padding(16)
                    .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 18))

                    Button("Limpiar mediciones de sesión") {
                        tracker.clear()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .disabled(tracker.samples.isEmpty)
                }
                .padding(20)
            }
        }
        .navigationTitle("Rendimiento")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func metricBadge(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Unit3Theme.secondaryText)

            Text(value)
                .font(.title3.bold())
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 16))
        .accessibilityElement(children: .combine)
    }

    private func operationCard(
        _ operation: Unit3PerformanceOperation
    ) -> some View {
        let latest = tracker.latestSample(for: operation)
        let average = tracker.averageMilliseconds(for: operation)

        return VStack(alignment: .leading, spacing: 8) {
            Text(operation.rawValue)
                .font(.headline)

            HStack {
                Text("Última")
                Spacer()
                Text(milliseconds(latest?.durationMilliseconds))
            }
            .font(.subheadline)

            HStack {
                Text("Promedio")
                Spacer()
                Text(milliseconds(average))
            }
            .font(.subheadline)

            Text("\(tracker.samples.filter { $0.operation == operation }.count) muestras")
                .font(.caption)
                .foregroundStyle(Unit3Theme.secondaryText)
        }
        .padding(16)
        .background(Unit3Theme.surface, in: RoundedRectangle(cornerRadius: 18))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(
            "\(operation.rawValue). Última medición \(milliseconds(latest?.durationMilliseconds)). Promedio \(milliseconds(average))."
        )
    }

    private func milliseconds(_ value: Double?) -> String {
        guard let value else { return "Sin datos" }
        return String(format: "%.2f ms", value)
    }
}
