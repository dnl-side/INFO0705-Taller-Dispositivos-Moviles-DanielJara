protocol Unit3QueryClassifying {
    var engineName: String { get }
    var usesCoreML: Bool { get }

    func classify(query: String) async throws -> Unit3AcademicClassification
}
