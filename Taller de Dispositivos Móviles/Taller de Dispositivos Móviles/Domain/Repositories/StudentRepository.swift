protocol StudentRepository {
    /// Función empleada para solicitar la lista de estudiantes sin depender del origen concreto de los datos.
    func getStudents() async throws -> [Student]
}
