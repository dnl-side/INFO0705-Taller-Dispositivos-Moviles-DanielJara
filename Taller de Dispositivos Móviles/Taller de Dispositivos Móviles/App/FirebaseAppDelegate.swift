import UIKit

final class FirebaseAppDelegate: NSObject, UIApplicationDelegate {
    /// Función empleada para inicializar Firebase en el ciclo de vida recomendado para aplicaciones SwiftUI.
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        _ = FirebaseBootstrapper.configureIfAvailable()
        return true
    }
}
