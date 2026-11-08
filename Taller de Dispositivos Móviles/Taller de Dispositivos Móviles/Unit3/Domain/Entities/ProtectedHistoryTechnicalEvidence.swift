import Foundation

struct ProtectedHistoryTechnicalEvidence: Equatable {
    let algorithm: String
    let encryptedByteCount: Int
    let encryptedBase64: String
    let decryptedJSON: String?
}
