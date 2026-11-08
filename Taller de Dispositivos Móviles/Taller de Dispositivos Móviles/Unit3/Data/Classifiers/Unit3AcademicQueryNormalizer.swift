import Foundation

enum Unit3AcademicQueryClassifierError: Error {
    case emptyQuery
}

enum Unit3AcademicQueryNormalizer {
    static func normalize(_ query: String) -> String {
        query
            .folding(
                options: [.diacriticInsensitive, .caseInsensitive],
                locale: Locale(identifier: "es")
            )
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
