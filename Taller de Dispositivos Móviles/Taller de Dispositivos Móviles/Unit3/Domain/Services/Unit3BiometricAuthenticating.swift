protocol Unit3BiometricAuthenticating {
    var methodName: String { get }
    func authenticate(reason: String) async throws
}
