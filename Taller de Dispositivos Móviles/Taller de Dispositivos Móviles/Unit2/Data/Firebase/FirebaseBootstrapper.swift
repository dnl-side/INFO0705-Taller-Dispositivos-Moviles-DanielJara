import Foundation

#if canImport(FirebaseCore)
import FirebaseCore
#endif

#if canImport(FirebaseFirestore)
import FirebaseFirestore
#endif

enum FirebaseBootstrapper {
    /// Función empleada para configurar Firebase con el plist del bundle o, como respaldo, con opciones explícitas del proyecto.
    static func configureIfAvailable(bundle: Bundle = .main) -> Bool {
        #if canImport(FirebaseCore)
        if FirebaseApp.app() == nil {
            if let plistPath = bundle.path(
                forResource: "GoogleService-Info",
                ofType: "plist"
            ),
            let options = FirebaseOptions(contentsOfFile: plistPath) {
                FirebaseApp.configure(options: options)
            } else {
                let options = FirebaseOptions(
                    googleAppID: "1:498944447980:ios:22e6d47befdebe41ba9cc9",
                    gcmSenderID: "498944447980"
                )
                options.apiKey = "AIzaSyAA2sblRWWyt3iH0PrKkQSdejrlZ87CDBc"
                options.projectID = "uniacc-orienta-danieljara"
                options.bundleID = bundle.bundleIdentifier ?? "com.Taller-de-Dispositivos-Mo-viles"
                options.storageBucket = "uniacc-orienta-danieljara.firebasestorage.app"

                FirebaseApp.configure(options: options)
            }
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
