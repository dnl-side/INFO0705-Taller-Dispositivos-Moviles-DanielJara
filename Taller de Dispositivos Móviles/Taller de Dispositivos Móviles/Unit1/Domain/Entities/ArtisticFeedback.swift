import Foundation

struct ArtisticFeedback: Identifiable, Equatable {
    let id: UUID
    let studentID: UUID
    let classID: UUID
    let date: Date
    let technicalCorrection: String
    let projectionNote: String
    let postureNote: String
    let expressiveNote: String
    let syncState: SyncState

    /// Función de inicialización empleada para crear una retroalimentación artística con observaciones técnicas y expresivas.
    init(
        id: UUID = UUID(),
        studentID: UUID,
        classID: UUID,
        date: Date = Date(),
        technicalCorrection: String,
        projectionNote: String,
        postureNote: String,
        expressiveNote: String,
        syncState: SyncState = .pending
    ) {
        self.id = id
        self.studentID = studentID
        self.classID = classID
        self.date = date
        self.technicalCorrection = technicalCorrection
        self.projectionNote = projectionNote
        self.postureNote = postureNote
        self.expressiveNote = expressiveNote
        self.syncState = syncState
    }
}
