import Foundation

struct MediaRecord: Identifiable, Equatable {
    let id: UUID
    let classID: UUID
    let studentID: UUID?
    let capturedAt: Date
    let localFileName: String
    let tags: [String]
    let syncState: SyncState

    init(
        id: UUID = UUID(),
        classID: UUID,
        studentID: UUID? = nil,
        capturedAt: Date = Date(),
        localFileName: String,
        tags: [String],
        syncState: SyncState = .pending
    ) {
        self.id = id
        self.classID = classID
        self.studentID = studentID
        self.capturedAt = capturedAt
        self.localFileName = localFileName
        self.tags = tags
        self.syncState = syncState
    }
}
