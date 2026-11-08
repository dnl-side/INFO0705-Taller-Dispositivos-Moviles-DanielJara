import CryptoKit
import Foundation

enum EncryptedProtectedHistoryRepositoryError: Error {
    case invalidEncryptedData
}

final class EncryptedProtectedHistoryRepository: Unit3ProtectedHistoryRepository {
    private let keyStore: KeychainSymmetricKeyStore
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let maximumEntries = 20

    init(
        keyStore: KeychainSymmetricKeyStore = KeychainSymmetricKeyStore(),
        fileManager: FileManager = .default
    ) {
        self.keyStore = keyStore

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

        fileURL = directoryURL.appendingPathComponent("protected-history.bin")
    }

    func entries() throws -> [ProtectedHistoryEntry] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }

        let encryptedData = try Data(contentsOf: fileURL)
        guard !encryptedData.isEmpty else {
            return []
        }

        let key = try keyStore.loadOrCreateKey()
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let clearData = try AES.GCM.open(sealedBox, using: key)
        return try decoder.decode([ProtectedHistoryEntry].self, from: clearData)
    }

    func add(_ entry: ProtectedHistoryEntry) throws {
        var current = try entries()
        current.removeAll { $0.id == entry.id }
        current.insert(entry, at: 0)

        if current.count > maximumEntries {
            current = Array(current.prefix(maximumEntries))
        }

        try persist(current)
    }

    func removeAll() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        try FileManager.default.removeItem(at: fileURL)
    }

    private func persist(_ entries: [ProtectedHistoryEntry]) throws {
        let clearData = try encoder.encode(entries)
        let key = try keyStore.loadOrCreateKey()
        let sealedBox = try AES.GCM.seal(clearData, using: key)

        guard let combined = sealedBox.combined else {
            throw EncryptedProtectedHistoryRepositoryError.invalidEncryptedData
        }

        try combined.write(to: fileURL, options: .atomic)
    }
}
