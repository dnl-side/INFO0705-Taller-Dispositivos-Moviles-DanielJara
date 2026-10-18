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
                └── AcademicQueryClassifierV3.mlmodel
```

Al volver a abrir Xcode, el modelo queda dentro del grupo sincronizado del proyecto. La aplicación intenta cargarlo automáticamente y utiliza el clasificador preliminar solo cuando el modelo no está disponible.


## Evaluación directa del modelo

Para comprobar el archivo `AcademicQueryClassifierV3.mlmodel` recién generado sin depender de la caché de Xcode o del Simulator:

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
