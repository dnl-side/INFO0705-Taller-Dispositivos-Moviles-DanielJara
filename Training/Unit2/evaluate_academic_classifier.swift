import CoreML
import Foundation
import NaturalLanguage

let scriptURL = URL(fileURLWithPath: #filePath)
let trainingDirectory = scriptURL.deletingLastPathComponent()
let repositoryRoot = trainingDirectory
    .deletingLastPathComponent()
    .deletingLastPathComponent()

let modelURL = repositoryRoot
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Unit2")
    .appendingPathComponent("Data")
    .appendingPathComponent("Models")
    .appendingPathComponent("AcademicQueryClassifierV3.mlmodel")

guard FileManager.default.fileExists(atPath: modelURL.path) else {
    fputs("No se encontró AcademicQueryClassifierV3.mlmodel. Ejecuta primero el script de entrenamiento.\n", stderr)
    exit(1)
}

let compiledURL = try MLModel.compileModel(at: modelURL)
defer {
    try? FileManager.default.removeItem(at: compiledURL)
}

let model = try NLModel(contentsOf: compiledURL)

let defaultQueries = [
    "evaluación",
    "evaluaciones",
    "calificación",
    "calificaciones",
    "nota",
    "notas",
    "examen",
    "prueba",
    "contraseña",
    "nombre",
    "¿Dónde puedo revisar mis evaluaciones?",
    "Me pidieron demostrar que sigo siendo estudiante",
    "Todavía no sé si registraron el pago que hice",
    "Quiero encontrar papers para fundamentar mi informe",
    "El portal no me deja ingresar aunque mi usuario es correcto"
]

let customQueries = Array(CommandLine.arguments.dropFirst())
let queries = customQueries.isEmpty ? defaultQueries : customQueries

for query in queries {
    let hypotheses = model
        .predictedLabelHypotheses(for: query, maximumCount: 3)
        .sorted { $0.value > $1.value }

    print("\nConsulta: \(query)")

    if hypotheses.isEmpty {
        print("  Sin predicción")
        continue
    }

    for (index, hypothesis) in hypotheses.enumerated() {
        print(
            String(
                format: "  %d. %@ — %.2f %%",
                index + 1,
                hypothesis.key,
                hypothesis.value * 100.0
            )
        )
    }
}
