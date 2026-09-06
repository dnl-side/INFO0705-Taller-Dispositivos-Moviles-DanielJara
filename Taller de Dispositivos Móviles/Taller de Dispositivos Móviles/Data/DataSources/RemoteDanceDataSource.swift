import Foundation

enum RemoteDanceDataSourceError: Error {
    case unavailable
}

final class RemoteDanceDataSource {
    private let shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func fetchClasses() async throws -> [DanceClass] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if shouldFail {
            throw RemoteDanceDataSourceError.unavailable
        }

        return DanceSampleData.classes
    }

    func uploadAttendance(_ record: AttendanceRecord) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)

        if shouldFail {
            throw RemoteDanceDataSourceError.unavailable
        }
    }

    func fetchProgress(for studentID: UUID, discipline: String) async throws -> [StudentProgress] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if shouldFail {
            throw RemoteDanceDataSourceError.unavailable
        }

        return DanceSampleData.progress.filter {
            $0.studentID == studentID && $0.discipline == discipline
        }
    }
}
