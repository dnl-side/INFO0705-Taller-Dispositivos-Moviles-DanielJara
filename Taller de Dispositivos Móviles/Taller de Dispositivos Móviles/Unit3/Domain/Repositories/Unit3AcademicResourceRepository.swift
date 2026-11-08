protocol Unit3AcademicResourceRepository {
    func resource(for category: Unit3AcademicCategory) async throws -> Unit3AcademicResourceLoadResult
}
