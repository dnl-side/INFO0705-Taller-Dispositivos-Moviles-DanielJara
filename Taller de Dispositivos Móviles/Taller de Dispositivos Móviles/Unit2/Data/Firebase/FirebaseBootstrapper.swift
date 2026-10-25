import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

enum FirebaseBootstrapper {
    /// Función empleada para configurar Firebase solamente cuando existe el archivo de configuración del proyecto.
    static func configureIfAvailable(bundle: Bundle = .main) -> Bool {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            guard bundle.path(
                forResource: "GoogleService-Info",
                ofType: "plist"
            ) != nil else {
                return false
            }

            FirebaseApp.configure()
        }

        guard FirebaseApp.app() != nil else {
            return false
        }

        configureFirestoreCache()
        return true
        #else
        return false
        #endif
    }

    /// Función empleada para declarar explícitamente una caché persistente de Firestore para el trabajo sin conexión.
    private static func configureFirestoreCache() {
        #if canImport(FirebaseFirestore)
        let database = Firestore.firestore()
        let settings = database.settings
        settings.cacheSettings = PersistentCacheSettings(
            sizeBytes: 20 * 1024 * 1024 as NSNumber
        )
        database.settings = settings
        #endif
    }
}
