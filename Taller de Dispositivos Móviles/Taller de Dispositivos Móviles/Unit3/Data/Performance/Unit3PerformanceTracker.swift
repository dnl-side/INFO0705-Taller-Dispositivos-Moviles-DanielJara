import Combine
import Foundation
import os

@MainActor
final class Unit3PerformanceTracker: ObservableObject {
    @Published private(set) var samples: [Unit3PerformanceSample]

    private let store: Unit3PerformanceStore
    private let log = OSLog(
        subsystem: "cl.uniacc.orienta",
        category: "Unit3Performance"
    )

    init(store: Unit3PerformanceStore = Unit3PerformanceStore()) {
        self.store = store
        samples = store.load()
    }

    func measure<T>(
        _ operation: Unit3PerformanceOperation,
        work: () async throws -> T
    ) async rethrows -> T {
        let signpostID = OSSignpostID(log: log)
        let start = DispatchTime.now().uptimeNanoseconds

        os_signpost(
            .begin,
            log: log,
            name: "Unit3Operation",
            signpostID: signpostID,
            "%{public}@",
            operation.rawValue
        )

        do {
            let result = try await work()
            finish(operation, start: start, signpostID: signpostID)
            return result
        } catch {
            finish(operation, start: start, signpostID: signpostID)
            throw error
        }
    }

    func averageMilliseconds(for operation: Unit3PerformanceOperation) -> Double? {
        let values = samples
            .filter { $0.operation == operation }
            .map(\.durationMilliseconds)

        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    func latestSample(for operation: Unit3PerformanceOperation) -> Unit3PerformanceSample? {
        samples.first { $0.operation == operation }
    }

    func clear() {
        samples.removeAll()
        try? store.clear()
    }

    private func finish(
        _ operation: Unit3PerformanceOperation,
        start: UInt64,
        signpostID: OSSignpostID
    ) {
        let end = DispatchTime.now().uptimeNanoseconds
        let duration = Double(end - start) / 1_000_000

        samples.insert(
            Unit3PerformanceSample(
                operation: operation,
                durationMilliseconds: duration
            ),
            at: 0
        )

        if samples.count > 100 {
            samples = Array(samples.prefix(100))
        }

        try? store.save(samples)

        os_signpost(
            .end,
            log: log,
            name: "Unit3Operation",
            signpostID: signpostID,
            "%{public}@ %.2f ms",
            operation.rawValue,
            duration
        )
    }
}
