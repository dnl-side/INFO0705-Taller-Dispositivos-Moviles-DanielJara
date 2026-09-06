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

        return [
            Student(name: "Camila Soto", technicalLevel: .intermediate),
            Student(name: "Martín Rojas", technicalLevel: .advanced),
            Student(name: "Sofía Pérez", technicalLevel: .initial),
            Student(name: "Valentina Díaz", technicalLevel: .intermediate)
        ]
    }
}
