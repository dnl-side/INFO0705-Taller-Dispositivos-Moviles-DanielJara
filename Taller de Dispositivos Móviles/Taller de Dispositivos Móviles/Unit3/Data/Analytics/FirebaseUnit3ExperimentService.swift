import Foundation

#if canImport(FirebaseRemoteConfig)
import FirebaseRemoteConfig
#endif

@MainActor
final class FirebaseUnit3ExperimentService: Unit3ExperimentProviding {
    private(set) var currentVariant: Unit3ExperimentVariant = .focused

    #if canImport(FirebaseRemoteConfig)
    private let remoteConfig: RemoteConfig
    #endif

    init() {
        #if canImport(FirebaseRemoteConfig)
        remoteConfig = RemoteConfig.remoteConfig()

        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults([
            "unit3_low_confidence_variant": Unit3ExperimentVariant.focused.rawValue as NSObject
        ])

        updateCurrentVariant()
        #endif
    }

    func refresh() async {
        #if canImport(FirebaseRemoteConfig)
        do {
            _ = try await remoteConfig.fetchAndActivate()
        } catch {
            // El valor local por defecto mantiene el experimento funcional sin red.
        }

        updateCurrentVariant()
        #endif
    }

    #if canImport(FirebaseRemoteConfig)
    private func updateCurrentVariant() {
        let value = remoteConfig
            .configValue(forKey: "unit3_low_confidence_variant")
            .stringValue

        currentVariant = Unit3ExperimentVariant(rawValue: value) ?? .focused
    }
    #endif
}
