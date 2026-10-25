import Foundation

#if canImport(FirebaseCore) && canImport(FirebaseAuth) && canImport(FirebaseFirestore)
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
#endif

enum FirestoreAcademicResourceError: Error {
    case firebaseUnavailable
    case resourceNotFound
    case invalidData
}

final class FirestoreAcademicResourceDataSource {
    /// Función empleada para recuperar desde Firestore el recurso correspondiente a una categoría.
    func resource(for category: AcademicCategory) async throws -> AcademicResourceLoadResult {
        #if canImport(FirebaseCore) && canImport(FirebaseAuth) && canImport(FirebaseFirestore)
        guard FirebaseApp.app() != nil else {
            throw FirestoreAcademicResourceError.firebaseUnavailable
        }

        if Auth.auth().currentUser == nil {
            _ = try await Auth.auth().signInAnonymously()
        }

        let snapshot = try await Firestore.firestore()
            .collection("academic_resources")
            .document(category.rawValue)
            .getDocument(source: .default)

        guard snapshot.exists else {
            throw FirestoreAcademicResourceError.resourceNotFound
        }

        guard
            let data = snapshot.data(),
            let title = data["title"] as? String,
            let summary = data["summary"] as? String,
            let steps = data["steps"] as? [String],
            let channel = data["channel"] as? String
        else {
            throw FirestoreAcademicResourceError.invalidData
        }

        let resource = AcademicResource(
            category: category,
            title: title,
            summary: summary,
            steps: steps,
            channel: channel
        )

        return AcademicResourceLoadResult(
            resource: resource,
            source: snapshot.metadata.isFromCache ? .cache : .cloud
        )
        #else
        throw FirestoreAcademicResourceError.firebaseUnavailable
        #endif
    }
}
