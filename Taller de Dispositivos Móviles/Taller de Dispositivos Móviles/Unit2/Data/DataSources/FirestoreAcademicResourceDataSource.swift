import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

enum FirestoreAcademicResourceError: LocalizedError {
    case firebaseUnavailable
    case resourceNotFound
    case invalidData

    var errorDescription: String? {
        switch self {
        case .firebaseUnavailable:
            "Firebase no quedó configurado al iniciar la aplicación."
        case .resourceNotFound:
            "El documento solicitado no existe en Firestore."
        case .invalidData:
            "El documento de Firestore existe, pero sus campos no tienen el formato esperado."
        }
    }
}

final class FirestoreAcademicResourceDataSource {
    /// Función empleada para recuperar desde Firestore el recurso correspondiente a una categoría.
    func resource(for category: AcademicCategory) async throws -> AcademicResourceLoadResult {
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
    }
}
