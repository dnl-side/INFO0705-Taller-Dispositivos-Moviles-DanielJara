import Foundation

enum Unit3LocalAcademicResourceError: Error {
    case resourceNotFound
}

final class Unit3LocalAcademicResourceDataSource {
    private let resources: [Unit3AcademicResource]

    init(resources: [Unit3AcademicResource] = Unit3AcademicSampleData.resources) {
        self.resources = resources
    }

    func resource(for category: Unit3AcademicCategory) throws -> Unit3AcademicResource {
        guard let resource = resources.first(where: { $0.category == category }) else {
            throw Unit3LocalAcademicResourceError.resourceNotFound
        }

        return resource
    }
}
