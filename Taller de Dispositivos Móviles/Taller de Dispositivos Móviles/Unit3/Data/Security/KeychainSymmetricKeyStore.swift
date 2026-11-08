import CryptoKit
import Foundation
import Security

enum KeychainSymmetricKeyStoreError: Error {
    case unexpectedStatus(OSStatus)
}

final class KeychainSymmetricKeyStore {
    private let service = "cl.uniacc.orienta.u3.secure-history"
    private let account = "history-aes-key"

    func loadOrCreateKey() throws -> SymmetricKey {
        if let data = try loadKeyData() {
            return SymmetricKey(data: data)
        }

        let key = SymmetricKey(size: .bits256)
        let data = key.withUnsafeBytes { Data($0) }
        try saveKeyData(data)
        return key
    }

    private func loadKeyData() throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainSymmetricKeyStoreError.unexpectedStatus(status)
        }

        return result as? Data
    }

    private func saveKeyData(_ data: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainSymmetricKeyStoreError.unexpectedStatus(status)
        }
    }
}
