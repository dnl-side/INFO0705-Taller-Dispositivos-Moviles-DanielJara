# Firebase - Unidad 3

La Unidad 3 utiliza el mismo proyecto Firebase configurado para UNIACC Orienta y agrega dos servicios orientados a mejora continua:

- Firebase Analytics
- Firebase Remote Config

## Analytics

La aplicación registra eventos técnicos y de interacción. No se registra el texto libre escrito por el estudiante.

Eventos utilizados:

- `u3_orientation_started`
- `u3_classification_accepted`
- `u3_classification_corrected`
- `u3_resource_loaded`
- `u3_cache_used`
- `u3_history_saved`
- `u3_history_unlocked`
- `u3_orientation_completed`

Los parámetros se limitan a valores categóricos como categoría académica, origen del recurso y variante de interfaz.

Para comprobar eventos durante desarrollo puede habilitarse Analytics DebugView desde el esquema de Xcode agregando el argumento:

```
-FIRAnalyticsDebugEnabled
```

## Remote Config

Parámetro utilizado:

```
unit3_low_confidence_variant
```

Valores soportados:

- `focused`: muestra las tres categorías priorizadas por el clasificador.
- `expanded`: muestra las categorías priorizadas y luego el resto de opciones.

La aplicación incluye `focused` como valor local por defecto, por lo que funciona aunque Remote Config todavía no tenga un parámetro publicado.

Para probar la configuración remota:

1. Abrir Firebase Console.
2. Ir a Remote Config.
3. Crear `unit3_low_confidence_variant`.
4. Asignar `focused` o `expanded`.
5. Publicar los cambios.
6. Reiniciar o volver a entrar en la Unidad 3 para ejecutar fetch + activate.

Posteriormente el mismo parámetro puede utilizarse en Firebase A/B Testing, definiendo una variante por grupo y utilizando eventos de Analytics como métricas del experimento.

## Privacidad

El texto de las consultas académicas puede contener información personal. Por ese motivo no se envía a Analytics ni a Remote Config.

El historial protegido se almacena únicamente en el dispositivo:

- contenido cifrado con AES-GCM;
- clave de cifrado almacenada en Keychain;
- acceso a la interfaz mediante LocalAuthentication.
