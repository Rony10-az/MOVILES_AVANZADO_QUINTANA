// ============================================================================
// PROYECTO: Sistema de Consulta de Estaciones - Metro de Lima
// CURSO: Desarrollo iOS - Swift (Xcode Playground)
// SEMANA: 03 - Solo se usan: variables, arrays, diccionarios y funciones
// RESTRICCIÓN: NO se usan struct ni class
// ============================================================================
//
// v4 - PARTE 1/3: Planificador de viaje (cuántas estaciones faltan) +
// referencias de ubicación en las 53 estaciones. Tarjeta y modo admin van
// en las siguientes partes.
// ============================================================================

import Foundation

// ----------------------------------------------------------------------------
// 1. BASE DE DATOS: DICCIONARIO DE ESTACIONES
// ----------------------------------------------------------------------------
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
]

// ----------------------------------------------------------------------------
// 2. ARRAYS: ORDEN FÍSICO DE LAS ESTACIONES POR LÍNEA
// ----------------------------------------------------------------------------
let lineas: [String: [String]] = [
    "Línea 1": [
        "Villa El Salvador", "Parque Industrial", "Pumacahua", "Villa María",
        "María Auxiliadora", "San Juan", "Atocongo", "Jorge Chávez", "Ayacucho",
        "Cabitos", "Angamos", "San Borja Sur", "La Cultura", "Arriola", "Gamarra",
        "Miguel Grau", "El Ángel", "Presbítero Maestro", "Caja de Agua",
        "Pirámide del Sol", "Los Jardines", "Los Postes", "San Carlos",
        "San Martín", "Santa Rosa", "Bayóvar"
    ],
    "Línea 2": [
        "Evitamiento", "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán",
        "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado", "Municipalidad de Ate",
        "Circunvalación", "San Juan de Dios", "Nicolás Ayllón", "28 de Julio", "Cangallo",
        "Plaza Manco Cápac", "Estación Central", "Plaza Bolognesi", "Parque Murillo",
        "Tingo María", "La Alborada", "Elio", "San Marcos", "Óscar R. Benavides",
        "Carmen de La Legua", "Insurgentes", "Juan Pablo II", "Buenos Aires", "Puerto del Callao"
    ]
]

// ----------------------------------------------------------------------------
// 3. CONEXIONES ENTRE LÍNEAS
// ----------------------------------------------------------------------------
let conexionesEntreLineas: [String: String] = [
    "Línea 1-Línea 2": "En Gamarra / Arriola (Línea 1) conectando con 28 de Julio (Línea 2)",
    "Línea 2-Línea 1": "En 28 de Julio (Línea 2) conectando con Gamarra / Arriola (Línea 1)"
]

// NUEVO (Parte 1): versión estructurada para poder CONTAR estaciones en el transbordo
let estacionesDeTransbordo: [String: [String: String]] = [
    "Línea 1-Línea 2": ["enEstaLinea": "Gamarra", "enLineaDestino": "28 de Julio"],
    "Línea 2-Línea 1": ["enEstaLinea": "28 de Julio", "enLineaDestino": "Gamarra"]
]

// ----------------------------------------------------------------------------
// 4. HORARIOS DE TRENES POR LÍNEA
// ----------------------------------------------------------------------------
let horariosPorLinea: [String: [String: String]] = [
    "Línea 1": [
        "lunesAViernes": "05:00 a 22:00 (frecuencia de 3 a 10 min; cada 3 min en hora punta)",
        "sabado": "05:00 a 22:00 (frecuencia de 3.5 a 10 min)",
        "domingo": "05:30 a 22:00 (frecuencia de 6 a 12 min)"
    ],
    "Línea 2": [
        "lunesAViernes": "06:00 a 23:00 (hora punta 07:00-09:00 y 18:00-20:00)",
        "sabado": "06:00 a 23:00 (hora punta 07:00-09:00 y 18:00-20:00)",
        "domingo": "06:00 a 23:00 (hora punta única de 18:00 a 20:00)"
    ]
]

// ----------------------------------------------------------------------------
// 5. BÚSQUEDA FLEXIBLE (sin depender de tildes)
// ----------------------------------------------------------------------------
func normalizar(_ texto: String) -> String {
    return texto.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "es_PE"))
}

func buscarNombreEstacion(_ textoIngresado: String) -> String? {
    let textoNormalizado = normalizar(textoIngresado)
    for claveEstacion in estaciones.keys {
        if normalizar(claveEstacion) == textoNormalizado {
            return claveEstacion
        }
    }
    return nil
}

func buscarNombreLinea(_ textoIngresado: String) -> String? {
    let textoNormalizado = normalizar(textoIngresado)
    for claveLinea in lineas.keys {
        if normalizar(claveLinea) == textoNormalizado {
            return claveLinea
        }
    }
    return nil
}

// NUEVO (Parte 1): saber en qué posición va una estación dentro del array de su línea
func obtenerIndiceEnLinea(_ nombreEstacion: String, _ listaEstaciones: [String]) -> Int? {
    for (indice, estacion) in listaEstaciones.enumerated() {
        if estacion == nombreEstacion {
            return indice
        }
    }
    return nil
}

// ----------------------------------------------------------------------------
// 6. FORMATO DE SALIDA
// ----------------------------------------------------------------------------
func imprimirSeparador() {
    print(String(repeating: "-", count: 60))
}

func imprimirTitulo(_ texto: String) {
    let borde = String(repeating: "=", count: texto.count + 4)
    print("\n" + borde)
    print("| \(texto) |")
    print(borde)
}

// ----------------------------------------------------------------------------
// 7. CONSULTA DE ESTACIONES POR LÍNEA
// ----------------------------------------------------------------------------
func mostrarEstacionesDeLinea(_ nombreLinea: String) {
    guard let lineaReal = buscarNombreLinea(nombreLinea) else {
        print("⚠️ No existe información registrada para '\(nombreLinea)'.")
        return
    }
    let listaEstaciones = lineas[lineaReal] ?? []
    imprimirTitulo("ESTACIONES DE \(lineaReal.uppercased()) (\(listaEstaciones.count) EN TOTAL)")
    for (indice, nombreEstacion) in listaEstaciones.enumerated() {
        let detalle = estaciones[nombreEstacion] ?? [:]
        let estado = detalle["estado"] ?? "Desconocido"
        print("\(indice + 1). \(nombreEstacion) - \(estado)")
    }
    imprimirSeparador()
    print("🗺️  Recorrido: " + listaEstaciones.joined(separator: " → "))
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 8. DETALLE DE UNA ESTACIÓN (con referencias, NUEVO en la Parte 1)
// ----------------------------------------------------------------------------
func mostrarDetalleEstacion(_ nombreEstacion: String) {
    guard let nombreReal = buscarNombreEstacion(nombreEstacion) else {
        print("⚠️ La estación '\(nombreEstacion)' no fue encontrada. Verifica el nombre.")
        return
    }
    let detalle = estaciones[nombreReal] ?? [:]
    let lineaDeLaEstacion = detalle["linea"] ?? ""
    imprimirTitulo("DETALLE DE \(nombreReal.uppercased())")
    print("Distrito.......................: \(detalle["distrito"] ?? "N/D")")
    print("Línea..........................: \(detalle["linea"] ?? "N/D")")
    print("Estado.........................: \(detalle["estado"] ?? "N/D")")
    print("Ascensor.......................: \(detalle["ascensor"] ?? "N/D")")
    print("Conexión con Metropolitano.....: \(detalle["metropolitano"] ?? "N/D")")
    print("Transbordo con otra línea......: \(detalle["transbordo"] ?? "N/D")")
    print("Referencias (cómo ubicarte)....: \(detalle["referencias"] ?? "Pendiente de completar por el equipo")")
    imprimirSeparador()
    if let horarioLinea = horariosPorLinea[lineaDeLaEstacion] {
        print("🕒 Horario referencial de \(lineaDeLaEstacion):")
        print("   Lunes a viernes: \(horarioLinea["lunesAViernes"] ?? "N/D")")
        print("   Sábado.........: \(horarioLinea["sabado"] ?? "N/D")")
        print("   Domingo........: \(horarioLinea["domingo"] ?? "N/D")")
    } else {
        print("🕒 Aún no hay horario oficial registrado para \(lineaDeLaEstacion).")
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 9. HORARIO DE UNA LÍNEA
// ----------------------------------------------------------------------------
func mostrarHorarioDeLinea(_ nombreLinea: String) {
    guard let lineaReal = buscarNombreLinea(nombreLinea) else {
        print("⚠️ No existe información registrada para '\(nombreLinea)'.")
        return
    }
    let horario = horariosPorLinea[lineaReal] ?? [:]
    imprimirTitulo("HORARIO DE \(lineaReal.uppercased())")
    print("Lunes a viernes: \(horario["lunesAViernes"] ?? "N/D")")
    print("Sábado.........: \(horario["sabado"] ?? "N/D")")
    print("Domingo........: \(horario["domingo"] ?? "N/D")")
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 10. BUSCAR POR DISTRITO DE DESTINO
// ----------------------------------------------------------------------------
func buscarPorDistrito(_ distritoIngresado: String) -> [String] {
    let distritoNormalizado = normalizar(distritoIngresado)
    var resultado: [String] = []
    for (nombreEstacion, detalle) in estaciones {
        let distritoEstacion = detalle["distrito"] ?? ""
        if normalizar(distritoEstacion) == distritoNormalizado {
            resultado.append(nombreEstacion)
        }
    }
    return resultado
}

func sugerirRutaPorDistrito(origen: String, distritoDestino: String) {
    guard let origenReal = buscarNombreEstacion(origen) else {
        print("⚠️ La estación de origen '\(origen)' no fue encontrada.")
        return
    }
    let estacionesEnDistrito = buscarPorDistrito(distritoDestino)
    imprimirTitulo("CÓMO LLEGAR A \(distritoDestino.uppercased()) DESDE \(origenReal.uppercased())")
    if estacionesEnDistrito.isEmpty {
        print("❌ No hay ninguna estación de Línea 1 o Línea 2 registrada en el distrito '\(distritoDestino)'.")
        print("   Puede que ese distrito no tenga estación todavía, o el nombre esté escrito distinto al oficial.")
        imprimirSeparador()
        return
    }
    print("📍 Estaciones encontradas en \(distritoDestino):")
    for estacionCandidata in estacionesEnDistrito {
        let lineaCandidata = estaciones[estacionCandidata]?["linea"] ?? "N/D"
        print("   - \(estacionCandidata) (\(lineaCandidata))")
    }
    imprimirSeparador()
    if let primeraOpcion = estacionesEnDistrito.first {
        print("Tomando como referencia '\(primeraOpcion)':")
        sugerirRuta(origen: origenReal, destino: primeraOpcion)
    }
}

// ----------------------------------------------------------------------------
// 11. SUGERIR LA MEJOR RUTA (con validación de estado)
// ----------------------------------------------------------------------------
func sugerirRuta(origen: String, destino: String) {
    guard let origenReal = buscarNombreEstacion(origen) else {
        print("⚠️ La estación de origen '\(origen)' no fue encontrada.")
        return
    }
    guard let destinoReal = buscarNombreEstacion(destino) else {
        print("⚠️ La estación de destino '\(destino)' no fue encontrada.")
        return
    }
    let detalleOrigen = estaciones[origenReal] ?? [:]
    let detalleDestino = estaciones[destinoReal] ?? [:]
    let lineaOrigen = detalleOrigen["linea"] ?? ""
    let lineaDestino = detalleDestino["linea"] ?? ""
    let estadoOrigen = detalleOrigen["estado"] ?? "Desconocido"
    let estadoDestino = detalleDestino["estado"] ?? "Desconocido"
    imprimirTitulo("RUTA SUGERIDA: \(origenReal.uppercased()) → \(destinoReal.uppercased())")
    if estadoOrigen != "Operativa" {
        print("⚠️ Atención: '\(origenReal)' figura como '\(estadoOrigen)', todavía NO está habilitada para viajar.")
    }
    if estadoDestino != "Operativa" {
        print("⚠️ Atención: '\(destinoReal)' figura como '\(estadoDestino)', todavía NO está habilitada para viajar.")
    }
    if lineaOrigen == lineaDestino {
        print("✅ Puedes llegar directo: toma \(lineaOrigen) desde \(origenReal) hasta \(destinoReal). No necesitas transbordo.")
    } else {
        let clave = "\(lineaOrigen)-\(lineaDestino)"
        if let conexion = conexionesEntreLineas[clave] {
            print("🔄 Debes hacer transbordo: toma \(lineaOrigen) y baja en el punto de conexión.")
            print("   Conexión sugerida: \(conexion)")
            print("   Luego continúa en \(lineaDestino) hasta \(destinoReal).")
        } else {
            print("❌ Aún no existe una conexión directa registrada entre \(lineaOrigen) y \(lineaDestino) con la información disponible.")
        }
    }
    if detalleDestino["metropolitano"] == "Sí" {
        print("ℹ️ Dato extra: \(destinoReal) también conecta con el Metropolitano.")
    }
    if estadoOrigen != "Operativa" || estadoDestino != "Operativa" {
        print("ℹ️ Recuerda: la ruta de arriba es solo REFERENCIAL, no la podrás usar hasta que esa estación entre en operación.")
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 12. NUEVO (Parte 1): PLANIFICADOR DE VIAJE
// ----------------------------------------------------------------------------
func planificarViaje(origen: String, destino: String) {
    guard let origenReal = buscarNombreEstacion(origen) else {
        print("⚠️ La estación de origen '\(origen)' no fue encontrada.")
        return
    }
    guard let destinoReal = buscarNombreEstacion(destino) else {
        print("⚠️ La estación de destino '\(destino)' no fue encontrada.")
        return
    }
    let detalleOrigen = estaciones[origenReal] ?? [:]
    let detalleDestino = estaciones[destinoReal] ?? [:]
    let lineaOrigen = detalleOrigen["linea"] ?? ""
    let lineaDestino = detalleDestino["linea"] ?? ""
    imprimirTitulo("PLANIFICADOR DE VIAJE: \(origenReal.uppercased()) → \(destinoReal.uppercased())")
    if lineaOrigen == lineaDestino {
        let listaEstaciones = lineas[lineaOrigen] ?? []
        guard let indiceOrigen = obtenerIndiceEnLinea(origenReal, listaEstaciones),
              let indiceDestino = obtenerIndiceEnLinea(destinoReal, listaEstaciones) else {
            print("⚠️ No se pudo ubicar alguna estación dentro de \(lineaOrigen).")
            imprimirSeparador()
            return
        }
        let estacionesAPasar = abs(indiceDestino - indiceOrigen)
        print("🚈 Misma línea: \(lineaOrigen). No necesitas transbordo.")
        print("   Te faltan \(estacionesAPasar) estación(es) desde \(origenReal) hasta \(destinoReal).")
        let inicio = min(indiceOrigen, indiceDestino)
        let fin = max(indiceOrigen, indiceDestino)
        var tramo: [String] = []
        var i = inicio
        while i <= fin {
            tramo.append(listaEstaciones[i])
            i += 1
        }
        if indiceOrigen > indiceDestino {
            tramo.reverse()
        }
        print("   Recorrido: " + tramo.joined(separator: " → "))
    } else {
        let clave = "\(lineaOrigen)-\(lineaDestino)"
        guard let transbordo = estacionesDeTransbordo[clave] else {
            print("❌ Aún no hay una conexión registrada entre \(lineaOrigen) y \(lineaDestino).")
            imprimirSeparador()
            return
        }
        let estacionCambioOrigen = transbordo["enEstaLinea"] ?? ""
        let estacionCambioDestino = transbordo["enLineaDestino"] ?? ""
        let listaOrigen = lineas[lineaOrigen] ?? []
        let listaDestino = lineas[lineaDestino] ?? []
        guard let i1 = obtenerIndiceEnLinea(origenReal, listaOrigen),
              let i2 = obtenerIndiceEnLinea(estacionCambioOrigen, listaOrigen),
              let i3 = obtenerIndiceEnLinea(estacionCambioDestino, listaDestino),
              let i4 = obtenerIndiceEnLinea(destinoReal, listaDestino) else {
            print("⚠️ No se pudo calcular el tramo completo con la información disponible.")
            imprimirSeparador()
            return
        }
        let tramo1 = abs(i2 - i1)
        let tramo2 = abs(i4 - i3)
        print("🔄 Debes hacer transbordo: \(lineaOrigen) → \(lineaDestino).")
        print("   Tramo 1 (\(lineaOrigen)): \(tramo1) estación(es), de \(origenReal) a \(estacionCambioOrigen).")
        print("   Tramo 2 (\(lineaDestino)): \(tramo2) estación(es), de \(estacionCambioDestino) a \(destinoReal).")
        print("   Total aproximado: \(tramo1 + tramo2) estación(es) + 1 transbordo.")
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 13. MENÚ PRINCIPAL (con la nueva opción 6, "Salir" ahora es 7)
// ----------------------------------------------------------------------------
func menuPrincipal() {
    var continuarPrograma = true
    while continuarPrograma {
        imprimirTitulo("SISTEMA DE CONSULTA - METRO DE LIMA")
        print("1. Ver estaciones de una línea (Línea 1 / Línea 2)")
        print("2. Ver detalle de una estación")
        print("3. Buscar la mejor ruta entre dos estaciones")
        print("4. Ver horario de una línea")
        print("5. Buscar cómo llegar a un distrito")
        print("6. Planificador de viaje (cuántas estaciones faltan)")
        print("7. Salir")
        imprimirSeparador()
        print("Elige una opción (1-7): ", terminator: "")
        let opcion = readLine() ?? ""
        switch opcion {
        case "1":
            print("¿Qué línea deseas consultar? (Línea 1 / Línea 2): ", terminator: "")
            let lineaIngresada = readLine() ?? ""
            mostrarEstacionesDeLinea(lineaIngresada)
        case "2":
            print("Escribe el nombre de la estación (no hace falta poner tildes): ", terminator: "")
            let estacionIngresada = readLine() ?? ""
            mostrarDetalleEstacion(estacionIngresada)
        case "3":
            print("Estación de ORIGEN: ", terminator: "")
            let origenIngresado = readLine() ?? ""
            print("Estación de DESTINO: ", terminator: "")
            let destinoIngresado = readLine() ?? ""
            sugerirRuta(origen: origenIngresado, destino: destinoIngresado)
        case "4":
            print("¿Qué línea deseas consultar? (Línea 1 / Línea 2): ", terminator: "")
            let lineaHorario = readLine() ?? ""
            mostrarHorarioDeLinea(lineaHorario)
        case "5":
            print("Estación de ORIGEN: ", terminator: "")
            let origenDistrito = readLine() ?? ""
            print("¿A qué DISTRITO quieres llegar? (ej. Surco, San Borja, Callao): ", terminator: "")
            let distritoIngresado = readLine() ?? ""
            sugerirRutaPorDistrito(origen: origenDistrito, distritoDestino: distritoIngresado)
        case "6":
            print("Estación de ORIGEN: ", terminator: "")
            let origenPlan = readLine() ?? ""
            print("Estación de DESTINO: ", terminator: "")
            let destinoPlan = readLine() ?? ""
            planificarViaje(origen: origenPlan, destino: destinoPlan)
        case "7":
            print("👋 Gracias por usar el sistema de consulta del Metro de Lima.")
            continuarPrograma = false
        default:
            print("⚠️ Opción no válida, intenta nuevamente.")
        }
    }
}

// ----------------------------------------------------------------------------
// 14. EJECUCIÓN
// ----------------------------------------------------------------------------
// Para probar sin readLine(), descomenta y usa directo, por ejemplo:
// planificarViaje(origen: "Villa El Salvador", destino: "Jorge Chávez")
// planificarViaje(origen: "Villa El Salvador", destino: "28 de Julio")
menuPrincipal()
