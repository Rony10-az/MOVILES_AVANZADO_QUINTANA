// ============================================================================
// PROYECTO: Sistema de Consulta de Estaciones - Metro de Lima
// CURSO: Desarrollo iOS - Swift (Xcode Playground)
// SEMANA: 03 - Solo se usan: variables, arrays, diccionarios y funciones
// RESTRICCIÓN: NO se usan struct ni class (según indicación del docente)
// FUENTE DE DATOS: Línea 1 y Línea 2 del Metro de Lima (Wikipedia, ATU y
// portales oficiales de información del Metro de Lima, consultados en 2026)
// ============================================================================
//
// NOVEDADES DE ESTA VERSIÓN (v2):
// - Se agregó el horario referencial de trenes por línea (RF-09), mostrado
//   también dentro del detalle de cada estación (pre-conexión estación-horario).
// - Se mejoró la salida por consola: títulos encerrados en marcos y rayas
//   separadoras para que cada bloque de información se lea con claridad (RF-10).
// - Se agregó un "recorrido en texto" (estación → estación → estación) dentro
//   de la consulta por línea: no reemplaza el diagrama gráfico que se hará
//   aparte, pero sí es lógica pura (unión de un array) y sirve de referencia.
// ============================================================================

import Foundation // Se importa Foundation para poder usar funciones de texto como lowercased()

// ----------------------------------------------------------------------------
// 1. BASE DE DATOS: DICCIONARIO DE ESTACIONES
// ----------------------------------------------------------------------------
// Cada estación es una CLAVE (String) y su VALOR es otro diccionario [String:String]
// con los detalles pedidos: línea, estado, ascensor, conexión con Metropolitano
// y conexión (transbordo) con otra línea en un paradero específico.
// No se usa struct/class: todo el detalle se guarda como texto ("Sí"/"No").
let estaciones: [String: [String: String]] = [

    // ---------------------- LÍNEA 1 (26 estaciones, 100% operativa) ----------------------
    "Villa El Salvador": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Villa El Salvador", "referencias": "Terminal sur de la línea, zona central de Villa El Salvador"],
    "Parque Industrial": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Villa El Salvador", "referencias": "Junto al Parque Industrial de Villa El Salvador"],
    "Pumacahua": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Villa María del Triunfo", "referencias": "Zona alta de Villa María del Triunfo, cerca a la Av. Pachacútec"],
    "Villa María": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Villa María del Triunfo", "referencias": "Villa María del Triunfo, sobre la Av. Pachacútec"],
    "María Auxiliadora": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Villa María del Triunfo", "referencias": "Junto al Hospital María Auxiliadora"],
    "San Juan": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Miraflores", "referencias": "San Juan de Miraflores, cerca al mercado zonal"],
    "Atocongo": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 3 (planificada)", "distrito": "San Juan de Miraflores", "referencias": "Junto al Óvalo Atocongo, nudo de buses hacia el sur de Lima"],
    "Jorge Chávez": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santiago de Surco", "referencias": "Límite entre Santiago de Surco y San Juan de Miraflores"],
    "Ayacucho": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santiago de Surco", "referencias": "Zona residencial de Santiago de Surco"],
    "Cabitos": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 3 (planificada)", "distrito": "Santiago de Surco", "referencias": "Cerca al cuartel militar conocido como Los Cabitos"],
    "Angamos": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 6 (planificada)", "distrito": "San Borja", "referencias": "Cruce con la Av. Angamos y la Vía Expresa, cerca a Surquillo"],
    "San Borja Sur": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Borja", "referencias": "Zona residencial de San Borja, cerca a la Av. Aviación"],
    "La Cultura": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 4 (planificada)", "distrito": "San Borja", "referencias": "Junto al Museo de la Nación y el Coliseo Eduardo Dibós"],
    "Arriola": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 2 (en construcción)", "distrito": "La Victoria", "referencias": "Zona comercial de La Victoria, sobre la Av. Nicolás Arriola"],
    "Gamarra": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 2 (en construcción)", "distrito": "La Victoria", "referencias": "Emporio comercial y textil de Gamarra"],
    "Miguel Grau": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Cercado de Lima", "referencias": "Cercado de Lima, cerca al centro histórico"],
    "El Ángel": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "El Agustino", "referencias": "El Agustino, cerca al Cementerio El Ángel"],
    "Presbítero Maestro": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Cercado de Lima", "referencias": "Junto al Cementerio Presbítero Maestro"],
    "Caja de Agua": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "San Juan de Lurigancho, zona conocida como Caja de Agua"],
    "Pirámide del Sol": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "San Juan de Lurigancho, cerca a la huaca que da nombre a la zona"],
    "Los Jardines": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "Zona residencial Los Jardines, San Juan de Lurigancho"],
    "Los Postes": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "Zona residencial Los Postes, San Juan de Lurigancho"],
    "San Carlos": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "Zona San Carlos, San Juan de Lurigancho"],
    "San Martín": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "Zona San Martín, San Juan de Lurigancho"],
    "Santa Rosa": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "Zona Santa Rosa, San Juan de Lurigancho"],
    "Bayóvar": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "San Juan de Lurigancho", "referencias": "Zona comercial de Bayóvar, uno de los sectores más poblados de SJL"],

    // ---------------------- LÍNEA 2 (27 estaciones, en construcción por tramos) ----------------------
    "Evitamiento": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Ate", "referencias": "Sobre la Vía de Evitamiento, en Ate"],
    "Óvalo Santa Anita": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santa Anita", "referencias": "Junto al óvalo principal de Santa Anita"],
    "Colectora Industrial": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santa Anita", "referencias": "Zona industrial de Santa Anita"],
    "Hermilio Valdizán": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santa Anita", "referencias": "Cerca al Hospital Hermilio Valdizán"],
    "Mercado Santa Anita": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santa Anita", "referencias": "Junto al Mercado Mayorista de Santa Anita"],
    "Vista Alegre": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Santa Anita", "referencias": "Zona Vista Alegre, Santa Anita"],
    "Prolongación Javier Prado": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "El Agustino", "referencias": "Sobre la Av. Javier Prado (prolongación), El Agustino"],
    "Municipalidad de Ate": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Ate", "referencias": "Junto al Palacio Municipal de Ate"],
    "Circunvalación": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "El Agustino", "referencias": "Sobre la Av. Circunvalación, El Agustino"],
    "San Juan de Dios": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "El Agustino", "referencias": "El Agustino, zona San Juan de Dios"],
    "Nicolás Ayllón": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "El Agustino", "referencias": "Sobre la Av. Nicolás Ayllón, El Agustino"],
    "28 de Julio": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 1 (Gamarra / Arriola)", "distrito": "La Victoria", "referencias": "Sobre la Av. 28 de Julio, La Victoria (cruce con Línea 1)"],
    "Cangallo": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Cercado de Lima", "referencias": "Cercado de Lima, sobre el Jr. Cangallo"],
    "Plaza Manco Cápac": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "La Victoria", "referencias": "Junto a la Plaza Manco Cápac, La Victoria"],
    "Estación Central": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "Sí", "transbordo": "Línea 4 (planificada)", "distrito": "Cercado de Lima", "referencias": "Cerca de la Av. Emancipación, centro histórico de Lima"],
    "Plaza Bolognesi": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Breña", "referencias": "Junto a la Plaza Bolognesi, límite Breña/Cercado"],
    "Parque Murillo": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Breña", "referencias": "Breña, cerca al Parque Murillo"],
    "Tingo María": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Breña", "referencias": "Breña, zona Tingo María"],
    "La Alborada": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Breña", "referencias": "Breña, zona La Alborada"],
    "Elio": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Bellavista", "referencias": "Bellavista (Callao), zona Elio"],
    "San Marcos": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Bellavista", "referencias": "Bellavista (Callao), zona San Marcos"],
    "Óscar R. Benavides": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Bellavista", "referencias": "Sobre la Av. Óscar R. Benavides (ex Av. Colonial), Bellavista"],
    "Carmen de La Legua": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Carmen de la Legua Reynoso", "referencias": "Carmen de la Legua Reynoso, zona central"],
    "Insurgentes": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Carmen de la Legua Reynoso", "referencias": "Sobre la Av. Los Insurgentes, Carmen de la Legua"],
    "Juan Pablo II": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Callao", "referencias": "Callao, zona Juan Pablo II"],
    "Buenos Aires": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Callao", "referencias": "Sobre la Av. Buenos Aires, Callao"],
    "Puerto del Callao": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna", "distrito": "Callao", "referencias": "Terminal de la línea, cerca al Puerto del Callao"]
] // Fin del diccionario principal de estaciones

// ----------------------------------------------------------------------------
// 2. ARRAYS: ORDEN FÍSICO DE LAS ESTACIONES POR LÍNEA
// ----------------------------------------------------------------------------
// Un diccionario no garantiza orden, por eso guardamos el recorrido real
// de cada línea en un array dentro de otro diccionario [String: [String]]
let lineas: [String: [String]] = [
    "Línea 1": [ // Array con el recorrido de sur a norte de la Línea 1
        "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María", // Tramo sur
        "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho", // Tramo sur-centro
        "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra", // Tramo centro
        "Miguel Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua", // Tramo centro-norte
        "Pirámide del Sol", "Los Jardines", "Los Postes", "San Carlos", // Tramo norte
        "San Martín", "Santa Rosa", "Bayóvar" // Tramo final norte
    ], // Total: 26 estaciones
    "Línea 2": [ // Array con el recorrido de este a oeste (Callao) de la Línea 2
        "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán", // Tramo ya operativo
        "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado", "Municipalidad de Ate", // Tramo este
        "Circunvalación", "San Juan de Dios", "Nicolás Ayllón", "28 de Julio", "Cangallo", // Tramo centro-este
        "Plaza Manco Cápac", "Estación Central", "Plaza Bolognesi", "Parque Murillo", // Tramo centro
        "Tingo María", "La Alborada", "Elio", "San Marcos", "Óscar R. Benavides", // Tramo centro-oeste
        "Carmen de La Legua", "Insurgentes", "Juan Pablo II", "Buenos Aires", "Puerto del Callao" // Tramo Callao
    ] // Total: 27 estaciones
] // Fin del diccionario de recorridos por línea

// ----------------------------------------------------------------------------
// 3. DICCIONARIO DE CONEXIONES ENTRE LÍNEAS (para sugerir rutas)
// ----------------------------------------------------------------------------
// Guarda, para cada par de líneas, en qué estación(es) se puede hacer transbordo
let conexionesEntreLineas: [String: String] = [
    "Línea 1-Línea 2": "En Gamarra / Arriola (Línea 1) conectando con 28 de Julio (Línea 2)", // Conexión 1 <-> 2
    "Línea 2-Línea 1": "En 28 de Julio (Línea 2) conectando con Gamarra / Arriola (Línea 1)" // Conexión 2 <-> 1 (misma info, orden inverso)
] // Fin del diccionario de conexiones

// ----------------------------------------------------------------------------
// 4. DICCIONARIO DE HORARIOS DE TRENES POR LÍNEA
// ----------------------------------------------------------------------------
// Horario referencial oficial (ATU / Metro de Lima), setiembre 2026.
let horariosPorLinea: [String: [String: String]] = [
    "Línea 1": [ // Horario oficial de la Línea 1 (setiembre 2026)
        "lunesAViernes": "05:00 a 22:00 (frecuencia de 3 a 10 min; cada 3 min en hora punta)", // L-V
        "sabado": "05:00 a 22:00 (frecuencia de 3.5 a 10 min)", // Sábado
        "domingo": "05:30 a 22:00 (frecuencia de 6 a 12 min)" // Domingo
    ], // Fin horario Línea 1
    "Línea 2": [ // Horario referencial del tramo operativo de la Línea 2
        "lunesAViernes": "06:00 a 23:00 (hora punta 07:00-09:00 y 18:00-20:00)", // L-V
        "sabado": "06:00 a 23:00 (hora punta 07:00-09:00 y 18:00-20:00)", // Sábado
        "domingo": "06:00 a 23:00 (hora punta única de 18:00 a 20:00)" // Domingo
    ] // Fin horario Línea 2
] // Fin del diccionario de horarios (sujeto a cambios oficiales de ATU)

// ----------------------------------------------------------------------------
// 5. FUNCIONES DE BÚSQUEDA FLEXIBLE (NUEVO - ya no depende de tildes exactas)
// ----------------------------------------------------------------------------
func normalizar(_ texto: String) -> String { // Función central: quita tildes y pasa todo a minúsculas
    return texto.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es_PE")) // "Línea" y "linea" quedan iguales
} // Fin de la función normalizar

func buscarNombreEstacion(_ textoIngresado: String) -> String? { // Recibe el texto escrito por el usuario
    let textoNormalizado = normalizar(textoIngresado) // Normaliza el texto ingresado (sin tildes, minúsculas)
    for claveEstacion in estaciones.keys { // Recorre todas las claves (nombres) del diccionario de estaciones
        if normalizar(claveEstacion) == textoNormalizado { // Compara ignorando tildes y mayúsculas/minúsculas
            return claveEstacion // Devuelve el nombre exacto tal como está guardado en el diccionario
        } // Cierra el if de comparación
    } // Cierra el for de recorrido
    return nil // Si no se encontró ninguna coincidencia, devuelve nil
} // Fin de la función buscarNombreEstacion

func buscarNombreLinea(_ textoIngresado: String) -> String? { // Igual que buscarNombreEstacion, pero para líneas
    let textoNormalizado = normalizar(textoIngresado) // Normaliza el texto ingresado
    for claveLinea in lineas.keys { // Recorre las claves del diccionario de líneas ("Línea 1", "Línea 2")
        if normalizar(claveLinea) == textoNormalizado { // Compara ignorando tildes y mayúsculas/minúsculas
            return claveLinea // Devuelve el nombre exacto de la línea
        } // Cierra el if
    } // Cierra el for
    return nil // Si no encontró coincidencia, devuelve nil
} // Fin de la función buscarNombreLinea

// ----------------------------------------------------------------------------
// 6. FUNCIONES DE FORMATO: encapsular la salida por consola
// ----------------------------------------------------------------------------
func imprimirSeparador() { // Función simple que dibuja una raya divisoria
    print(String(repeating: "-", count: 60)) // Repite el guion 60 veces y lo imprime
} // Fin de la función imprimirSeparador

func imprimirTitulo(_ texto: String) { // Función que imprime un título dentro de un marco
    let borde = String(repeating: "=", count: texto.count + 4) // Crea una raya del mismo ancho que el texto
    print("\n" + borde) // Imprime el borde superior, con una línea en blanco antes
    print("| \(texto) |") // Imprime el texto centrado entre dos barras verticales
    print(borde) // Imprime el borde inferior, cerrando el marco
} // Fin de la función imprimirTitulo

// ----------------------------------------------------------------------------
// 7. FUNCIÓN: Mostrar todas las estaciones de una línea (Requerimiento 1)
// ----------------------------------------------------------------------------
func mostrarEstacionesDeLinea(_ nombreLinea: String) { // Recibe el nombre de la línea, ej "linea 2" (sin tilde también sirve)
    guard let lineaReal = buscarNombreLinea(nombreLinea) else { // Normaliza y valida que la línea exista
        print("⚠️ No existe información registrada para '\(nombreLinea)'.") // Mensaje si la línea no existe
        return // Sale de la función si no encontró la línea
    } // Cierra el guard
    let listaEstaciones = lineas[lineaReal] ?? [] // Obtiene el array de estaciones de esa línea (ya con el nombre real)
    imprimirTitulo("ESTACIONES DE \(lineaReal.uppercased()) (\(listaEstaciones.count) EN TOTAL)") // Título encuadrado
    for (indice, nombreEstacion) in listaEstaciones.enumerated() { // Recorre el array con su índice
        let detalle = estaciones[nombreEstacion] ?? [:] // Obtiene el detalle de esa estación
        let estado = detalle["estado"] ?? "Desconocido" // Extrae el estado (operativa / en construcción)
        print("\(indice + 1). \(nombreEstacion) - \(estado)") // Imprime numeración, nombre y estado
    } // Cierra el for
    imprimirSeparador() // Raya de cierre para separar este bloque del siguiente
    print("🗺️  Recorrido: " + listaEstaciones.joined(separator: " → ")) // Une el array con flechas: vista rápida tipo "diagrama en texto"
    imprimirSeparador() // Raya final del bloque
} // Fin de la función mostrarEstacionesDeLinea

// ----------------------------------------------------------------------------
// 8. FUNCIÓN: Mostrar el detalle completo de una estación (Requerimiento 2)
// ----------------------------------------------------------------------------
func mostrarDetalleEstacion(_ nombreEstacion: String) { // Recibe el nombre de la estación a consultar
    guard let nombreReal = buscarNombreEstacion(nombreEstacion) else { // Normaliza y valida que la estación exista
        print("⚠️ La estación '\(nombreEstacion)' no fue encontrada. Verifica el nombre.") // Mensaje de error
        return // Sale de la función si la estación no existe
    } // Cierra el guard
    let detalle = estaciones[nombreReal] ?? [:] // Obtiene el diccionario de detalles de la estación
    let lineaDeLaEstacion = detalle["linea"] ?? "" // Guarda la línea a la que pertenece, para buscar su horario
    imprimirTitulo("DETALLE DE \(nombreReal.uppercased())") // Título encuadrado con el nombre de la estación
    print("Distrito.......................: \(detalle["distrito"] ?? "N/D")") // Imprime el distrito donde está
    print("Línea..........................: \(detalle["linea"] ?? "N/D")") // Imprime a qué línea pertenece
    print("Estado.........................: \(detalle["estado"] ?? "N/D")") // Imprime si está operativa o en construcción
    print("Ascensor.......................: \(detalle["ascensor"] ?? "N/D")") // Imprime si tiene ascensor
    print("Conexión con Metropolitano.....: \(detalle["metropolitano"] ?? "N/D")") // Imprime conexión con Metropolitano
    print("Transbordo con otra línea......: \(detalle["transbordo"] ?? "N/D")")//Imprime si conecta con otra línea
    print("Referencias (cómo ubicarte)....: \(detalle["referencias"] ?? "Pendiente de completar por el equipo")") // Punto de referencia cercano
    imprimirSeparador() // Raya que separa el detalle del horario (pre-conexión estación → horario)
    if let horarioLinea = horariosPorLinea[lineaDeLaEstacion] { // Busca el horario de la línea de esta estación
        print("🕒 Horario referencial de \(lineaDeLaEstacion):") // Encabezado del bloque de horario
        print("   Lunes a viernes: \(horarioLinea["lunesAViernes"] ?? "N/D")") // Horario de lunes a viernes
        print("   Sábado.........: \(horarioLinea["sabado"] ?? "N/D")") // Horario de sábado
        print("   Domingo........: \(horarioLinea["domingo"] ?? "N/D")") // Horario de domingo
    } else { // Si la línea no tiene horario registrado todavía
        print("🕒 Aún no hay horario oficial registrado para \(lineaDeLaEstacion).") // Mensaje alternativo
    } // Cierra el if/else de horario
    imprimirSeparador() // Raya final del bloque de detalle
} // Fin de la función mostrarDetalleEstacion

// ----------------------------------------------------------------------------
// 9. FUNCIÓN: Mostrar el horario de una línea por separado
// ----------------------------------------------------------------------------
func mostrarHorarioDeLinea(_ nombreLinea: String) { // Recibe el nombre de la línea a consultar
    guard let lineaReal = buscarNombreLinea(nombreLinea) else { // Normaliza y valida que la línea exista
        print("⚠️ No existe información registrada para '\(nombreLinea)'.") // Mensaje si no existe esa línea
        return // Sale de la función si no se encontró la línea
    } // Cierra el guard
    let horario = horariosPorLinea[lineaReal] ?? [:] // Obtiene el horario de esa línea
    imprimirTitulo("HORARIO DE \(lineaReal.uppercased())") // Título encuadrado
    print("Lunes a viernes: \(horario["lunesAViernes"] ?? "N/D")") // Imprime el horario de lunes a viernes
    print("Sábado.........: \(horario["sabado"] ?? "N/D")") // Imprime el horario de sábado
    print("Domingo........: \(horario["domingo"] ?? "N/D")") // Imprime el horario de domingo
    imprimirSeparador() // Raya de cierre del bloque
} // Fin de la función mostrarHorarioDeLinea

// ----------------------------------------------------------------------------
// 10. FUNCIÓN: Buscar estaciones por DISTRITO de destino (NUEVO)
// ----------------------------------------------------------------------------
// Resuelve el caso que planteaste: el usuario conoce el DISTRITO al que
// quiere llegar (ej. "Surco"), no el nombre exacto de la estación.
func buscarPorDistrito(_ distritoIngresado: String) -> [String] { // Devuelve todas las estaciones de un distrito
    let distritoNormalizado = normalizar(distritoIngresado) // Normaliza el texto ingresado (sin tildes, minúsculas)
    var resultado: [String] = [] // Array vacío donde se guardarán las coincidencias
    for (nombreEstacion, detalle) in estaciones { // Recorre todas las estaciones del diccionario principal
        let distritoEstacion = detalle["distrito"] ?? "" // Obtiene el distrito registrado de esa estación
        if normalizar(distritoEstacion) == distritoNormalizado { // Compara ignorando tildes y mayúsculas/minúsculas
            resultado.append(nombreEstacion) // Agrega la estación al array de resultados
        } // Cierra el if
    } // Cierra el for
    return resultado // Devuelve el array con todas las estaciones encontradas (puede quedar vacío)
} // Fin de la función buscarPorDistrito

func sugerirRutaPorDistrito(origen: String, distritoDestino: String) { // Ej: origen "Villa El Salvador", distrito "Surco"
    guard let origenReal = buscarNombreEstacion(origen) else { // Valida que el origen exista
        print("⚠️ La estación de origen '\(origen)' no fue encontrada.") // Mensaje de error de origen
        return // Sale de la función si el origen no existe
    } // Cierra el guard
    let estacionesEnDistrito = buscarPorDistrito(distritoDestino) // Busca todas las estaciones de ese distrito
    imprimirTitulo("CÓMO LLEGAR A \(distritoDestino.uppercased()) DESDE \(origenReal.uppercased())") // Título encuadrado
    if estacionesEnDistrito.isEmpty { // Si no hay ninguna estación registrada en ese distrito
        print("❌ No hay ninguna estación de Línea 1 o Línea 2 registrada en el distrito '\(distritoDestino)'.") // Aviso
        print("   Puede que ese distrito no tenga estación todavía, o el nombre esté escrito distinto al oficial.") // Sugerencia
        imprimirSeparador() // Raya de cierre
        return // Sale porque no hay con qué continuar
    } // Cierra el if de distrito vacío
    print("📍 Estaciones encontradas en \(distritoDestino):") // Encabezado del listado
    for estacionCandidata in estacionesEnDistrito { // Recorre cada estación encontrada en el distrito
        let lineaCandidata = estaciones[estacionCandidata]?["linea"] ?? "N/D" // Obtiene la línea de esa estación
        print("   - \(estacionCandidata) (\(lineaCandidata))") // Imprime nombre y línea de cada candidata
    } // Cierra el for de listado
    imprimirSeparador() // Raya que separa el listado de la ruta sugerida
    if let primeraOpcion = estacionesEnDistrito.first { // Toma la primera estación encontrada como destino de referencia
        print("Tomando como referencia '\(primeraOpcion)':") // Avisa cuál estación se usará para calcular la ruta
        sugerirRuta(origen: origenReal, destino: primeraOpcion) // Reutiliza toda la lógica ya construida en sugerirRuta
    } // Cierra el if
} // Fin de la función sugerirRutaPorDistrito

// ----------------------------------------------------------------------------
// 11. FUNCIÓN: Sugerir la mejor línea/estación para llegar a un destino (Requerimiento 3)
// ----------------------------------------------------------------------------
func sugerirRuta(origen: String, destino: String) { // Recibe estación de origen y estación de destino
    guard let origenReal = buscarNombreEstacion(origen) else { // Valida que el origen exista
        print("⚠️ La estación de origen '\(origen)' no fue encontrada.") // Mensaje de error de origen
        return // Sale de la función si el origen no existe
    } // Cierra el guard de origen
    guard let destinoReal = buscarNombreEstacion(destino) else { // Valida que el destino exista
        print("⚠️ La estación de destino '\(destino)' no fue encontrada.") // Mensaje de error de destino
        return // Sale de la función si el destino no existe
    } // Cierra el guard de destino
    let detalleOrigen = estaciones[origenReal] ?? [:] // Obtiene detalle de la estación de origen
    let detalleDestino = estaciones[destinoReal] ?? [:] // Obtiene detalle de la estación de destino
    let lineaOrigen = detalleOrigen["linea"] ?? "" // Extrae la línea del origen
    let lineaDestino = detalleDestino["linea"] ?? "" // Extrae la línea del destino
    let estadoOrigen = detalleOrigen["estado"] ?? "Desconocido" // Extrae el estado del origen (Operativa / En construcción)
    let estadoDestino = detalleDestino["estado"] ?? "Desconocido" // Extrae el estado del destino
    imprimirTitulo("RUTA SUGERIDA: \(origenReal.uppercased()) → \(destinoReal.uppercased())") // Título encuadrado de la consulta
    if estadoOrigen != "Operativa" { // FIX: avisa si la estación de origen todavía no está habilitada
        print("⚠️ Atención: '\(origenReal)' figura como '\(estadoOrigen)', todavía NO está habilitada para viajar.") // Aviso de origen
    } // Cierra el if de estado de origen
    if estadoDestino != "Operativa" { // FIX: avisa si la estación de destino todavía no está habilitada
        print("⚠️ Atención: '\(destinoReal)' figura como '\(estadoDestino)', todavía NO está habilitada para viajar.") // Aviso de destino
    } // Cierra el if de estado de destino
    if lineaOrigen == lineaDestino { // Caso 1: ambas estaciones están en la misma línea
        print("✅ Puedes llegar directo: toma \(lineaOrigen) desde \(origenReal) hasta \(destinoReal). No necesitas transbordo.") // Ruta directa
    } else { // Caso 2: las estaciones están en líneas diferentes
        let clave = "\(lineaOrigen)-\(lineaDestino)" // Arma la clave para buscar en el diccionario de conexiones
        if let conexion = conexionesEntreLineas[clave] { // Busca si existe una conexión conocida entre ambas líneas
            print("🔄 Debes hacer transbordo: toma \(lineaOrigen) y baja en el punto de conexión.") // Indica que hay transbordo
            print("   Conexión sugerida: \(conexion)") // Muestra el detalle de dónde hacer el transbordo
            print("   Luego continúa en \(lineaDestino) hasta \(destinoReal).") // Indica la línea final a tomar
        } else { // Caso 3: no hay una conexión registrada entre esas dos líneas
            print("❌ Aún no existe una conexión directa registrada entre \(lineaOrigen) y \(lineaDestino) con la información disponible.") // Mensaje de ruta no encontrada
        } // Cierra el if/else de búsqueda de conexión
    } // Cierra el if/else de comparación de líneas
    if detalleDestino["metropolitano"] == "Sí" { // Verifica si el destino conecta con el Metropolitano
        print("ℹ️ Dato extra: \(destinoReal) también conecta con el Metropolitano.") // Informa la conexión adicional
    } // Cierra el if de Metropolitano
    if estadoOrigen != "Operativa" || estadoDestino != "Operativa" { // FIX: recordatorio final si algo no está habilitado
        print("ℹ️ Recuerda: la ruta de arriba es solo REFERENCIAL, no la podrás usar hasta que esa estación entre en operación.") // Aclaración final
    } // Cierra el if final de advertencia
    imprimirSeparador() // Raya que cierra el bloque de la ruta sugerida
} // Fin de la función sugerirRuta

// ----------------------------------------------------------------------------
// BLOQUE 1A: Diccionario estructurado de transbordos (para poder CONTAR estaciones)
// ----------------------------------------------------------------------------
// conexionesEntreLineas ya existe pero guarda un texto libre; para calcular
// cuántas estaciones faltan necesitamos los nombres separados y "limpios".
let estacionesDeTransbordo: [String: [String: String]] = [
    "Línea 1-Línea 2": ["enEstaLinea": "Gamarra", "enLineaDestino": "28 de Julio"], // Transbordo yendo de L1 a L2
    "Línea 2-Línea 1": ["enEstaLinea": "28 de Julio", "enLineaDestino": "Gamarra"]  // Transbordo yendo de L2 a L1
] // Fin del diccionario de transbordos estructurado

// ----------------------------------------------------------------------------
// BLOQUE 1B: Función auxiliar para saber en qué POSICIÓN va una estación
// ----------------------------------------------------------------------------
func obtenerIndiceEnLinea(_ nombreEstacion: String, _ listaEstaciones: [String]) -> Int? { // Recibe la estación y el array de la línea
    for (indice, estacion) in listaEstaciones.enumerated() { // Recorre el array con su posición (índice)
        if estacion == nombreEstacion { // Si la estación actual es la que buscamos
            return indice // Devuelve la posición donde está
        } // Cierra el if
    } // Cierra el for
    return nil // Si no la encontró en esa línea, devuelve nil
} // Fin de la función obtenerIndiceEnLinea

// ----------------------------------------------------------------------------
// BLOQUE 1C: PLANIFICADOR DE VIAJE (nuevo requerimiento)
// ----------------------------------------------------------------------------
// Responde exactamente lo que pediste: cuántas estaciones faltan y cuáles
// hay que pasar para llegar al destino. Pensado para alguien que recién
// empieza a usar el sistema (por eso muestra el recorrido paso a paso).
func planificarViaje(origen: String, destino: String) { // Recibe estación de origen y de destino
    guard let origenReal = buscarNombreEstacion(origen) else { // Valida que el origen exista (ya sin tildes gracias a normalizar)
        print("⚠️ La estación de origen '\(origen)' no fue encontrada.") // Aviso de error
        return // Sale si no existe
    } // Cierra el guard
    guard let destinoReal = buscarNombreEstacion(destino) else { // Valida que el destino exista
        print("⚠️ La estación de destino '\(destino)' no fue encontrada.") // Aviso de error
        return // Sale si no existe
    } // Cierra el guard
    let detalleOrigen = estaciones[origenReal] ?? [:] // Detalle completo del origen
    let detalleDestino = estaciones[destinoReal] ?? [:] // Detalle completo del destino
    let lineaOrigen = detalleOrigen["linea"] ?? "" // Línea a la que pertenece el origen
    let lineaDestino = detalleDestino["linea"] ?? "" // Línea a la que pertenece el destino
    imprimirTitulo("PLANIFICADOR DE VIAJE: \(origenReal.uppercased()) → \(destinoReal.uppercased())") // Título encuadrado
    if lineaOrigen == lineaDestino { // Caso simple: todo dentro de la misma línea, sin transbordo
        let listaEstaciones = lineas[lineaOrigen] ?? [] // Array ordenado de esa línea
        guard let indiceOrigen = obtenerIndiceEnLinea(origenReal, listaEstaciones), // Posición del origen
              let indiceDestino = obtenerIndiceEnLinea(destinoReal, listaEstaciones) else { // Posición del destino
            print("⚠️ No se pudo ubicar alguna estación dentro de \(lineaOrigen).") // Caso raro de error
            imprimirSeparador() // Cierra el bloque igual
            return // Sale de la función
        } // Cierra el guard doble
        let estacionesAPasar = abs(indiceDestino - indiceOrigen) // Resta las posiciones: eso son las paradas de diferencia
        print("🚈 Misma línea: \(lineaOrigen). No necesitas transbordo.") // Mensaje principal
        print("   Te faltan \(estacionesAPasar) estación(es) desde \(origenReal) hasta \(destinoReal).") // Respuesta pedida
        let inicio = min(indiceOrigen, indiceDestino) // Índice menor entre origen y destino
        let fin = max(indiceOrigen, indiceDestino) // Índice mayor entre origen y destino
        var tramo: [String] = [] // Array donde armamos el recorrido paso a paso
        var i = inicio // Contador que arranca en el índice menor
        while i <= fin { // Mientras no pasemos el índice mayor
            tramo.append(listaEstaciones[i]) // Agrega la estación de esa posición al tramo
            i += 1 // Avanza una posición
        } // Cierra el while
        if indiceOrigen > indiceDestino { // Si el usuario viaja "hacia atrás" en el array
            tramo.reverse() // Invierte el orden para que se lea desde el origen real
        } // Cierra el if
        print("   Recorrido: " + tramo.joined(separator: " → ")) // Muestra estación por estación
    } else { // Caso con transbordo: dos líneas distintas
        let clave = "\(lineaOrigen)-\(lineaDestino)" // Arma la clave para buscar el transbordo
        guard let transbordo = estacionesDeTransbordo[clave] else { // Busca el punto de cambio de línea
            print("❌ Aún no hay una conexión registrada entre \(lineaOrigen) y \(lineaDestino).") // Sin conexión conocida
            imprimirSeparador() // Cierra el bloque
            return // Sale de la función
        } // Cierra el guard
        let estacionCambioOrigen = transbordo["enEstaLinea"] ?? "" // Estación de transbordo en la línea de origen
        let estacionCambioDestino = transbordo["enLineaDestino"] ?? "" // Estación de transbordo en la línea de destino
        let listaOrigen = lineas[lineaOrigen] ?? [] // Array de la línea de origen
        let listaDestino = lineas[lineaDestino] ?? [] // Array de la línea de destino
        guard let i1 = obtenerIndiceEnLinea(origenReal, listaOrigen), // Posición del origen en su línea
              let i2 = obtenerIndiceEnLinea(estacionCambioOrigen, listaOrigen), // Posición del transbordo en la línea de origen
              let i3 = obtenerIndiceEnLinea(estacionCambioDestino, listaDestino), // Posición del transbordo en la línea de destino
              let i4 = obtenerIndiceEnLinea(destinoReal, listaDestino) else { // Posición del destino en su línea
            print("⚠️ No se pudo calcular el tramo completo con la información disponible.") // Caso raro de error
            imprimirSeparador() // Cierra el bloque
            return // Sale de la función
        } // Cierra el guard múltiple
        let tramo1 = abs(i2 - i1) // Estaciones desde el origen hasta el punto de transbordo
        let tramo2 = abs(i4 - i3) // Estaciones desde el transbordo hasta el destino
        print("🔄 Debes hacer transbordo: \(lineaOrigen) → \(lineaDestino).") // Mensaje principal
        print("   Tramo 1 (\(lineaOrigen)): \(tramo1) estación(es), de \(origenReal) a \(estacionCambioOrigen).") // Primer tramo
        print("   Tramo 2 (\(lineaDestino)): \(tramo2) estación(es), de \(estacionCambioDestino) a \(destinoReal).") // Segundo tramo
        print("   Total aproximado: \(tramo1 + tramo2) estación(es) + 1 transbordo.") // Suma total, respuesta pedida
    } // Cierra el if/else de líneas
    imprimirSeparador() // Raya de cierre del bloque
} // Fin de la función planificarViaje


// 12. MENÚ PRINCIPAL: Bucle de interacción por consola (Requerimiento 4)
// ----------------------------------------------------------------------------
func menuPrincipal() { // Función que controla el ciclo del programa
    var continuarPrograma = true // Variable de control para mantener el programa activo
    while continuarPrograma { // Bucle que se repite mientras la variable sea verdadera
        imprimirTitulo("SISTEMA DE CONSULTA - METRO DE LIMA") // Título principal del menú, encuadrado
        print("1. Ver estaciones de una línea (Línea 1 / Línea 2)") // Opción 1
        print("2. Ver detalle de una estación") // Opción 2
        print("3. Buscar la mejor ruta entre dos estaciones") // Opción 3
        print("4. Ver horario de una línea") // Opción 4
        print("5. Buscar cómo llegar a un DISTRITO (sin saber la estación exacta)") // Opción 5 (nueva)
        print("6. Salir") // Opción 6
        imprimirSeparador() // Raya que separa el menú de la línea de entrada
        print("Elige una opción (1-6): ", terminator: "") // Solicita al usuario elegir una opción
        let opcion = readLine() ?? "" // Lee la opción ingresada por consola (texto)
        switch opcion { // Evalúa qué opción escribió el usuario
        case "1": // Caso: consultar estaciones de una línea
            print("¿Qué línea deseas consultar? (Línea 1 / Línea 2): ", terminator: "") // Pide el nombre de la línea
            let lineaIngresada = readLine() ?? "" // Lee el nombre de la línea ingresado
            mostrarEstacionesDeLinea(lineaIngresada) // Llama a la función que lista las estaciones
        case "2": // Caso: consultar detalle de una estación
            print("Escribe el nombre de la estación (no hace falta poner tildes): ", terminator: "") // Pide el nombre de la estación
            let estacionIngresada = readLine() ?? "" // Lee el nombre de la estación ingresado
            mostrarDetalleEstacion(estacionIngresada) // Llama a la función que muestra el detalle
        case "3": // Caso: buscar mejor ruta entre dos estaciones
            print("Estación de ORIGEN: ", terminator: "") // Pide la estación de origen
            let origenIngresado = readLine() ?? "" // Lee la estación de origen
            print("Estación de DESTINO: ", terminator: "") // Pide la estación de destino
            let destinoIngresado = readLine() ?? "" // Lee la estación de destino
            sugerirRuta(origen: origenIngresado, destino: destinoIngresado) // Llama a la función de ruta sugerida
        case "4": // Caso: consultar el horario de una línea
            print("¿Qué línea deseas consultar? (Línea 1 / Línea 2): ", terminator: "") // Pide el nombre de la línea
            let lineaHorario = readLine() ?? "" // Lee el nombre de la línea ingresado
            mostrarHorarioDeLinea(lineaHorario) // Llama a la función que muestra el horario
        case "5": // Caso: buscar ruta por distrito de destino (nuevo)
            print("Estación de ORIGEN: ", terminator: "") // Pide la estación de origen
            let origenDistrito = readLine() ?? "" // Lee la estación de origen
            print("¿A qué DISTRITO quieres llegar? (ej. Surco, San Borja, Callao): ", terminator: "") // Pide el distrito destino
            let distritoIngresado = readLine() ?? "" // Lee el distrito ingresado
            sugerirRutaPorDistrito(origen: origenDistrito, distritoDestino: distritoIngresado) // Llama a la función de búsqueda por distrito
        case "6": // Caso: salir del programa
            print("👋 Gracias por usar el sistema de consulta del Metro de Lima.") // Mensaje de despedida
            continuarPrograma = false // Cambia la variable de control para terminar el bucle
        default: // Caso: cualquier opción no válida
            print("⚠️ Opción no válida, intenta nuevamente.") // Mensaje de opción incorrecta
        } // Cierra el switch
    } // Cierra el while
} // Fin de la función menuPrincipal

// ----------------------------------------------------------------------------
// 13. EJECUCIÓN DEL PROGRAMA
// ----------------------------------------------------------------------------
// NOTA: readLine() funciona al ejecutar este código como "Command Line Tool"
// en Xcode (Product > Run). Dentro de un Playground gráfico (macOS/iPad) que
// no tenga entrada estándar disponible, reemplaza temporalmente las líneas
// "readLine() ?? ..." por un valor fijo de prueba, por ejemplo:
// mostrarEstacionesDeLinea("linea 2")                              // sin tilde, funciona igual
// mostrarDetalleEstacion("estacion central")                       // sin tildes, funciona igual
// mostrarHorarioDeLinea("Línea 1")
// sugerirRuta(origen: "Gamarra", destino: "28 de Julio")            // ejemplo con transbordo
// sugerirRuta(origen: "Vista Alegre", destino: "Villa El Salvador") // ejemplo con estación EN CONSTRUCCIÓN (debe avisar)
// sugerirRutaPorDistrito(origen: "Villa El Salvador", distritoDestino: "Surco") // ejemplo pedido: no sé la estación, sé el distrito
menuPrincipal() // Llama a la función principal para iniciar el programa
