import Combine
import Foundation

@MainActor
final class StudentListViewModel: ObservableObject {
    @Published private(set) var students: [Student] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let repository: StudentRepository

    init(repository: StudentRepository) {
        self.repository = repository
    }

    func loadStudents() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            students = try await repository.getStudents()
        } catch {
            errorMessage = "No fue posible cargar los estudiantes."
        }
    }
}
