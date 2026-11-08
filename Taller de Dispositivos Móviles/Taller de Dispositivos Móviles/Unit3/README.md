# Unidad 3 - UNIACC Orienta Secure

La Unidad 3 conserva el problema de orientación académica trabajado en la Unidad 2, pero utiliza una implementación independiente para demostrar evolución técnica sin modificar la entrega anterior.

## Objetivos técnicos

- medir operaciones relevantes mediante tiempos de sesión y signposts;
- utilizar Instruments para profiling de CPU, memoria y ejecución;
- reducir trabajo innecesario mediante ciclo de vida acotado y caché;
- proteger información local mediante cifrado AES-GCM;
- almacenar la clave simétrica en Keychain;
- controlar el acceso al historial mediante LocalAuthentication;
- aplicar accesibilidad en navegación, controles y contenido dinámico;
- recopilar métricas de UX con Firebase Analytics sin enviar texto libre;
- preparar una variante de interfaz mediante Firebase Remote Config.

## Flujo principal

1. El usuario ingresa a Unidad 3 desde el selector.
2. Los servicios de la unidad se crean en ese momento, no al iniciar la aplicación.
3. La consulta se clasifica localmente con CoreML V4.
4. El recurso se obtiene desde Firestore, caché o respaldo local.
5. El usuario puede guardar la consulta de forma explícita.
6. El historial se serializa, cifra con AES-GCM y persiste localmente.
7. La clave AES se conserva en Keychain.
8. Para visualizar el historial se solicita autenticación del dispositivo.

## Prueba biométrica en Simulator

La funcionalidad se implementa con LocalAuthentication y puede demostrarse sin instalar la aplicación en un iPhone físico.

En Simulator:

1. Abrir la Unidad 3.
2. Entrar en Historial protegido.
3. Iniciar el desbloqueo.
4. Utilizar las opciones de biometría del Simulator para simular coincidencia o rechazo.

El flujo debe contemplar tanto autenticación correcta como cancelación o error.

## Profiling

Las siguientes operaciones generan intervalos `Unit3Operation` mediante os_signpost:

- Orientación completa
- Clasificación CoreML
- Carga de recurso
- Guardado cifrado
- Lectura cifrada

Para obtener evidencia:

1. Ejecutar un recorrido funcional repetible.
2. Abrir Product > Profile en Xcode.
3. Utilizar Time Profiler y/o Points of Interest.
4. Identificar los intervalos `Unit3Operation`.
5. Repetir la misma secuencia después de cada optimización.
6. Comparar tiempos, CPU, memoria y actividad de red bajo condiciones equivalentes.

La pantalla Diagnóstico y rendimiento muestra tiempos de sesión como apoyo visual. No sustituye las mediciones de Instruments.

## Privacidad

Los eventos de Analytics nunca incluyen el texto libre de la consulta. Únicamente se registran estados categóricos necesarios para analizar el flujo, por ejemplo categoría, origen de datos o aceptación/corrección de la clasificación.

El historial se limita a consultas guardadas explícitamente por el usuario y permanece cifrado en el dispositivo.
