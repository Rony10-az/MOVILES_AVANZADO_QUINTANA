// ============================================================================
// PROYECTO: Sistema de Consulta de Estaciones - Metro de Lima
// CURSO: Desarrollo iOS - Swift (Xcode Playground)
// SEMANA: 03 - Solo se usan: variables, arrays, diccionarios y funciones
// RESTRICCIÓN: NO se usan struct ni class
// ============================================================================
//
// v5 - Planificador de viaje (cuántas estaciones faltan), referencias de
// ubicación en las 53 estaciones, gestionador de tarjeta y MODO ADMINISTRADOR
// para simular ampliaciones de la red (insertar estaciones y crear líneas).
//
// NOTA: los diccionarios de datos ahora son 'var' (antes 'let') porque el
// administrador necesita agregarles información en tiempo de ejecución.
// ============================================================================

import Foundation

// ----------------------------------------------------------------------------
// 1. BASE DE DATOS: DICCIONARIO DE ESTACIONES
// ----------------------------------------------------------------------------
var estaciones: [String: [String: String]] = [

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
var lineas: [String: [String]] = [
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
var conexionesEntreLineas: [String: String] = [
    "Línea 1-Línea 2": "En Gamarra / Arriola (Línea 1) conectando con 28 de Julio (Línea 2)",
    "Línea 2-Línea 1": "En 28 de Julio (Línea 2) conectando con Gamarra / Arriola (Línea 1)"
]

// NUEVO (Parte 1): versión estructurada para poder CONTAR estaciones en el transbordo
var estacionesDeTransbordo: [String: [String: String]] = [
    "Línea 1-Línea 2": ["enEstaLinea": "Gamarra", "enLineaDestino": "28 de Julio"],
    "Línea 2-Línea 1": ["enEstaLinea": "28 de Julio", "enLineaDestino": "Gamarra"]
]

// ----------------------------------------------------------------------------
// 4. HORARIOS DE TRENES POR LÍNEA
// ----------------------------------------------------------------------------
var horariosPorLinea: [String: [String: String]] = [
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
// VARIABLES DE LA TARJETA SIMULADA (tarifas reales Línea 1, 2026)
// ----------------------------------------------------------------------------
var saldoTarjeta: Double = 0.0 // Saldo actual (arranca en S/ 0.00, hay que recargar)
var totalConsumido: Double = 0.0 // Acumulado histórico de lo gastado en pasajes
var historialDeViajes: [String] = [] // Un texto por cada viaje pagado
let costoPasajeAdulto: Double = 1.50 // Tarifa adulto real (2026)
let costoPasajeEstudiante: Double = 0.75 // Tarifa estudiante real, L-S (2026)

// ----------------------------------------------------------------------------
// FUNCIONES DEL GESTIONADOR DE TARJETA
// ----------------------------------------------------------------------------
func recargarTarjeta(monto: Double) { // Recibe el monto a recargar
    if monto < 0.10 { // Recarga mínima real
        print("⚠️ El monto mínimo de recarga es S/ 0.10.")
        return
    }
    saldoTarjeta += monto
    print("✅ Recarga exitosa de S/ \(String(format: "%.2f", monto)). Saldo actual: S/ \(String(format: "%.2f", saldoTarjeta))")
}

func pagarPasaje(esEstudiante: Bool, trayecto: String) -> Bool { // Devuelve true si se pudo cobrar
    let costo = esEstudiante ? costoPasajeEstudiante : costoPasajeAdulto
    if saldoTarjeta >= costo {
        saldoTarjeta -= costo
        totalConsumido += costo
        historialDeViajes.append(trayecto)
        print("✅ Pasaje pagado: S/ \(String(format: "%.2f", costo)). Saldo restante: S/ \(String(format: "%.2f", saldoTarjeta))")
        return true
    } else {
        print("❌ Saldo insuficiente. Tienes S/ \(String(format: "%.2f", saldoTarjeta)), necesitas S/ \(String(format: "%.2f", costo)). Recarga tu tarjeta.")
        return false
    }
}

func mostrarEstadoTarjeta() { // Resumen: cuánto tienes, cuánto consumiste, historial
    imprimirTitulo("ESTADO DE TU TARJETA")
    print("Saldo actual.......: S/ \(String(format: "%.2f", saldoTarjeta))")
    print("Total consumido....: S/ \(String(format: "%.2f", totalConsumido))")
    print("Viajes realizados..: \(historialDeViajes.count)")
    imprimirSeparador()
    if historialDeViajes.isEmpty {
        print("Aún no registras viajes pagados con la tarjeta.")
    } else {
        print("Historial de viajes:")
        for (indice, viaje) in historialDeViajes.enumerated() {
            print("  \(indice + 1). \(viaje)")
        }
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 13. NUEVO: MODO ADMINISTRADOR (simulación de ampliaciones de la red)
// ----------------------------------------------------------------------------
// El administrador puede AGREGAR datos al sistema para simular cómo quedaría la
// red del Metro de Lima si creciera:
//   a) Insertar una estación NUEVA entre dos paraderos que ya existen.
//   b) Ampliar una línea agregando una estación al final (nuevo terminal).
//   c) Crear una LÍNEA NUEVA simulada con sus estaciones y su horario.
//   d) Registrar el transbordo entre dos líneas para que el planificador funcione.
// Todo se guarda en los MISMOS diccionarios y arrays del sistema (sin struct ni class).

let claveAdministrador = "metro2026" // Clave simulada de acceso al modo administrador
var modoAdministradorActivo = false // Indica si la sesión de administrador está abierta
var bitacoraAdministrador: [String] = [] // Guarda un texto por cada cambio hecho

// Registra en la bitácora cada cambio, para poder mostrar después qué se simuló
func registrarEnBitacora(_ accion: String) {
    bitacoraAdministrador.append(accion)
}

// Quita espacios sobrantes del texto que escribe el usuario en consola
func limpiarTexto(_ texto: String) -> String {
    return texto.trimmingCharacters(in: .whitespacesAndNewlines)
}

// Valida la clave y abre la sesión de administrador
func iniciarSesionAdministrador(_ claveIngresada: String) -> Bool {
    if limpiarTexto(claveIngresada) == claveAdministrador {
        modoAdministradorActivo = true
        print("🔐 Acceso concedido. Modo ADMINISTRADOR activado.")
        return true
    }
    print("⛔ Clave incorrecta. El modo administrador NO fue activado.")
    return false
}

// Cierra la sesión para que un usuario normal no pueda seguir editando datos
func cerrarSesionAdministrador() {
    modoAdministradorActivo = false
    print("🔓 Sesión de administrador cerrada.")
}

// Verifica el permiso antes de cualquier cambio en la base de datos
func hayPermisoDeAdministrador() -> Bool {
    if !modoAdministradorActivo {
        print("⛔ Esta acción es solo para el administrador. Inicia sesión primero.")
        return false
    }
    return true
}

// Guarda (o reemplaza) el detalle completo de una estación en el diccionario
func guardarDatosDeEstacion(nombre: String, linea: String, estado: String, ascensor: String,
                            metropolitano: String, transbordo: String, distrito: String,
                            referencias: String) {
    estaciones[nombre] = [
        "linea": linea,
        "estado": estado,
        "ascensor": ascensor,
        "metropolitano": metropolitano,
        "transbordo": transbordo,
        "distrito": distrito,
        "referencias": referencias
    ]
}

// ---- a) INSERTAR UNA ESTACIÓN ENTRE DOS PARADEROS EXISTENTES ----------------
func insertarEstacionEntre(estacionA: String, estacionB: String, nuevaEstacion: String,
                           distrito: String, referencias: String,
                           estado: String = "Simulada", ascensor: String = "No",
                           metropolitano: String = "No") {
    if !hayPermisoDeAdministrador() { return }
    let nombreNueva = limpiarTexto(nuevaEstacion)
    if nombreNueva.isEmpty {
        print("⚠️ El nombre de la estación nueva no puede estar vacío.")
        return
    }
    guard let nombreA = buscarNombreEstacion(estacionA) else {
        print("⚠️ El paradero '\(estacionA)' no existe en el sistema.")
        return
    }
    guard let nombreB = buscarNombreEstacion(estacionB) else {
        print("⚠️ El paradero '\(estacionB)' no existe en el sistema.")
        return
    }
    if buscarNombreEstacion(nombreNueva) != nil {
        print("⚠️ Ya existe una estación llamada '\(nombreNueva)'. Usa otro nombre.")
        return
    }
    let lineaA = estaciones[nombreA]?["linea"] ?? ""
    let lineaB = estaciones[nombreB]?["linea"] ?? ""
    if lineaA != lineaB {
        print("⚠️ '\(nombreA)' es de \(lineaA) y '\(nombreB)' es de \(lineaB).")
        print("   Solo se puede insertar una estación entre dos paraderos de la MISMA línea.")
        return
    }
    var recorrido = lineas[lineaA] ?? []
    guard let indiceA = obtenerIndiceEnLinea(nombreA, recorrido),
          let indiceB = obtenerIndiceEnLinea(nombreB, recorrido) else {
        print("⚠️ No se pudo ubicar alguno de los paraderos dentro de \(lineaA).")
        return
    }
    if abs(indiceA - indiceB) != 1 {
        print("⚠️ '\(nombreA)' y '\(nombreB)' NO son paraderos consecutivos.")
        print("   Entre ellos hay \(abs(indiceA - indiceB) - 1) estación(es); elige dos que estén seguidas.")
        return
    }
    let posicionDeInsercion = max(indiceA, indiceB) // La nueva queda justo entre las dos
    recorrido.insert(nombreNueva, at: posicionDeInsercion)
    lineas[lineaA] = recorrido // Se actualiza el recorrido real de la línea
    guardarDatosDeEstacion(nombre: nombreNueva, linea: lineaA, estado: estado,
                           ascensor: ascensor, metropolitano: metropolitano,
                           transbordo: "Ninguna",
                           distrito: limpiarTexto(distrito),
                           referencias: limpiarTexto(referencias))
    imprimirTitulo("ESTACIÓN INSERTADA: \(nombreNueva.uppercased())")
    print("✅ '\(nombreNueva)' quedó registrada en \(lineaA), entre \(nombreA) y \(nombreB).")
    print("   Posición en el recorrido: \(posicionDeInsercion + 1) de \(recorrido.count).")
    print("   Estado registrado........: \(estado)")
    print("🗺️  Nuevo recorrido: " + recorrido.joined(separator: " → "))
    imprimirSeparador()
    registrarEnBitacora("Insertó '\(nombreNueva)' en \(lineaA), entre \(nombreA) y \(nombreB)")
}

// ---- b) AMPLIAR UNA LÍNEA: NUEVA ESTACIÓN AL FINAL --------------------------
func agregarEstacionAlFinalDeLinea(nombreLinea: String, nuevaEstacion: String,
                                   distrito: String, referencias: String,
                                   alInicio: Bool = false, estado: String = "Simulada") {
    if !hayPermisoDeAdministrador() { return }
    guard let lineaReal = buscarNombreLinea(nombreLinea) else {
        print("⚠️ No existe la línea '\(nombreLinea)'.")
        return
    }
    let nombreNueva = limpiarTexto(nuevaEstacion)
    if nombreNueva.isEmpty {
        print("⚠️ El nombre de la estación nueva no puede estar vacío.")
        return
    }
    if buscarNombreEstacion(nombreNueva) != nil {
        print("⚠️ Ya existe una estación llamada '\(nombreNueva)'. Usa otro nombre.")
        return
    }
    var recorrido = lineas[lineaReal] ?? []
    if alInicio {
        recorrido.insert(nombreNueva, at: 0) // Nuevo terminal al inicio del recorrido
    } else {
        recorrido.append(nombreNueva) // Nuevo terminal al final del recorrido
    }
    lineas[lineaReal] = recorrido
    guardarDatosDeEstacion(nombre: nombreNueva, linea: lineaReal, estado: estado,
                           ascensor: "No", metropolitano: "No", transbordo: "Ninguna",
                           distrito: limpiarTexto(distrito),
                           referencias: limpiarTexto(referencias))
    let extremo = alInicio ? "INICIO" : "FINAL"
    imprimirTitulo("AMPLIACIÓN DE \(lineaReal.uppercased())")
    print("✅ '\(nombreNueva)' se agregó al \(extremo) de \(lineaReal) (estado: \(estado)).")
    print("   La línea ahora tiene \(recorrido.count) estación(es).")
    print("🗺️  Nuevo recorrido: " + recorrido.joined(separator: " → "))
    imprimirSeparador()
    registrarEnBitacora("Amplió \(lineaReal) con '\(nombreNueva)' al \(extremo.lowercased())")
}

// ---- c) CREAR UNA NUEVA LÍNEA SIMULADA -------------------------------------
// 'estacionesNuevas' es un ARRAY DE DICCIONARIOS: cada uno con "nombre", "distrito"
// y "referencias". Así se evita usar struct o class para agrupar los datos.
func crearLineaSimulada(nombreLinea: String, estacionesNuevas: [[String: String]],
                        horarioLunesAViernes: String, horarioSabado: String,
                        horarioDomingo: String) {
    if !hayPermisoDeAdministrador() { return }
    let lineaLimpia = limpiarTexto(nombreLinea)
    if lineaLimpia.isEmpty {
        print("⚠️ El nombre de la línea no puede estar vacío.")
        return
    }
    if buscarNombreLinea(lineaLimpia) != nil {
        print("⚠️ La línea '\(lineaLimpia)' ya existe en el sistema.")
        return
    }
    if estacionesNuevas.count < 2 {
        print("⚠️ Una línea necesita al menos 2 estaciones para poder simular viajes.")
        return
    }
    var recorrido: [String] = [] // Aquí se arma el orden físico de la línea nueva
    var descartadas: [String] = [] // Nombres repetidos que no se pudieron registrar
    for datosEstacion in estacionesNuevas {
        let nombre = limpiarTexto(datosEstacion["nombre"] ?? "")
        if nombre.isEmpty { continue }
        if buscarNombreEstacion(nombre) != nil {
            descartadas.append(nombre) // Ya pertenece a otra línea: no se sobreescribe
            continue
        }
        recorrido.append(nombre)
        guardarDatosDeEstacion(nombre: nombre, linea: lineaLimpia, estado: "Simulada",
                               ascensor: datosEstacion["ascensor"] ?? "No",
                               metropolitano: datosEstacion["metropolitano"] ?? "No",
                               transbordo: "Ninguna",
                               distrito: limpiarTexto(datosEstacion["distrito"] ?? "N/D"),
                               referencias: limpiarTexto(datosEstacion["referencias"] ?? "Estación simulada por el administrador"))
    }
    if recorrido.count < 2 {
        print("❌ No se pudo crear '\(lineaLimpia)': quedaron menos de 2 estaciones válidas.")
        for nombreDescartado in recorrido { estaciones[nombreDescartado] = nil } // Deshace lo agregado
        return
    }
    lineas[lineaLimpia] = recorrido // Se registra el recorrido de la línea nueva
    horariosPorLinea[lineaLimpia] = [ // Se registra su horario referencial
        "lunesAViernes": limpiarTexto(horarioLunesAViernes),
        "sabado": limpiarTexto(horarioSabado),
        "domingo": limpiarTexto(horarioDomingo)
    ]
    imprimirTitulo("NUEVA LÍNEA SIMULADA: \(lineaLimpia.uppercased())")
    print("✅ Se creó \(lineaLimpia) con \(recorrido.count) estación(es) en estado 'Simulada'.")
    for (indice, nombreEstacion) in recorrido.enumerated() {
        let distritoEstacion = estaciones[nombreEstacion]?["distrito"] ?? "N/D"
        print("  \(indice + 1). \(nombreEstacion) - \(distritoEstacion)")
    }
    print("🗺️  Recorrido: " + recorrido.joined(separator: " → "))
    if !descartadas.isEmpty {
        print("⚠️ No se agregaron (ya existían en otra línea): " + descartadas.joined(separator: ", "))
    }
    imprimirSeparador()
    print("ℹ️ Recuerda registrar un TRANSBORDO (opción 4) para conectarla con otra línea.")
    imprimirSeparador()
    registrarEnBitacora("Creó la línea simulada '\(lineaLimpia)' con \(recorrido.count) estaciones")
}

// ---- d) REGISTRAR TRANSBORDO ENTRE DOS LÍNEAS ------------------------------
// Sin esto, el planificador no sabe por dónde cambiar de una línea a otra.
func registrarTransbordoEntreLineas(lineaA: String, estacionA: String,
                                    lineaB: String, estacionB: String) {
    if !hayPermisoDeAdministrador() { return }
    guard let nombreLineaA = buscarNombreLinea(lineaA) else {
        print("⚠️ No existe la línea '\(lineaA)'.")
        return
    }
    guard let nombreLineaB = buscarNombreLinea(lineaB) else {
        print("⚠️ No existe la línea '\(lineaB)'.")
        return
    }
    if nombreLineaA == nombreLineaB {
        print("⚠️ El transbordo debe ser entre DOS líneas diferentes.")
        return
    }
    guard let nombreEstacionA = buscarNombreEstacion(estacionA) else {
        print("⚠️ La estación '\(estacionA)' no existe.")
        return
    }
    guard let nombreEstacionB = buscarNombreEstacion(estacionB) else {
        print("⚠️ La estación '\(estacionB)' no existe.")
        return
    }
    if estaciones[nombreEstacionA]?["linea"] != nombreLineaA {
        print("⚠️ '\(nombreEstacionA)' no pertenece a \(nombreLineaA).")
        return
    }
    if estaciones[nombreEstacionB]?["linea"] != nombreLineaB {
        print("⚠️ '\(nombreEstacionB)' no pertenece a \(nombreLineaB).")
        return
    }
    let claveIda = "\(nombreLineaA)-\(nombreLineaB)" // Clave de ida (A → B)
    let claveVuelta = "\(nombreLineaB)-\(nombreLineaA)" // Clave de vuelta (B → A)
    conexionesEntreLineas[claveIda] = "En \(nombreEstacionA) (\(nombreLineaA)) conectando con \(nombreEstacionB) (\(nombreLineaB))"
    conexionesEntreLineas[claveVuelta] = "En \(nombreEstacionB) (\(nombreLineaB)) conectando con \(nombreEstacionA) (\(nombreLineaA))"
    estacionesDeTransbordo[claveIda] = ["enEstaLinea": nombreEstacionA, "enLineaDestino": nombreEstacionB]
    estacionesDeTransbordo[claveVuelta] = ["enEstaLinea": nombreEstacionB, "enLineaDestino": nombreEstacionA]
    estaciones[nombreEstacionA]?["transbordo"] = "\(nombreLineaB) (en \(nombreEstacionB))"
    estaciones[nombreEstacionB]?["transbordo"] = "\(nombreLineaA) (en \(nombreEstacionA))"
    imprimirTitulo("TRANSBORDO REGISTRADO")
    print("✅ \(nombreLineaA) ↔ \(nombreLineaB)")
    print("   \(nombreEstacionA) (\(nombreLineaA))  ⇄  \(nombreEstacionB) (\(nombreLineaB))")
    print("   Ya puedes usar el planificador entre estaciones de ambas líneas.")
    imprimirSeparador()
    registrarEnBitacora("Conectó \(nombreLineaA) y \(nombreLineaB) vía \(nombreEstacionA) ⇄ \(nombreEstacionB)")
}

// ---- BITÁCORA: RESUMEN DE TODO LO QUE SE SIMULÓ -----------------------------
func mostrarBitacoraAdministrador() {
    imprimirTitulo("BITÁCORA DE CAMBIOS DEL ADMINISTRADOR")
    if bitacoraAdministrador.isEmpty {
        print("Todavía no se registran cambios en esta sesión.")
    } else {
        for (indice, accion) in bitacoraAdministrador.enumerated() {
            print("  \(indice + 1). \(accion)")
        }
    }
    imprimirSeparador()
    print("Resumen actual de la red:")
    for (nombreLinea, recorrido) in lineas {
        print("   - \(nombreLinea): \(recorrido.count) estación(es)")
    }
    print("   - Total de estaciones registradas: \(estaciones.count)")
    imprimirSeparador()
}

// ---- MENÚ DEL ADMINISTRADOR -------------------------------------------------
func menuAdministrador() {
    if !modoAdministradorActivo { // Pide la clave solo si la sesión no está abierta
        print("🔐 Ingresa la clave de administrador: ", terminator: "")
        let claveIngresada = readLine() ?? ""
        if !iniciarSesionAdministrador(claveIngresada) { return }
    }
    var seguirEnAdmin = true
    while seguirEnAdmin {
        imprimirTitulo("MODO ADMINISTRADOR - SIMULACIÓN DE LA RED")
        print("1. Insertar una estación ENTRE dos paraderos existentes")
        print("2. Ampliar una línea (agregar estación al inicio o al final)")
        print("3. Crear una NUEVA línea simulada")
        print("4. Registrar transbordo entre dos líneas")
        print("5. Ver bitácora de cambios")
        print("6. Cerrar sesión y volver al menú principal")
        imprimirSeparador()
        print("Elige una opción (1-6): ", terminator: "")
        let opcionAdmin = readLine() ?? ""
        switch opcionAdmin {
        case "1":
            print("Primer paradero existente: ", terminator: "")
            let paraderoA = readLine() ?? ""
            print("Segundo paradero existente (debe ir seguido del primero): ", terminator: "")
            let paraderoB = readLine() ?? ""
            print("Nombre de la NUEVA estación: ", terminator: "")
            let nombreNuevo = readLine() ?? ""
            print("Distrito de la nueva estación: ", terminator: "")
            let distritoNuevo = readLine() ?? ""
            print("Referencia de ubicación: ", terminator: "")
            let referenciaNueva = readLine() ?? ""
            insertarEstacionEntre(estacionA: paraderoA, estacionB: paraderoB,
                                  nuevaEstacion: nombreNuevo, distrito: distritoNuevo,
                                  referencias: referenciaNueva)
        case "2":
            print("¿Qué línea quieres ampliar? (Línea 1 / Línea 2 / otra): ", terminator: "")
            let lineaAmpliar = readLine() ?? ""
            print("Nombre de la NUEVA estación: ", terminator: "")
            let nombreAmpliacion = readLine() ?? ""
            print("Distrito: ", terminator: "")
            let distritoAmpliacion = readLine() ?? ""
            print("Referencia de ubicación: ", terminator: "")
            let referenciaAmpliacion = readLine() ?? ""
            print("¿Va al INICIO del recorrido? (s/n): ", terminator: "")
            let respuestaInicio = readLine() ?? ""
            agregarEstacionAlFinalDeLinea(nombreLinea: lineaAmpliar,
                                          nuevaEstacion: nombreAmpliacion,
                                          distrito: distritoAmpliacion,
                                          referencias: referenciaAmpliacion,
                                          alInicio: respuestaInicio.lowercased() == "s")
        case "3":
            print("Nombre de la nueva línea (ej. Línea 3): ", terminator: "")
            let nombreLineaNueva = readLine() ?? ""
            var estacionesCargadas: [[String: String]] = [] // Array de diccionarios
            var seguirCargando = true
            print("Escribe las estaciones EN ORDEN. Escribe 'fin' para terminar.")
            while seguirCargando {
                print("Estación #\(estacionesCargadas.count + 1) (o 'fin'): ", terminator: "")
                let nombreEstacionNueva = limpiarTexto(readLine() ?? "")
                if normalizar(nombreEstacionNueva) == "fin" || nombreEstacionNueva.isEmpty {
                    seguirCargando = false
                } else {
                    print("   Distrito de \(nombreEstacionNueva): ", terminator: "")
                    let distritoEstacionNueva = readLine() ?? ""
                    print("   Referencia de ubicación: ", terminator: "")
                    let referenciaEstacionNueva = readLine() ?? ""
                    estacionesCargadas.append([
                        "nombre": nombreEstacionNueva,
                        "distrito": distritoEstacionNueva,
                        "referencias": referenciaEstacionNueva
                    ])
                }
            }
            print("Horario de lunes a viernes: ", terminator: "")
            let horarioSemana = readLine() ?? "Por definir"
            print("Horario de sábado: ", terminator: "")
            let horarioSabado = readLine() ?? "Por definir"
            print("Horario de domingo: ", terminator: "")
            let horarioDomingo = readLine() ?? "Por definir"
            crearLineaSimulada(nombreLinea: nombreLineaNueva,
                               estacionesNuevas: estacionesCargadas,
                               horarioLunesAViernes: horarioSemana,
                               horarioSabado: horarioSabado,
                               horarioDomingo: horarioDomingo)
        case "4":
            print("Primera línea: ", terminator: "")
            let primeraLinea = readLine() ?? ""
            print("Estación de transbordo en esa línea: ", terminator: "")
            let primeraEstacion = readLine() ?? ""
            print("Segunda línea: ", terminator: "")
            let segundaLinea = readLine() ?? ""
            print("Estación de transbordo en la segunda línea: ", terminator: "")
            let segundaEstacion = readLine() ?? ""
            registrarTransbordoEntreLineas(lineaA: primeraLinea, estacionA: primeraEstacion,
                                           lineaB: segundaLinea, estacionB: segundaEstacion)
        case "5":
            mostrarBitacoraAdministrador()
        case "6":
            cerrarSesionAdministrador()
            seguirEnAdmin = false
        default:
            print("⚠️ Opción no válida, intenta nuevamente.")
        }
    }
}

// ----------------------------------------------------------------------------
// 14. MENÚ PRINCIPAL (con la nueva opción 8 de administrador; "Salir" ahora es 9)
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
        print("7. Gestionar mi tarjeta (saldo / recarga / pagar pasaje)")
        print("8. Modo administrador (agregar estaciones / crear líneas simuladas) 🔐")
        print("9. Salir")
        imprimirSeparador()
        print("Elige una opción (1-9): ", terminator: "")
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
            print("a. Ver saldo   b. Recargar   c. Pagar pasaje: ", terminator: "")
            let opcionTarjeta = readLine() ?? ""
            if opcionTarjeta == "a" {
                mostrarEstadoTarjeta()
            } else if opcionTarjeta == "b" {
                print("¿Cuánto quieres recargar (S/)? ", terminator: "")
                let montoTexto = readLine() ?? ""
                recargarTarjeta(monto: Double(montoTexto) ?? 0.0)
            } else if opcionTarjeta == "c" {
                print("¿Eres estudiante? (s/n): ", terminator: "")
                let esEstudianteTexto = readLine() ?? ""
                _ = pagarPasaje(esEstudiante: esEstudianteTexto.lowercased() == "s", trayecto: "Viaje simulado")
            } else {
                print("⚠️ Opción no válida.")
            }
        case "8":
            menuAdministrador()
        case "9":
            print("👋 Gracias por usar el sistema de consulta del Metro de Lima.")
            continuarPrograma = false
        default:
            print("⚠️ Opción no válida, intenta nuevamente.")
        }
    }
}

// ----------------------------------------------------------------------------
// 15. EJECUCIÓN
// ----------------------------------------------------------------------------
// Para probar sin readLine(), descomenta y usa directo, por ejemplo:
// planificarViaje(origen: "Villa El Salvador", destino: "Jorge Chávez")
// planificarViaje(origen: "Villa El Salvador", destino: "28 de Julio")
//
// Prueba del modo administrador sin menú (primero hay que iniciar sesión):
// _ = iniciarSesionAdministrador("metro2026")
// insertarEstacionEntre(estacionA: "Angamos", estacionB: "San Borja Sur",
//                       nuevaEstacion: "Canadá", distrito: "San Borja",
//                       referencias: "Cruce de Av. Canadá con Av. Aviación")
menuPrincipal()
