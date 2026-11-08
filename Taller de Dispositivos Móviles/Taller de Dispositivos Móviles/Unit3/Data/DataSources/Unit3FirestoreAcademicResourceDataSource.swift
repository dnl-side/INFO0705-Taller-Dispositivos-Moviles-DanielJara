import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import Foundation

enum Unit3FirestoreAcademicResourceError: LocalizedError {
    case firebaseUnavailable
    case resourceNotFound
    case invalidData

    var errorDescription: String? {
        switch self {
        case .firebaseUnavailable:
            "Firebase no se encuentra configurado."
        case .resourceNotFound:
            "El recurso solicitado no existe en Firestore."
        case .invalidData:
            "El documento remoto no tiene el formato esperado."
        }
    }
}

final class Unit3FirestoreAcademicResourceDataSource {
    func resource(for category: Unit3AcademicCategory) async throws -> Unit3AcademicResourceLoadResult {
        guard FirebaseApp.app() != nil else {
            throw Unit3FirestoreAcademicResourceError.firebaseUnavailable
        }

        if Auth.auth().currentUser == nil {
            _ = try await Auth.auth().signInAnonymously()
        }

        let snapshot = try await Firestore.firestore()
            .collection("academic_resources")
            .document(category.rawValue)
            .getDocument(source: .default)

        guard snapshot.exists else {
            throw Unit3FirestoreAcademicResourceError.resourceNotFound
        }

        guard
            let data = snapshot.data(),
            let title = data["title"] as? String,
            let summary = data["summary"] as? String,
            let steps = data["steps"] as? [String],
            let channel = data["channel"] as? String
        else {
            throw Unit3FirestoreAcademicResourceError.invalidData
        }

        return Unit3AcademicResourceLoadResult(
            resource: Unit3AcademicResource(
                category: category,
                title: title,
                summary: summary,
                steps: steps,
                channel: channel
            ),
            source: snapshot.metadata.isFromCache ? .cache : .cloud
        )
    }
}
