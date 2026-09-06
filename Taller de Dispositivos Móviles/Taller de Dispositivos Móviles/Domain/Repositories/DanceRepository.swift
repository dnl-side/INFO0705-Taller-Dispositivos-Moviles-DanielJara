import Foundation

protocol DanceRepository {
    func getClasses() async throws -> [DanceClass]
    func getAttendance(for classID: UUID) async -> [AttendanceRecord]
    func saveAttendance(_ record: AttendanceRecord) async throws
    func getProgress(for studentID: UUID, discipline: String) async throws -> [StudentProgress]
    func synchronizePendingAttendance() async
}
