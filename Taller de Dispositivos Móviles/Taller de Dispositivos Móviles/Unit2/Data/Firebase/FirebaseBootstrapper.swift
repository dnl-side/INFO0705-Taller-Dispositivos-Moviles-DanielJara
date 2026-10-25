import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif

enum FirebaseBootstrapper {
    /// Función empleada para configurar Firebase solamente cuando existe el archivo de configuración del proyecto.
    static func configureIfAvailable(bundle: Bundle = .main) -> Bool {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() != nil {
            return true
        }

        guard bundle.path(
            forResource: "GoogleService-Info",
            ofType: "plist"
        ) != nil else {
            return false
        }

        FirebaseApp.configure()
        return FirebaseApp.app() != nil
        #else
        return false
        #endif
    }
}
