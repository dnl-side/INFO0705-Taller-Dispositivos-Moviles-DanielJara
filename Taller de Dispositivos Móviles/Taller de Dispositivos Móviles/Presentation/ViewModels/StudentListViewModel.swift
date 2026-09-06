import Combine
import Foundation

@MainActor
final class StudentListViewModel: ObservableObject {
    @Published private(set) var students: [Student] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let repository: StudentRepository

    /// Función de inicialización empleada para recibir la abstracción del repositorio utilizada por la lista de estudiantes.
    init(repository: StudentRepository) {
        self.repository = repository
    }

    /// Función empleada para cargar la lista de estudiantes y actualizar los estados de carga y error de la interfaz.
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
