import Foundation

final class Unit3AcademicResourceRepositoryImpl: Unit3AcademicResourceRepository {
    private struct CacheEntry {
        let resource: Unit3AcademicResource
        let storedAt: Date
    }

    private let localDataSource: Unit3LocalAcademicResourceDataSource
    private let remoteDataSource: Unit3FirestoreAcademicResourceDataSource
    private let cacheLifetime: TimeInterval
    private var sessionCache: [Unit3AcademicCategory: CacheEntry] = [:]

    init(
        localDataSource: Unit3LocalAcademicResourceDataSource,
        remoteDataSource: Unit3FirestoreAcademicResourceDataSource,
        cacheLifetime: TimeInterval = 300
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.cacheLifetime = cacheLifetime
    }

    func resource(for category: Unit3AcademicCategory) async throws -> Unit3AcademicResourceLoadResult {
        if let cached = validCachedResource(for: category) {
            return Unit3AcademicResourceLoadResult(
                resource: cached,
                source: .sessionCache
            )
        }

        do {
            let result = try await remoteDataSource.resource(for: category)
            sessionCache[category] = CacheEntry(
                resource: result.resource,
                storedAt: Date()
            )
            return result
        } catch {
            let localResource = try localDataSource.resource(for: category)
            sessionCache[category] = CacheEntry(
                resource: localResource,
                storedAt: Date()
            )

            return Unit3AcademicResourceLoadResult(
                resource: localResource,
                source: .localFallback
            )
        }
    }

    private func validCachedResource(
        for category: Unit3AcademicCategory
    ) -> Unit3AcademicResource? {
        guard let entry = sessionCache[category] else {
            return nil
        }

        guard Date().timeIntervalSince(entry.storedAt) < cacheLifetime else {
            sessionCache[category] = nil
            return nil
        }

        return entry.resource
    }
}
