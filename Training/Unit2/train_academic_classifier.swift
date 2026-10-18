import CreateML
import Foundation
import NaturalLanguage
import TabularData

/// Función empleada para normalizar el texto igual que `AcademicQueryNormalizer` en la aplicación.
func normalizeQuery(_ text: String) -> String {
    let folded = text
        .precomposedStringWithCanonicalMapping
        .folding(
            options: [.diacriticInsensitive, .caseInsensitive],
            locale: Locale(identifier: "es_CL")
        )
        .lowercased()

    return folded
        .components(separatedBy: CharacterSet.alphanumerics.inverted)
        .filter { !$0.isEmpty }
        .joined(separator: " ")
}

let scriptURL = URL(fileURLWithPath: #filePath)
let trainingDirectory = scriptURL.deletingLastPathComponent()
let repositoryRoot = trainingDirectory
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let dataURL = trainingDirectory.appendingPathComponent("academic_queries.csv")
let challengeURL = trainingDirectory.appendingPathComponent("challenge_queries.csv")
let outputDirectory = repositoryRoot
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Unit2")
    .appendingPathComponent("Data")
    .appendingPathComponent("Models")

let outputURL = outputDirectory
    .appendingPathComponent("AcademicQueryClassifierV4.mlmodel")

try FileManager.default.createDirectory(
    at: outputDirectory,
    withIntermediateDirectories: true
)

var data = try DataFrame(contentsOfCSVFile: dataURL)
var challengeData = try DataFrame(contentsOfCSVFile: challengeURL)

// El modelo se entrena con texto normalizado para que tildes, mayúsculas y signos no generen palabras desconocidas.
try data.transformColumn("text") { (text: String) -> String in normalizeQuery(text) }
try challengeData.transformColumn("text") { (text: String) -> String in normalizeQuery(text) }

let (trainingData, testingData) = data.stratifiedSplit(
    on: "label",
    by: 0.8,
    randomSeed: 42
)

let parameters = MLTextClassifier.ModelParameters(
    validation: .split(strategy: .automatic),
    algorithm: .maxEnt(revision: 1),
    language: .spanish
)

let classifier = try MLTextClassifier(
    trainingData: trainingData,
    textColumn: "text",
    labelColumn: "label",
    parameters: parameters
)

let testingMetrics = classifier.evaluation(
    on: testingData,
    textColumn: "text",
    labelColumn: "label"
)

let challengeMetrics = classifier.evaluation(
    on: challengeData,
    textColumn: "text",
    labelColumn: "label"
)

let trainingAccuracy = (1.0 - classifier.trainingMetrics.classificationError) * 100.0
let validationAccuracy = (1.0 - classifier.validationMetrics.classificationError) * 100.0
let testingAccuracy = (1.0 - testingMetrics.classificationError) * 100.0
let challengeAccuracy = (1.0 - challengeMetrics.classificationError) * 100.0

print(String(format: "Training accuracy: %.2f %%", trainingAccuracy))
print(String(format: "Validation accuracy: %.2f %%", validationAccuracy))
print(String(format: "Testing accuracy: %.2f %%", testingAccuracy))
print(String(format: "Challenge accuracy: %.2f %%", challengeAccuracy))

let metadata = MLModelMetadata(
    author: "Daniel Jara",
    shortDescription: "Clasificador local de consultas académicas para UNIACC Orienta.",
    version: "1.4"
)

try classifier.write(to: outputURL, metadata: metadata)

print("Modelo generado en:")
print(outputURL.path)
