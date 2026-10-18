# Entrenamiento CoreML - Unidad 2

El archivo `academic_queries.csv` contiene consultas académicas etiquetadas en las siete categorías utilizadas por UNIACC Orienta.

Para entrenar el modelo desde un Mac con Xcode instalado:

```bash
cd ~/Developer/UNIACC/INFO0705-Taller-Dispositivos-Moviles-DanielJara
xcrun swift Training/Unit2/train_academic_classifier.swift
```

El script muestra las métricas de entrenamiento, validación y prueba y genera:

```text
Taller de Dispositivos Móviles/
└── Taller de Dispositivos Móviles/
    └── Unit2/
        └── Data/
            └── Models/
                └── AcademicQueryClassifier.mlmodel
```

Al volver a abrir Xcode, el modelo queda dentro del grupo sincronizado del proyecto. La aplicación intenta cargarlo automáticamente y utiliza el clasificador preliminar solo cuando el modelo no está disponible.
