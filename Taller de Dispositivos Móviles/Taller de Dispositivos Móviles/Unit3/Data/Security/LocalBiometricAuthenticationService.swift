import Foundation
import LocalAuthentication

enum LocalBiometricAuthenticationError: LocalizedError {
    case unavailable
    case failed

    var errorDescription: String? {
        switch self {
        case .unavailable:
            "La autenticación del dispositivo no está disponible."
        case .failed:
            "No fue posible verificar la identidad."
        }
    }
}

final class LocalBiometricAuthenticationService: Unit3BiometricAuthenticating {
    var methodName: String {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        ) else {
            return "Autenticación del dispositivo"
        }

        switch context.biometryType {
        case .faceID: "Face ID"
        case .touchID: "Touch ID"
        case .opticID: "Optic ID"
        default: "Biometría"
        }
    }

    func authenticate(reason: String) async throws {
        let context = LAContext()
        context.localizedCancelTitle = "Cancelar"
        context.localizedFallbackTitle = "Usar código"

        var error: NSError?
        let supportsBiometrics = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )

        let policy: LAPolicy = supportsBiometrics
            ? .deviceOwnerAuthenticationWithBiometrics
            : .deviceOwnerAuthentication

        guard context.canEvaluatePolicy(policy, error: &error) else {
            throw LocalBiometricAuthenticationError.unavailable
        }

        let success: Bool = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Bool, Error>) in
            context.evaluatePolicy(
                policy,
                localizedReason: reason
            ) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }

        guard success else {
            throw LocalBiometricAuthenticationError.failed
        }
    }
}
