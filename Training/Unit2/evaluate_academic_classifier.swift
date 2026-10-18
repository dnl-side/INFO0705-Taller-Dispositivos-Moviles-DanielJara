import CoreML
import Foundation
import NaturalLanguage

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

let modelURL = repositoryRoot
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Taller de Dispositivos Móviles")
    .appendingPathComponent("Unit2")
    .appendingPathComponent("Data")
    .appendingPathComponent("Models")
    .appendingPathComponent("AcademicQueryClassifierV4.mlmodel")

guard FileManager.default.fileExists(atPath: modelURL.path) else {
    fputs("No se encontró AcademicQueryClassifierV4.mlmodel. Ejecuta primero el script de entrenamiento.\n", stderr)
    exit(1)
}

let compiledURL = try MLModel.compileModel(at: modelURL)
defer {
    try? FileManager.default.removeItem(at: compiledURL)
}

let model = try NLModel(contentsOf: compiledURL)

let defaultQueries = [
    "evaluación",
    "evaluacion",
    "matricula",
    "contrasena",
    "hola",
    "beca",
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
        .predictedLabelHypotheses(for: normalizeQuery(query), maximumCount: 7)
        .sorted { $0.value > $1.value }

    print("\nConsulta: \(query)")

    if hypotheses.isEmpty {
        print("  Sin predicción")
        continue
    }

    // Mismos umbrales que CoreMLAcademicQueryClassifier: confianza mínima 25 % y diferencia mínima de 10 puntos.
    let best = hypotheses[0].value
    let second = hypotheses.count > 1 ? hypotheses[1].value : 0
    let isReliable = best >= 0.25 && best - second >= 0.10
    print("  Resultado en la app: \(isReliable ? "muestra el recurso" : "pide elegir categoría")")

    for (index, hypothesis) in hypotheses.prefix(3).enumerated() {
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
