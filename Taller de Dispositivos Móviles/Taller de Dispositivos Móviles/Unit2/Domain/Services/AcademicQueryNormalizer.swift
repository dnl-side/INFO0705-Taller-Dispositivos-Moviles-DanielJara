import Foundation

enum AcademicQueryNormalizer {
    /// Función empleada para dejar la consulta en minúsculas, sin tildes ni signos de puntuación.
    /// Debe coincidir con la normalización aplicada en `Training/Unit2/train_academic_classifier.swift`.
    static func normalize(_ text: String) -> String {
        let folded = text
            .precomposedStringWithCanonicalMapping
            .folding(
                options: [.diacriticInsensitive, .caseInsensitive],
                locale: Locale(identifier: "es_CL")
            )
            .lowercased()

        let words = folded
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        return words.joined(separator: " ")
    }
}
