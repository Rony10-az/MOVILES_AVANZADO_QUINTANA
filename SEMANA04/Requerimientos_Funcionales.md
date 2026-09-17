# Requerimientos Funcionales — Sistema de Consulta de Estaciones del Metro de Lima

**Curso:** Desarrollo iOS — Swift (Xcode Playground)
**Semana:** 03 — Variables, arrays, diccionarios y funciones (sin struct/class)
**Alcance de datos:** Línea 1 (26 estaciones, operativa) y Línea 2 (27 estaciones, en construcción por tramos, 5 operativas en 2026)
**Versión:** v2 — agrega horarios de trenes por línea y mejora el formato de salida por consola

---

## 1. Objetivo del sistema

Construir una aplicación de consola (con proyección a versión móvil) que permita a un usuario consultar información de las estaciones del Metro de Lima: a qué línea pertenece cada estación, si tiene ascensor, si conecta con el Metropolitano, si es punto de transbordo con otra línea, y qué ruta conviene tomar entre dos estaciones.

---

## 2. Modelo de datos (lógica de almacenamiento)

Restricción del curso: **no se usan `struct` ni `class`**, solo `array` y `dictionary`.

| Estructura | Tipo Swift | Propósito |
|---|---|---|
| `estaciones` | `[String: [String: String]]` | Diccionario principal. La clave es el nombre de la estación; el valor es otro diccionario con los campos: `linea`, `estado`, `ascensor`, `metropolitano`, `transbordo`. |
| `lineas` | `[String: [String]]` | Diccionario que asocia cada línea con un **array** ordenado de sus estaciones (respeta el recorrido físico real). |
| `conexionesEntreLineas` | `[String: String]` | Diccionario que asocia el par de líneas (ej. `"Línea 1-Línea 2"`) con la estación donde se realiza el transbordo. |
| `horariosPorLinea` | `[String: [String: String]]` | **(Nuevo)** Diccionario que asocia cada línea con su horario referencial: `lunesAViernes`, `sabado`, `domingo`. |

Esta separación resuelve un problema real de Swift: **los diccionarios no garantizan orden**, por eso el recorrido de cada línea se guarda aparte, en un array.

---

## 3. Requerimientos funcionales por sección de lógica

### RF-01 — Consulta de estaciones por línea
**Lógica:** dado el nombre de una línea (ej. "Línea 2"), el sistema busca el array correspondiente en `lineas` y muestra, numerada, cada estación junto con su estado (operativa / en construcción).
**Entrada:** nombre de línea.
**Salida:** listado numerado de estaciones + estado.
**Función Swift:** `mostrarEstacionesDeLinea(_:)`

### RF-02 — Consulta de detalle de una estación
**Lógica:** dado el nombre de una estación, el sistema busca su nombre real de forma flexible (ignorando mayúsculas/minúsculas) y muestra los 5 atributos guardados: línea, estado, ascensor, conexión con Metropolitano y transbordo con otra línea.
**Entrada:** nombre de estación.
**Salida:** ficha con los 5 atributos, o mensaje de error si no existe.
**Funciones Swift:** `buscarNombreEstacion(_:)` (normaliza el texto) + `mostrarDetalleEstacion(_:)`

### RF-03 — Verificación de accesibilidad (ascensor)
**Lógica:** parte del detalle de la estación (RF-02). El campo `ascensor` indica "Sí" o "No". Dato real: en Línea 1, las estaciones **Pumacahua, Villa María, María Auxiliadora y San Borja Sur** no tienen ascensor (usan silla salvaescaleras); el resto sí.
**Regla de negocio:** si `ascensor == "No"`, el sistema debería (mejora futura) sugerir la estación accesible más cercana.

### RF-04 — Verificación de conexión con el Metropolitano
**Lógica:** parte del detalle de la estación (RF-02). El campo `metropolitano` indica si existe cruce físico con el corredor del Metropolitano. Actualmente solo **Estación Central (Línea 2)** tiene esta conexión registrada.
**Regla de negocio:** si el usuario consulta la ruta hacia una estación con `metropolitano == "Sí"`, el sistema lo informa como dato adicional (ver RF-06).

### RF-05 — Verificación de transbordo entre líneas
**Lógica:** parte del detalle de la estación (RF-02). El campo `transbordo` identifica si esa estación es (o será) punto de cruce con otra línea. Ejemplo real: **Gamarra / Arriola (Línea 1)** conecta con **28 de Julio (Línea 2)**.
**Regla de negocio:** estas estaciones son las candidatas que usa RF-06 para armar una ruta cuando origen y destino están en líneas distintas.

### RF-06 — Sugerencia de la mejor ruta entre dos estaciones (lógica principal)
**Lógica:**
1. El sistema valida que ambas estaciones (origen y destino) existan.
2. Si ambas pertenecen a la **misma línea** → responde que se puede llegar directo, sin transbordo.
3. Si pertenecen a **líneas distintas** → busca en `conexionesEntreLineas` la clave `"LíneaOrigen-LíneaDestino"`.
   - Si existe → indica en qué estación hacer el transbordo y qué línea tomar después.
   - Si no existe → informa que aún no hay una conexión directa registrada (dato real: solo Línea 1 ↔ Línea 2 está mapeada; Línea 3, 4 y 6 siguen en planificación).
4. Si la estación destino conecta con el Metropolitano, se agrega esa información como dato extra.
**Entrada:** estación de origen, estación de destino.
**Salida:** mensaje de ruta recomendada (directa o con transbordo) y alertas adicionales.
**Función Swift:** `sugerirRuta(origen:destino:)`

### RF-07 — Menú principal e interacción por consola
**Lógica:** bucle `while` controlado por una variable booleana que muestra 5 opciones (ver estaciones de una línea, ver detalle, buscar ruta, ver horario de una línea, salir), lee la opción con `readLine()` y deriva a la función correspondiente mediante `switch`.
**Entrada:** opción numérica (1-5).
**Salida:** ejecución de la función asociada o mensaje de opción inválida.
**Función Swift:** `menuPrincipal()`

### RF-08 — Validación de datos inexistentes
**Lógica transversal:** toda función que reciba un nombre de línea o estación debe validar su existencia (`guard let`) antes de operar, mostrando un mensaje de advertencia (`⚠️`) en vez de fallar o mostrar datos vacíos.

### RF-09 — Horario de trenes como pre-conexión de cada estación *(nuevo)*
**Lógica:** el diccionario `horariosPorLinea` guarda, por línea, el horario de lunes a viernes, sábado y domingo (dato oficial ATU / Metro de Lima, setiembre 2026). Este horario se muestra de dos formas:
1. Automáticamente dentro de RF-02 (detalle de estación): al consultar una estación, el sistema busca la línea a la que pertenece y muestra su horario justo después de los 5 atributos — es la "pre-conexión estación → horario" que pediste.
2. Por separado, como consulta independiente (opción 4 del menú).
**Entrada:** nombre de línea (implícito al consultar una estación, o explícito en la opción 4).
**Salida:** horario de lunes a viernes, sábado y domingo.
**Función Swift:** `mostrarHorarioDeLinea(_:)`

### RF-10 — Formato de salida encapsulado y legible *(nuevo)*
**Lógica:** dos funciones de apoyo generan el "empaquetado visual" de cada bloque de información:
- `imprimirTitulo(_:)` arma un marco con `=` del mismo ancho que el texto (usa `String(repeating:count:)`), para encabezar cada consulta.
- `imprimirSeparador()` imprime una raya de 60 guiones para cerrar cada bloque.
Todas las funciones de consulta (`mostrarEstacionesDeLinea`, `mostrarDetalleEstacion`, `sugerirRuta`, `mostrarHorarioDeLinea`) usan estas dos funciones al inicio y al final, así cada resultado queda separado y ordenado en la consola en vez de salir todo pegado.
**Entrada:** ninguna (son funciones de apoyo, reciben solo el texto del título).
**Salida:** texto con marco y rayas alrededor de cada bloque.

### RF-11 — Recorrido en texto de una línea (base para el futuro diagrama) *(nuevo)*
**Lógica:** dentro de RF-01, además del listado numerado, se imprime el array de estaciones unido con flechas (`estaciones.joined(separator: " → ")`), por ejemplo: `Villa El Salvador → Parque Industrial → Pumacahua → ...`.
**Aclaración importante:** esto **no es** el diagrama gráfico/visual de la red (ese se construirá aparte, con una herramienta de diseño, y no es lógica de Swift). Es solo una salida de texto que reutiliza el array `lineas` que ya existía, y que puede servir de referencia rápida mientras se diseña el diagrama.

---

## 4. Reglas de negocio (resumen)

1. Una estación pertenece **a una sola línea** (en este modelo).
2. El campo `estado` distingue estaciones **operativas** de las que están **en construcción** (relevante en Línea 2).
3. La accesibilidad (ascensor) es un atributo **independiente** de la conexión con otras líneas o con el Metropolitano.
4. El transbordo es la única vía modelada para "cambiar de línea"; si no hay transbordo conocido entre dos líneas, el sistema lo declara explícitamente en vez de inventar una ruta.

---

## 5. Alcance y limitaciones (para la sustentación)

- Solo se modelan **Línea 1** y **Línea 2**, porque son las únicas con estaciones nombradas oficialmente y suficiente información pública en 2026. Las conexiones con Línea 3, Línea 4 y Línea 6 se marcan como **"planificada"** porque esas líneas aún no tienen estaciones construidas.
- El "mejor camino" (RF-06) no calcula distancias ni tiempos reales (eso requeriría un grafo con pesos, fuera del alcance de semana 1-3); solo determina si hay ruta directa o transbordo conocido.
- Todo el detalle se guarda como `String` (incluyendo "Sí"/"No") porque el curso aún no permite `Bool` estructurado en tipos personalizados ni `struct/class`.
- El horario (RF-09) es **por línea**, no por estación individual ni por sentido del recorrido (no distingue "hacia Bayóvar" de "hacia Villa El Salvador"); es el nivel de detalle que publica oficialmente ATU/Metro de Lima y es razonable para el alcance del curso.
- El diagrama visual de la red (RF-11) queda fuera de la lógica Swift a propósito: se construirá como un recurso gráfico aparte. El programa solo aporta el recorrido ordenado en texto que puede usarse como referencia al diseñarlo.

---

## 6. Fuentes consultadas

- [Línea 1 del Metro de Lima y Callao — Wikipedia](https://es.wikipedia.org/wiki/L%C3%ADnea_1_del_Metro_de_Lima_y_Callao)
- [Línea 2 del Metro de Lima y Callao — Wikipedia](https://es.wikipedia.org/wiki/L%C3%ADnea_2_del_Metro_de_Lima_y_Callao)
- [Línea 1 Metro Lima: estaciones — metrolima.info](https://metrolima.info/metro/linea-1/)
- [Línea 2 Metro de Lima: estaciones — metrolima.net](https://metrolima.net/linea-2/)
- [Accesibilidad y ascensores — lineauno.pe](https://www.lineauno.pe/preguntas/las-estaciones-de-linea1-cuentan-con-accesos-para-personas-con-movilidad-reducida/)
- [Línea 1 oficializa horarios de atención para septiembre 2026 — La República](https://larepublica.pe/sociedad/2026/09/04/linea-1-del-metro-de-lima-oficializa-horarios-de-atencion-para-septiembre-de-2026-207920)
- [Horario Línea 2 Metro de Lima 2026 — metrolima.net](https://metrolima.net/horario-linea-2/)
- [Serán 9 líneas en total — Plan de Movilidad Urbana ATU — La República](https://larepublica.pe/sociedad/2026/02/11/las-tres-nuevas-lineas-de-metro-que-propone-la-atu-para-lima-y-callao-seran-nueve-en-total-hnews-765457)
- Mapa oficial de referencia: [Lima Metro Map (Wikimedia)](https://upload.wikimedia.org/wikipedia/commons/0/05/Lima_Metro_Map.svg)
