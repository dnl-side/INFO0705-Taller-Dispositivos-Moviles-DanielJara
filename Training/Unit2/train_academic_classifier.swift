import CreateML
import Foundation
import TabularData

let scriptURL = URL(fileURLWithPath: #filePath)
let trainingDirectory = scriptURL.deletingLastPathComponent()
let repositoryRoot = trainingDirectory
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let dataURL = trainingDirectory.appendingPathComponent("academic_queries.csv")
let outputDirectory = repositoryRoot
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Unit2")
    .appendingPathComponent("Data")
    .appendingPathComponent("Models")

let outputURL = outputDirectory
    .appendingPathComponent("AcademicQueryClassifier.mlmodel")

try FileManager.default.createDirectory(
    at: outputDirectory,
    withIntermediateDirectories: true
)

let data = try DataFrame(contentsOfCSVFile: dataURL)
let (trainingData, testingData) = data.stratifiedSplit(
    on: "label",
    by: 0.8,
    randomSeed: 42
)

let classifier = try MLTextClassifier(
    trainingData: trainingData,
    textColumn: "text",
    labelColumn: "label"
)

let testingMetrics = classifier.evaluation(
    on: testingData,
    textColumn: "text",
    labelColumn: "label"
)

let trainingAccuracy = (1.0 - classifier.trainingMetrics.classificationError) * 100.0
let validationAccuracy = (1.0 - classifier.validationMetrics.classificationError) * 100.0
let testingAccuracy = (1.0 - testingMetrics.classificationError) * 100.0

print(String(format: "Training accuracy: %.2f %%", trainingAccuracy))
print(String(format: "Validation accuracy: %.2f %%", validationAccuracy))
print(String(format: "Testing accuracy: %.2f %%", testingAccuracy))

let metadata = MLModelMetadata(
    author: "Daniel Jara",
    shortDescription: "Clasificador local de consultas académicas para UNIACC Orienta.",
    version: "1.0"
)

try classifier.write(to: outputURL, metadata: metadata)

print("Modelo generado en:")
print(outputURL.path)
