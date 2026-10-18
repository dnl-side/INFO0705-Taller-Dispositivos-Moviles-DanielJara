# Entrenamiento CoreML - Unidad 2

El archivo `academic_queries.csv` contiene consultas académicas etiquetadas en las siete categorías utilizadas por UNIACC Orienta.

El archivo `challenge_queries.csv` contiene frases separadas del entrenamiento. Se utiliza como conjunto adicional de desafío para comprobar que el modelo pueda clasificar formulaciones nuevas y no solo memorizar ejemplos del dataset.

Para entrenar el modelo desde un Mac con Xcode instalado:

```bash
cd ~/Developer/UNIACC/INFO0705-Taller-Dispositivos-Moviles-DanielJara
xcrun swift Training/Unit2/train_academic_classifier.swift
```

El script muestra cuatro métricas:

- `Training accuracy`
- `Validation accuracy`
- `Testing accuracy`
- `Challenge accuracy`

y genera:

```text
Taller de Dispositivos Móviles/
└── Taller de Dispositivos Móviles/
    └── Unit2/
        └── Data/
            └── Models/
                └── AcademicQueryClassifierV4.mlmodel
```

Al volver a abrir Xcode, el modelo queda dentro del grupo sincronizado del proyecto. La aplicación intenta cargarlo automáticamente y utiliza el clasificador preliminar solo cuando el modelo no está disponible.


## Evaluación directa del modelo

Para comprobar el archivo `AcademicQueryClassifierV4.mlmodel` recién generado sin depender de la caché de Xcode o del Simulator:

```bash
xcrun swift Training/Unit2/evaluate_academic_classifier.swift
```

El script compila temporalmente el modelo y muestra las tres categorías con mayor probabilidad para varias consultas cortas y naturales.

También se pueden pasar consultas propias:

```bash
xcrun swift Training/Unit2/evaluate_academic_classifier.swift "calificación" "quiero revisar mi nota"
```

Esta evaluación es útil para distinguir entre un problema del modelo y un modelo anterior todavía compilado dentro de Xcode.


## Idioma del modelo

El corpus de UNIACC Orienta está escrito en español. El entrenamiento configura explícitamente `language: .spanish` en `MLTextClassifier.ModelParameters` para que el procesamiento lingüístico del modelo no dependa de la configuración regional del equipo o simulador.


## Normalización y consultas no reconocidas

Antes de entrenar, el script normaliza cada consulta: minúsculas, sin tildes ni signos de puntuación (`evaluación`, `Evaluacion` y `¿evaluación?` quedan como `evaluacion`). La aplicación aplica la misma transformación con `AcademicQueryNormalizer` antes de consultar el modelo, de modo que una palabra escrita sin tilde no se trate como desconocida. Si se modifica la normalización, debe mantenerse igual en `AcademicQueryNormalizer.swift`, `train_academic_classifier.swift` y `evaluate_academic_classifier.swift`.

Cuando la consulta no contiene palabras conocidas por el modelo (por ejemplo `hola` o `beca`), todas las categorías quedan con la misma probabilidad (14,29 %). La aplicación ya no elige una de ellas al azar: si la mejor categoría tiene menos de 25 % de confianza o supera a la segunda por menos de 10 puntos, se muestra un aviso y el estudiante puede elegir la categoría manualmente. Además, junto a cada resultado se ofrecen las demás categorías para revisar otro recurso.
