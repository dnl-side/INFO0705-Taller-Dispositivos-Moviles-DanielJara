import Foundation

protocol DanceRepository {
    func getClasses() async throws -> [DanceClass]
    func getAttendance(for classID: UUID) async -> [AttendanceRecord]
    func saveAttendance(_ record: AttendanceRecord) async throws
    func getProgress(for studentID: UUID, discipline: String) async throws -> [StudentProgress]
    func getFeedback(for studentID: UUID) async -> [ArtisticFeedback]
    func getMedia(for classID: UUID) async -> [MediaRecord]
    func synchronizePendingAttendance() async
}
