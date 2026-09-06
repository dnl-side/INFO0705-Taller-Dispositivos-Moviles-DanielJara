import Foundation

enum RemoteStudentDataSourceError: Error {
    case unavailable
}

final class RemoteStudentDataSource {
    private let shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }

    func fetchStudents() async throws -> [Student] {
        try await Task.sleep(nanoseconds: 800_000_000)

        if shouldFail {
            throw RemoteStudentDataSourceError.unavailable
        }

        return DanceSampleData.students
    }
}
