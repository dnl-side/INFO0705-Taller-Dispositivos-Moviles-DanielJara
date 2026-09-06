protocol StudentRepository {
    func getStudents() async throws -> [Student]
}
