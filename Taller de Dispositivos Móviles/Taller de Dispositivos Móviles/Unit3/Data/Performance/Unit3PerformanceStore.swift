import Foundation

final class Unit3PerformanceStore {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileManager: FileManager = .default) {
        let baseURL = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first ?? fileManager.temporaryDirectory

        let directoryURL = baseURL.appendingPathComponent(
            "UNIACCOrientaSecure",
            isDirectory: true
        )

        try? fileManager.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        fileURL = directoryURL.appendingPathComponent(
            "performance-metrics.json"
        )

        encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
    }

    func load() -> [Unit3PerformanceSample] {
        guard
            let data = try? Data(contentsOf: fileURL),
            !data.isEmpty,
            let samples = try? decoder.decode(
                [Unit3PerformanceSample].self,
                from: data
            )
        else {
            return []
        }

        return samples
    }

    func save(_ samples: [Unit3PerformanceSample]) throws {
        let data = try encoder.encode(samples)
        try data.write(to: fileURL, options: .atomic)
    }

    func clear() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return
        }

        try FileManager.default.removeItem(at: fileURL)
    }
}
