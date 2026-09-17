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
    "Villa El Salvador": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación terminal sur de la Línea 1
    "Parque Industrial": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Pumacahua": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna"], // No tiene ascensor: usa silla salvaescaleras
    "Villa María": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna"], // No tiene ascensor: usa silla salvaescaleras
    "María Auxiliadora": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna"], // No tiene ascensor: usa silla salvaescaleras
    "San Juan": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Atocongo": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 3 (planificada)"], // Futuro cruce con la Línea 3 (proyecto)
    "Jorge Chávez": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Ayacucho": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Cabitos": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 3 (planificada)"], // Futuro cruce con la Línea 3 (proyecto)
    "Angamos": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 6 (planificada)"], // Futuro cruce con la Línea 6 (proyecto)
    "San Borja Sur": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "No", "metropolitano": "No", "transbordo": "Ninguna"], // No tiene ascensor: usa silla salvaescaleras
    "La Cultura": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 4 (planificada)"], // Futuro cruce con la Línea 4 (proyecto)
    "Arriola": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 2 (en construcción)"], // Cercana al futuro cruce con Línea 2
    "Gamarra": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 2 (en construcción)"], // Cruce planificado con estación "28 de Julio" de la Línea 2
    "Miguel Grau": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "El Ángel": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Presbítero Maestro": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Caja de Agua": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Pirámide del Sol": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Los Jardines": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Los Postes": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "San Carlos": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "San Martín": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Santa Rosa": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación intermedia sin conexión adicional
    "Bayóvar": ["linea": "Línea 1", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Estación terminal norte de la Línea 1

    // ---------------------- LÍNEA 2 (27 estaciones, en construcción por tramos) ----------------------
    "Evitamiento": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Una de las 5 estaciones ya operativas en 2026
    "Óvalo Santa Anita": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Una de las 5 estaciones ya operativas en 2026
    "Colectora Industrial": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Una de las 5 estaciones ya operativas en 2026
    "Hermilio Valdizán": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Una de las 5 estaciones ya operativas en 2026
    "Mercado Santa Anita": ["linea": "Línea 2", "estado": "Operativa", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Una de las 5 estaciones ya operativas en 2026
    "Vista Alegre": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Prolongación Javier Prado": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Municipalidad de Ate": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Circunvalación": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "San Juan de Dios": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Nicolás Ayllón": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "28 de Julio": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Línea 1 (Gamarra / Arriola)"], // Punto de transbordo con la Línea 1
    "Cangallo": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Plaza Manco Cápac": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Estación Central": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "Sí", "transbordo": "Línea 4 (planificada)"], // Principal cruce con el Metropolitano
    "Plaza Bolognesi": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Parque Murillo": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Tingo María": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "La Alborada": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Elio": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "San Marcos": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Óscar R. Benavides": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Carmen de La Legua": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Insurgentes": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Juan Pablo II": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Buenos Aires": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"], // Aún en obra según cronograma 2026
    "Puerto del Callao": ["linea": "Línea 2", "estado": "En construcción", "ascensor": "Sí", "metropolitano": "No", "transbordo": "Ninguna"] // Estación terminal de la Línea 2 en el Callao
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
// 4. DICCIONARIO DE HORARIOS DE TRENES POR LÍNEA (NUEVO - RF-09)
// ----------------------------------------------------------------------------
// Horario referencial oficial (ATU / Metro de Lima), setiembre 2026.
// Es "pre-conexión" con cada estación: cuando el usuario consulta una
// estación, el sistema muestra el horario de LA LÍNEA a la que pertenece.
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
// 5. FUNCIONES DE FORMATO: encapsular la salida por consola (NUEVO - RF-10)
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
// 6. FUNCIÓN: Buscar el nombre real de una estación sin importar mayúsculas
// ----------------------------------------------------------------------------
func buscarNombreEstacion(_ textoIngresado: String) -> String? { // Recibe el texto escrito por el usuario
    let textoNormalizado = textoIngresado.lowercased() // Convierte el texto ingresado a minúsculas
    for claveEstacion in estaciones.keys { // Recorre todas las claves (nombres) del diccionario de estaciones
        if claveEstacion.lowercased() == textoNormalizado { // Compara ignorando mayúsculas/minúsculas
            return claveEstacion // Devuelve el nombre exacto tal como está guardado en el diccionario
        } // Cierra el if de comparación
    } // Cierra el for de recorrido
    return nil // Si no se encontró ninguna coincidencia, devuelve nil
} // Fin de la función buscarNombreEstacion

// ----------------------------------------------------------------------------
// 7. FUNCIÓN: Mostrar todas las estaciones de una línea (Requerimiento 1)
// ----------------------------------------------------------------------------
func mostrarEstacionesDeLinea(_ nombreLinea: String) { // Recibe el nombre de la línea, ej "Línea 2"
    guard let listaEstaciones = lineas[nombreLinea] else { // Busca el array de estaciones de esa línea
        print("⚠️ No existe información registrada para \(nombreLinea).") // Mensaje si la línea no existe
        return // Sale de la función si no encontró la línea
    } // Cierra el guard
    imprimirTitulo("ESTACIONES DE \(nombreLinea.uppercased()) (\(listaEstaciones.count) EN TOTAL)") // Título encuadrado
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
    print("Línea..........................: \(detalle["linea"] ?? "N/D")") // Imprime a qué línea pertenece
    print("Estado.........................: \(detalle["estado"] ?? "N/D")") // Imprime si está operativa o en construcción
    print("Ascensor.......................: \(detalle["ascensor"] ?? "N/D")") // Imprime si tiene ascensor
    print("Conexión con Metropolitano.....: \(detalle["metropolitano"] ?? "N/D")") // Imprime conexión con Metropolitano
    print("Transbordo con otra línea......: \(detalle["transbordo"] ?? "N/D")") // Imprime si conecta con otra línea
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
// 9. FUNCIÓN: Mostrar el horario de una línea por separado (NUEVO - RF-09)
// ----------------------------------------------------------------------------
func mostrarHorarioDeLinea(_ nombreLinea: String) { // Recibe el nombre de la línea a consultar
    guard let horario = horariosPorLinea[nombreLinea] else { // Busca el horario de esa línea
        print("⚠️ No hay horario registrado para \(nombreLinea).") // Mensaje si no existe esa línea
        return // Sale de la función si no se encontró horario
    } // Cierra el guard
    imprimirTitulo("HORARIO DE \(nombreLinea.uppercased())") // Título encuadrado
    print("Lunes a viernes: \(horario["lunesAViernes"] ?? "N/D")") // Imprime el horario de lunes a viernes
    print("Sábado.........: \(horario["sabado"] ?? "N/D")") // Imprime el horario de sábado
    print("Domingo........: \(horario["domingo"] ?? "N/D")") // Imprime el horario de domingo
    imprimirSeparador() // Raya de cierre del bloque
} // Fin de la función mostrarHorarioDeLinea

// ----------------------------------------------------------------------------
// 10. FUNCIÓN: Sugerir la mejor línea/estación para llegar a un destino (Requerimiento 3)
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
    imprimirTitulo("RUTA SUGERIDA: \(origenReal.uppercased()) → \(destinoReal.uppercased())") // Título encuadrado de la consulta
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
    imprimirSeparador() // Raya que cierra el bloque de la ruta sugerida
} // Fin de la función sugerirRuta

// ----------------------------------------------------------------------------
// 11. MENÚ PRINCIPAL: Bucle de interacción por consola (Requerimiento 4)
// ----------------------------------------------------------------------------
func menuPrincipal() { // Función que controla el ciclo del programa
    var continuarPrograma = true // Variable de control para mantener el programa activo
    while continuarPrograma { // Bucle que se repite mientras la variable sea verdadera
        imprimirTitulo("SISTEMA DE CONSULTA - METRO DE LIMA") // Título principal del menú, encuadrado
        print("1. Ver estaciones de una línea (Línea 1 / Línea 2)") // Opción 1
        print("2. Ver detalle de una estación") // Opción 2
        print("3. Buscar la mejor ruta entre dos estaciones") // Opción 3
        print("4. Ver horario de una línea") // Opción 4 (nueva)
        print("5. Salir") // Opción 5 (antes era la 4)
        imprimirSeparador() // Raya que separa el menú de la línea de entrada
        print("Elige una opción (1-5): ", terminator: "") // Solicita al usuario elegir una opción
        let opcion = readLine() ?? "" // Lee la opción ingresada por consola (texto)
        switch opcion { // Evalúa qué opción escribió el usuario
        case "1": // Caso: consultar estaciones de una línea
            print("¿Qué línea deseas consultar? (Línea 1 / Línea 2): ", terminator: "") // Pide el nombre de la línea
            let lineaIngresada = readLine() ?? "" // Lee el nombre de la línea ingresado
            mostrarEstacionesDeLinea(lineaIngresada) // Llama a la función que lista las estaciones
        case "2": // Caso: consultar detalle de una estación
            print("Escribe el nombre exacto de la estación: ", terminator: "") // Pide el nombre de la estación
            let estacionIngresada = readLine() ?? "" // Lee el nombre de la estación ingresado
            mostrarDetalleEstacion(estacionIngresada) // Llama a la función que muestra el detalle
        case "3": // Caso: buscar mejor ruta entre dos estaciones
            print("Estación de ORIGEN: ", terminator: "") // Pide la estación de origen
            let origenIngresado = readLine() ?? "" // Lee la estación de origen
            print("Estación de DESTINO: ", terminator: "") // Pide la estación de destino
            let destinoIngresado = readLine() ?? "" // Lee la estación de destino
            sugerirRuta(origen: origenIngresado, destino: destinoIngresado) // Llama a la función de ruta sugerida
        case "4": // Caso: consultar el horario de una línea (nuevo)
            print("¿Qué línea deseas consultar? (Línea 1 / Línea 2): ", terminator: "") // Pide el nombre de la línea
            let lineaHorario = readLine() ?? "" // Lee el nombre de la línea ingresado
            mostrarHorarioDeLinea(lineaHorario) // Llama a la función que muestra el horario
        case "5": // Caso: salir del programa
            print("👋 Gracias por usar el sistema de consulta del Metro de Lima.") // Mensaje de despedida
            continuarPrograma = false // Cambia la variable de control para terminar el bucle
        default: // Caso: cualquier opción no válida
            print("⚠️ Opción no válida, intenta nuevamente.") // Mensaje de opción incorrecta
        } // Cierra el switch
    } // Cierra el while
} // Fin de la función menuPrincipal

// ----------------------------------------------------------------------------
// 12. EJECUCIÓN DEL PROGRAMA
// ----------------------------------------------------------------------------
// NOTA: readLine() funciona al ejecutar este código como "Command Line Tool"
// en Xcode (Product > Run). Dentro de un Playground gráfico (macOS/iPad) que
// no tenga entrada estándar disponible, reemplaza temporalmente las líneas
// "readLine() ?? ..." por un valor fijo de prueba, por ejemplo:
// mostrarEstacionesDeLinea("Línea 2")
// mostrarDetalleEstacion("Estación Central")
// mostrarHorarioDeLinea("Línea 1")
// sugerirRuta(origen: "Gamarra", destino: "28 de Julio")
menuPrincipal() // Llama a la función principal para iniciar el programa
