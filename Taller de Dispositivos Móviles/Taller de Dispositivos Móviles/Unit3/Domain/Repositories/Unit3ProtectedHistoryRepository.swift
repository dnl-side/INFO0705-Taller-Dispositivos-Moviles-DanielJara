protocol Unit3ProtectedHistoryRepository {
    func entries() throws -> [ProtectedHistoryEntry]
    func add(_ entry: ProtectedHistoryEntry) throws
    func removeAll() throws
}
