// ============================================================================
// PROYECTO: Sistema de Consulta de Estaciones - Metro de Lima
// CURSO: Desarrollo iOS - Swift (Xcode Playground)
// SEMANA: 03 - Solo se usan: variables, arrays, diccionarios y funciones
// RESTRICCIÓN: NO se usan struct ni class
// ============================================================================
//
// v6 - Planificador de viaje, referencias de ubicación, gestionador de tarjeta
// y MODO ADMINISTRADOR para simular ampliaciones de la red.
//
// EJECUCIÓN EN TERMINAL:
//     swift SistemaConsultaEstacion.swift
//     (o bien: swiftc -o metro SistemaConsultaEstacion.swift && ./metro)
//
// NOVEDADES DE ESTA VERSIÓN:
// - Toda la salida se rediseñó para la terminal: marcos, columnas alineadas,
//   colores ANSI y diagramas de viaje, para que se lea de un vistazo.
// - Los diccionarios de datos son 'var' (antes 'let') porque el administrador
//   necesita agregarles información mientras el programa corre.
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
// 5. ESTILO DE CONSOLA (colores ANSI y medidas del panel)
// ----------------------------------------------------------------------------
// Este sistema está pensado para ejecutarse en la TERMINAL, que sí entiende los
// códigos de color ANSI. Si alguna vez lo pegas en un Xcode Playground (la
// consola del Playground no interpreta colores), pon 'usarColores' en false y
// la salida se seguirá viendo ordenada, solo que en blanco y negro.

let usarColores = true // true = terminal con colores | false = Playground
let anchoPanel = 74 // Ancho fijo de todos los marcos, para que todo quede alineado

let cReset = usarColores ? "\u{001B}[0m" : "" // Vuelve al color normal
let cNegrita = usarColores ? "\u{001B}[1m" : "" // Texto resaltado
let cGris = usarColores ? "\u{001B}[90m" : "" // Detalles secundarios (líneas, puntos)
let cRojo = usarColores ? "\u{001B}[31m" : "" // Errores
let cVerde = usarColores ? "\u{001B}[32m" : "" // Confirmaciones / estado Operativa
let cAmarillo = usarColores ? "\u{001B}[33m" : "" // Avisos / estado En construcción
let cAzul = usarColores ? "\u{001B}[34m" : "" // Información secundaria
let cMagenta = usarColores ? "\u{001B}[35m" : "" // Datos simulados por el administrador
let cCian = usarColores ? "\u{001B}[36m" : "" // Títulos y preguntas

// ----------------------------------------------------------------------------
// 6. HERRAMIENTAS DE FORMATO
// ----------------------------------------------------------------------------
// Para que las columnas queden alineadas hay que saber cuántos ESPACIOS ocupa
// realmente un texto en la terminal: los emojis ocupan 2 y los códigos de color
// no ocupan ninguno. Esta función calcula ese ancho real.
func anchoVisual(_ texto: String) -> Int {
    var ancho = 0 // Acumulador del ancho real
    var dentroDeCodigoDeColor = false // Bandera para ignorar los códigos ANSI
    for caracter in texto {
        if caracter == "\u{001B}" { // Empieza un código de color
            dentroDeCodigoDeColor = true
            continue
        }
        if dentroDeCodigoDeColor { // Se ignora todo hasta que termine en "m"
            if caracter == "m" { dentroDeCodigoDeColor = false }
            continue
        }
        let valor = caracter.unicodeScalars.first?.value ?? 0 // Código del carácter
        let esEmojiAncho = (valor >= 0x1F000 && valor <= 0x1FAFF) // Emojis modernos
            || (valor >= 0x2600 && valor <= 0x27BF) // Símbolos tipo ⚠ ✅ ➤
            || (valor >= 0x2B00 && valor <= 0x2BFF) // Flechas gruesas
            || valor == 0x2139 // El símbolo de información ℹ️
        ancho += esEmojiAncho ? 2 : 1 // El emoji ocupa el doble
    }
    return ancho
}

// Rellena con espacios a la derecha hasta completar el ancho pedido
func rellenar(_ texto: String, _ ancho: Int) -> String {
    let faltante = ancho - anchoVisual(texto)
    if faltante <= 0 { return texto }
    return texto + String(repeating: " ", count: faltante)
}

// Recorta un texto demasiado largo para que no rompa el marco
func recortar(_ texto: String, _ ancho: Int) -> String {
    if anchoVisual(texto) <= ancho { return texto }
    var resultado = ""
    for caracter in texto {
        if anchoVisual(resultado) + 1 >= ancho { break }
        resultado.append(caracter)
    }
    return resultado + "…"
}

// Parte un texto largo en varias líneas, sin cortar palabras a la mitad
func envolverTexto(_ texto: String, ancho: Int) -> [String] {
    var lineasDeTexto: [String] = [] // Resultado final
    var lineaActual = "" // Línea que se está armando
    for palabra in texto.split(separator: " ") {
        let candidata = lineaActual.isEmpty ? String(palabra) : lineaActual + " " + String(palabra)
        if anchoVisual(candidata) > ancho && !lineaActual.isEmpty {
            lineasDeTexto.append(lineaActual) // La línea ya está llena
            lineaActual = String(palabra) // Se empieza una nueva
        } else {
            lineaActual = candidata
        }
    }
    if !lineaActual.isEmpty { lineasDeTexto.append(lineaActual) }
    return lineasDeTexto
}

// Título principal dentro de un marco doble
func imprimirTitulo(_ texto: String) {
    let contenido = " " + recortar(texto.uppercased(), anchoPanel - 2) + " "
    print("")
    print(cCian + "╔" + String(repeating: "═", count: anchoPanel) + "╗" + cReset)
    print(cCian + "║" + cReset + cNegrita + rellenar(contenido, anchoPanel) + cReset + cCian + "║" + cReset)
    print(cCian + "╚" + String(repeating: "═", count: anchoPanel) + "╝" + cReset)
}

// Subtítulo para separar bloques dentro de una misma consulta
func imprimirSeccion(_ texto: String) {
    let etiqueta = " " + texto.uppercased() + " "
    let relleno = max(0, anchoPanel - anchoVisual(etiqueta) - 3)
    print("")
    print(cAzul + "──" + etiqueta + String(repeating: "─", count: relleno) + cReset)
}

// Línea separadora simple
func imprimirSeparador() {
    print(cGris + String(repeating: "─", count: anchoPanel + 2) + cReset)
}

// Dato con etiqueta alineada: "Distrito ······· San Borja"
// Si el valor es muy largo (como los horarios) se parte en varias líneas y se
// alinea debajo, para que nunca se salga del ancho del panel.
func imprimirDato(_ etiqueta: String, _ valor: String) {
    let anchoEtiqueta = 28
    let puntos = String(repeating: "·", count: max(1, anchoEtiqueta - anchoVisual(etiqueta)))
    let prefijo = "  " + recortar(etiqueta, anchoEtiqueta) + " " + cGris + puntos + cReset + " "
    let anchoDisponible = anchoPanel + 2 - anchoVisual(prefijo)
    if anchoVisual(valor) <= anchoDisponible {
        print(prefijo + cNegrita + valor + cReset)
        return
    }
    let sangria = String(repeating: " ", count: anchoVisual(prefijo))
    for (indice, lineaValor) in envolverTexto(valor, ancho: anchoDisponible).enumerated() {
        print((indice == 0 ? prefijo : sangria) + cNegrita + lineaValor + cReset)
    }
}

// Texto largo (recorridos, referencias) partido en varias líneas
func imprimirParrafo(_ texto: String, sangria: String = "  ") {
    for linea in envolverTexto(texto, ancho: anchoPanel - anchoVisual(sangria)) {
        print(sangria + linea)
    }
}

// Mensajes de estado: mismo símbolo, mismo color y siempre dentro del panel.
// Si el mensaje es largo, las líneas siguientes quedan alineadas bajo el texto.
func imprimirMensaje(_ icono: String, _ color: String, _ texto: String) {
    let prefijo = "  " + icono + " "
    let sangria = String(repeating: " ", count: anchoVisual(prefijo))
    let lineasMensaje = envolverTexto(texto, ancho: anchoPanel + 2 - anchoVisual(prefijo))
    for (indice, lineaMensaje) in lineasMensaje.enumerated() {
        print(color + (indice == 0 ? prefijo : sangria) + lineaMensaje + cReset)
    }
}

func imprimirExito(_ texto: String) { imprimirMensaje("✅", cVerde, texto) }
func imprimirAviso(_ texto: String) { imprimirMensaje("⚠️", cAmarillo, texto) }
func imprimirError(_ texto: String) { imprimirMensaje("❌", cRojo, texto) }
func imprimirInfo(_ texto: String) { imprimirMensaje("ℹ️", cAzul, texto) }
func imprimirNota(_ texto: String) { imprimirMensaje(" ", cGris, texto) }

// Opción de menú: " [1]  Ver estaciones de una línea"
func imprimirOpcion(_ tecla: String, _ icono: String, _ texto: String) {
    print("  " + cCian + "[" + tecla + "]" + cReset + " " + icono + "  " + texto)
}

// Pregunta estándar al usuario (ya devuelve el texto limpio de espacios)
func preguntar(_ pregunta: String) -> String {
    print("  " + cCian + "➤ " + cReset + pregunta + " " + cGris + "» " + cReset, terminator: "")
    return (readLine() ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
}

// Pausa para que el resultado se pueda leer antes de volver al menú
func pausar() {
    print("")
    print("  " + cGris + "Presiona ENTER para volver al menú…" + cReset, terminator: "")
    _ = readLine()
}

// Devuelve el estado de la estación con un punto de color delante
func etiquetaEstado(_ estado: String) -> String {
    if estado == "Operativa" { return cVerde + "● Operativa" + cReset }
    if estado == "En construcción" { return cAmarillo + "● En construcción" + cReset }
    if estado == "Simulada" { return cMagenta + "● Simulada" + cReset }
    return cGris + "● " + estado + cReset
}

// Convierte un "Sí"/"No" en un símbolo fácil de leer de un vistazo
func etiquetaSiNo(_ valor: String) -> String {
    if valor == "Sí" { return cVerde + "Sí" + cReset }
    if valor == "No" { return cGris + "No" + cReset }
    return valor
}

// ----------------------------------------------------------------------------
// 7. BÚSQUEDA FLEXIBLE DE NOMBRES
// ----------------------------------------------------------------------------
// El usuario puede escribir el nombre como quiera (mayúsculas o minúsculas, con
// o sin acentos) y el sistema igual lo encuentra.
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

// Posición de una estación dentro del array de su línea
func obtenerIndiceEnLinea(_ nombreEstacion: String, _ listaEstaciones: [String]) -> Int? {
    for (indice, estacion) in listaEstaciones.enumerated() {
        if estacion == nombreEstacion {
            return indice
        }
    }
    return nil
}

// Sugerencias cuando el usuario escribe un nombre que no existe
func sugerirNombresParecidos(_ textoIngresado: String) {
    let textoNormalizado = normalizar(textoIngresado)
    if textoNormalizado.isEmpty { return }
    var parecidas: [String] = []
    for claveEstacion in estaciones.keys {
        if normalizar(claveEstacion).contains(textoNormalizado) {
            parecidas.append(claveEstacion)
        }
    }
    if !parecidas.isEmpty {
        imprimirNota("¿Quisiste decir? " + parecidas.sorted().prefix(5).joined(separator: " · "))
    }
}

// ----------------------------------------------------------------------------
// 8. CONSULTA DE ESTACIONES POR LÍNEA
// ----------------------------------------------------------------------------
func mostrarEstacionesDeLinea(_ nombreLinea: String) {
    guard let lineaReal = buscarNombreLinea(nombreLinea) else {
        imprimirError("No existe información registrada para '\(nombreLinea)'.")
        imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
        return
    }
    let listaEstaciones = lineas[lineaReal] ?? []
    imprimirTitulo("Estaciones de \(lineaReal)")
    print("  " + cGris + "Nº │ " + rellenar("ESTACIÓN", 26) + " " + rellenar("ESTADO", 20) + "DISTRITO" + cReset)
    print("  " + cGris + String(repeating: "─", count: anchoPanel) + cReset)
    var operativas = 0
    for (indice, nombreEstacion) in listaEstaciones.enumerated() {
        let detalle = estaciones[nombreEstacion] ?? [:]
        let estado = detalle["estado"] ?? "Desconocido"
        if estado == "Operativa" { operativas += 1 }
        let numero = String(format: "%02d", indice + 1)
        print("  " + cGris + numero + " │ " + cReset
              + rellenar(recortar(nombreEstacion, 25), 26) + " "
              + rellenar(etiquetaEstado(estado), 20)
              + cGris + recortar(detalle["distrito"] ?? "N/D", 22) + cReset)
    }
    imprimirSeccion("Resumen")
    imprimirDato("Total de estaciones", "\(listaEstaciones.count)")
    imprimirDato("Operativas", "\(operativas)")
    imprimirDato("Aún no operativas", "\(listaEstaciones.count - operativas)")
    imprimirSeccion("Recorrido completo")
    imprimirParrafo(listaEstaciones.joined(separator: " → "))
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 9. DETALLE DE UNA ESTACIÓN
// ----------------------------------------------------------------------------
func mostrarDetalleEstacion(_ nombreEstacion: String) {
    guard let nombreReal = buscarNombreEstacion(nombreEstacion) else {
        imprimirError("La estación '\(nombreEstacion)' no fue encontrada.")
        sugerirNombresParecidos(nombreEstacion)
        return
    }
    let detalle = estaciones[nombreReal] ?? [:]
    let lineaDeLaEstacion = detalle["linea"] ?? ""
    imprimirTitulo("Estación \(nombreReal)")
    imprimirSeccion("Ficha de la estación")
    imprimirDato("Línea", detalle["linea"] ?? "N/D")
    imprimirDato("Distrito", detalle["distrito"] ?? "N/D")
    imprimirDato("Estado", etiquetaEstado(detalle["estado"] ?? "N/D"))
    imprimirDato("Ascensor", etiquetaSiNo(detalle["ascensor"] ?? "N/D"))
    imprimirDato("Conecta con Metropolitano", etiquetaSiNo(detalle["metropolitano"] ?? "N/D"))
    imprimirDato("Transbordo con otra línea", detalle["transbordo"] ?? "N/D")
    imprimirSeccion("Cómo ubicarte")
    imprimirParrafo(detalle["referencias"] ?? "Pendiente de completar por el equipo")
    if let recorrido = lineas[lineaDeLaEstacion],
       let indice = obtenerIndiceEnLinea(nombreReal, recorrido) {
        imprimirSeccion("Estaciones vecinas")
        let anterior = indice > 0 ? recorrido[indice - 1] : "— (terminal)"
        let siguiente = indice < recorrido.count - 1 ? recorrido[indice + 1] : "— (terminal)"
        imprimirParrafo(cGris + anterior + cReset + "  ←  " + cNegrita + nombreReal + cReset + "  →  " + cGris + siguiente + cReset)
        imprimirNota("Posición \(indice + 1) de \(recorrido.count) en \(lineaDeLaEstacion)")
    }
    imprimirSeccion("Horario referencial de \(lineaDeLaEstacion)")
    if let horarioLinea = horariosPorLinea[lineaDeLaEstacion] {
        imprimirDato("Lunes a viernes", horarioLinea["lunesAViernes"] ?? "N/D")
        imprimirDato("Sábado", horarioLinea["sabado"] ?? "N/D")
        imprimirDato("Domingo", horarioLinea["domingo"] ?? "N/D")
    } else {
        imprimirAviso("Aún no hay horario registrado para \(lineaDeLaEstacion).")
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 10. HORARIO DE UNA LÍNEA
// ----------------------------------------------------------------------------
func mostrarHorarioDeLinea(_ nombreLinea: String) {
    guard let lineaReal = buscarNombreLinea(nombreLinea) else {
        imprimirError("No existe información registrada para '\(nombreLinea)'.")
        imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
        return
    }
    let horario = horariosPorLinea[lineaReal] ?? [:]
    imprimirTitulo("Horario de \(lineaReal)")
    imprimirDato("Lunes a viernes", horario["lunesAViernes"] ?? "N/D")
    imprimirDato("Sábado", horario["sabado"] ?? "N/D")
    imprimirDato("Domingo", horario["domingo"] ?? "N/D")
    imprimirSeparador()
    imprimirNota("Los horarios son referenciales y pueden variar por feriados o mantenimiento.")
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 11. BUSCAR POR DISTRITO DE DESTINO
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
    return resultado.sorted()
}

func sugerirRutaPorDistrito(origen: String, distritoDestino: String) {
    guard let origenReal = buscarNombreEstacion(origen) else {
        imprimirError("La estación de origen '\(origen)' no fue encontrada.")
        sugerirNombresParecidos(origen)
        return
    }
    let estacionesEnDistrito = buscarPorDistrito(distritoDestino)
    imprimirTitulo("Cómo llegar a \(distritoDestino)")
    if estacionesEnDistrito.isEmpty {
        imprimirError("No hay ninguna estación registrada en el distrito '\(distritoDestino)'.")
        imprimirNota("Puede que ese distrito todavía no tenga estación, o que el nombre esté escrito distinto al oficial.")
        imprimirSeparador()
        return
    }
    imprimirSeccion("Estaciones en \(distritoDestino)")
    for (indice, estacionCandidata) in estacionesEnDistrito.enumerated() {
        let detalle = estaciones[estacionCandidata] ?? [:]
        print("  " + cGris + String(format: "%02d", indice + 1) + " │ " + cReset
              + rellenar(recortar(estacionCandidata, 25), 26) + " "
              + rellenar(detalle["linea"] ?? "N/D", 12)
              + etiquetaEstado(detalle["estado"] ?? "N/D"))
    }
    if let primeraOpcion = estacionesEnDistrito.first {
        imprimirSeccion("Ruta tomando como referencia \(primeraOpcion)")
        sugerirRuta(origen: origenReal, destino: primeraOpcion)
    }
}

// ----------------------------------------------------------------------------
// 12. SUGERIR LA MEJOR RUTA (con validación de estado)
// ----------------------------------------------------------------------------
func sugerirRuta(origen: String, destino: String) {
    guard let origenReal = buscarNombreEstacion(origen) else {
        imprimirError("La estación de origen '\(origen)' no fue encontrada.")
        sugerirNombresParecidos(origen)
        return
    }
    guard let destinoReal = buscarNombreEstacion(destino) else {
        imprimirError("La estación de destino '\(destino)' no fue encontrada.")
        sugerirNombresParecidos(destino)
        return
    }
    let detalleOrigen = estaciones[origenReal] ?? [:]
    let detalleDestino = estaciones[destinoReal] ?? [:]
    let lineaOrigen = detalleOrigen["linea"] ?? ""
    let lineaDestino = detalleDestino["linea"] ?? ""
    let estadoOrigen = detalleOrigen["estado"] ?? "Desconocido"
    let estadoDestino = detalleDestino["estado"] ?? "Desconocido"
    imprimirTitulo("Ruta: \(origenReal) → \(destinoReal)")
    imprimirDato("Origen", origenReal + cGris + "  (" + lineaOrigen + ")" + cReset)
    imprimirDato("Destino", destinoReal + cGris + "  (" + lineaDestino + ")" + cReset)
    if estadoOrigen != "Operativa" {
        imprimirAviso("'\(origenReal)' figura como '\(estadoOrigen)': todavía NO está habilitada para viajar.")
    }
    if estadoDestino != "Operativa" {
        imprimirAviso("'\(destinoReal)' figura como '\(estadoDestino)': todavía NO está habilitada para viajar.")
    }
    imprimirSeccion("Cómo llegar")
    if lineaOrigen == lineaDestino {
        imprimirExito("Viaje directo por \(lineaOrigen). No necesitas transbordo.")
        imprimirParrafo("Toma \(lineaOrigen) en \(origenReal) y baja en \(destinoReal).")
    } else {
        let clave = "\(lineaOrigen)-\(lineaDestino)"
        if let conexion = conexionesEntreLineas[clave] {
            imprimirInfo("Necesitas 1 transbordo: \(lineaOrigen) → \(lineaDestino)")
            imprimirParrafo("Punto de conexión: " + conexion)
            imprimirParrafo("Luego continúa en \(lineaDestino) hasta \(destinoReal).")
        } else {
            imprimirError("Aún no existe una conexión registrada entre \(lineaOrigen) y \(lineaDestino).")
        }
    }
    if detalleDestino["metropolitano"] == "Sí" {
        imprimirInfo("Dato extra: \(destinoReal) también conecta con el Metropolitano.")
    }
    if estadoOrigen != "Operativa" || estadoDestino != "Operativa" {
        imprimirNota("Esta ruta es REFERENCIAL: no podrás usarla hasta que esa estación entre en operación.")
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 13. PLANIFICADOR DE VIAJE (cuántas estaciones faltan)
// ----------------------------------------------------------------------------
// Dibuja el viaje como un pequeño diagrama vertical para que se entienda
// de un vistazo cuántas estaciones faltan y dónde hay que cambiar de tren.
func imprimirTramo(desde: String, hasta: String, cantidad: Int, linea: String, esUltimo: Bool) {
    print("   " + cVerde + "◉" + cReset + " " + cNegrita + desde + cReset)
    print("   " + cGris + "│" + cReset)
    print("   " + cGris + "│  " + cReset + cAzul + "\(cantidad) estación(es)" + cReset + cGris + " · " + linea + cReset)
    print("   " + cGris + "│" + cReset)
    if esUltimo {
        print("   " + cRojo + "◉" + cReset + " " + cNegrita + hasta + cReset)
    } else {
        print("   " + cMagenta + "◎" + cReset + " " + cNegrita + hasta + cReset + cMagenta + "  ⇄ transbordo" + cReset)
    }
}

func planificarViaje(origen: String, destino: String) {
    guard let origenReal = buscarNombreEstacion(origen) else {
        imprimirError("La estación de origen '\(origen)' no fue encontrada.")
        sugerirNombresParecidos(origen)
        return
    }
    guard let destinoReal = buscarNombreEstacion(destino) else {
        imprimirError("La estación de destino '\(destino)' no fue encontrada.")
        sugerirNombresParecidos(destino)
        return
    }
    if origenReal == destinoReal {
        imprimirTitulo("Planificador de viaje")
        imprimirAviso("El origen y el destino son la misma estación: ya estás ahí.")
        imprimirSeparador()
        return
    }
    let lineaOrigen = estaciones[origenReal]?["linea"] ?? ""
    let lineaDestino = estaciones[destinoReal]?["linea"] ?? ""
    imprimirTitulo("Viaje: \(origenReal) → \(destinoReal)")
    if lineaOrigen == lineaDestino {
        let listaEstaciones = lineas[lineaOrigen] ?? []
        guard let indiceOrigen = obtenerIndiceEnLinea(origenReal, listaEstaciones),
              let indiceDestino = obtenerIndiceEnLinea(destinoReal, listaEstaciones) else {
            imprimirError("No se pudo ubicar alguna estación dentro de \(lineaOrigen).")
            imprimirSeparador()
            return
        }
        let estacionesAPasar = abs(indiceDestino - indiceOrigen)
        imprimirSeccion("Recorrido")
        imprimirTramo(desde: origenReal, hasta: destinoReal, cantidad: estacionesAPasar,
                      linea: lineaOrigen, esUltimo: true)
        imprimirSeccion("Resumen del viaje")
        imprimirDato("Línea", lineaOrigen)
        imprimirDato("Transbordos", "0 (viaje directo)")
        imprimirDato("Estaciones por recorrer", "\(estacionesAPasar)")
        imprimirDato("Sentido", indiceDestino > indiceOrigen ? "Hacia \(listaEstaciones.last ?? "")" : "Hacia \(listaEstaciones.first ?? "")")
        let inicio = min(indiceOrigen, indiceDestino)
        let fin = max(indiceOrigen, indiceDestino)
        var tramo: [String] = []
        var i = inicio
        while i <= fin {
            tramo.append(listaEstaciones[i])
            i += 1
        }
        if indiceOrigen > indiceDestino { tramo.reverse() }
        imprimirSeccion("Estaciones en las que pasarás")
        imprimirParrafo(tramo.joined(separator: " → "))
    } else {
        let clave = "\(lineaOrigen)-\(lineaDestino)"
        guard let transbordo = estacionesDeTransbordo[clave] else {
            imprimirError("Aún no hay una conexión registrada entre \(lineaOrigen) y \(lineaDestino).")
            imprimirNota("El administrador puede registrarla desde el menú 8, opción 4.")
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
            imprimirError("No se pudo calcular el tramo completo con la información disponible.")
            imprimirSeparador()
            return
        }
        let tramo1 = abs(i2 - i1)
        let tramo2 = abs(i4 - i3)
        imprimirSeccion("Recorrido")
        imprimirTramo(desde: origenReal, hasta: estacionCambioOrigen, cantidad: tramo1,
                      linea: lineaOrigen, esUltimo: false)
        if estacionCambioOrigen != estacionCambioDestino {
            print("   " + cMagenta + "┆  cambia a \(estacionCambioDestino)" + cReset)
        }
        imprimirTramo(desde: estacionCambioDestino, hasta: destinoReal, cantidad: tramo2,
                      linea: lineaDestino, esUltimo: true)
        imprimirSeccion("Resumen del viaje")
        imprimirDato("Tramo 1 · \(lineaOrigen)", "\(tramo1) estación(es)")
        imprimirDato("Tramo 2 · \(lineaDestino)", "\(tramo2) estación(es)")
        imprimirDato("Transbordos", "1")
        imprimirDato("Total aproximado", "\(tramo1 + tramo2) estación(es)")
    }
    imprimirSeparador()
}

// ----------------------------------------------------------------------------
// 14. GESTIONADOR DE TARJETA (tarifas reales Línea 1, 2026)
// ----------------------------------------------------------------------------
var saldoTarjeta: Double = 0.0 // Saldo actual (arranca en S/ 0.00, hay que recargar)
var totalConsumido: Double = 0.0 // Acumulado histórico de lo gastado en pasajes
var historialDeViajes: [String] = [] // Un texto por cada viaje pagado
let costoPasajeAdulto: Double = 1.50 // Tarifa adulto real (2026)
let costoPasajeEstudiante: Double = 0.75 // Tarifa estudiante real, L-S (2026)

// Formatea un monto siempre con 2 decimales y el símbolo de soles
func soles(_ monto: Double) -> String {
    return "S/ " + String(format: "%.2f", monto)
}

func recargarTarjeta(monto: Double) {
    if monto < 0.10 {
        imprimirAviso("El monto mínimo de recarga es " + soles(0.10) + ".")
        return
    }
    saldoTarjeta += monto
    imprimirExito("Recarga de " + soles(monto) + " realizada.")
    imprimirDato("Saldo actual", soles(saldoTarjeta))
}

func pagarPasaje(esEstudiante: Bool, trayecto: String) -> Bool {
    let costo = esEstudiante ? costoPasajeEstudiante : costoPasajeAdulto
    let tipoPasajero = esEstudiante ? "Estudiante" : "Adulto"
    if saldoTarjeta >= costo {
        saldoTarjeta -= costo
        totalConsumido += costo
        historialDeViajes.append(trayecto + "  ·  " + tipoPasajero + "  ·  " + soles(costo))
        imprimirExito("Pasaje pagado: " + soles(costo) + " (tarifa " + tipoPasajero.lowercased() + ").")
        imprimirDato("Trayecto", trayecto)
        imprimirDato("Saldo restante", soles(saldoTarjeta))
        if saldoTarjeta < costoPasajeAdulto {
            imprimirAviso("Tu saldo ya no alcanza para otro pasaje de adulto. Considera recargar.")
        }
        return true
    }
    imprimirError("Saldo insuficiente.")
    imprimirDato("Saldo actual", soles(saldoTarjeta))
    imprimirDato("Costo del pasaje", soles(costo))
    imprimirDato("Te falta", soles(costo - saldoTarjeta))
    return false
}

func mostrarEstadoTarjeta() {
    imprimirTitulo("Estado de tu tarjeta")
    imprimirDato("Saldo actual", soles(saldoTarjeta))
    imprimirDato("Total consumido", soles(totalConsumido))
    imprimirDato("Viajes realizados", "\(historialDeViajes.count)")
    imprimirDato("Pasajes que aún puedes pagar", "\(Int(saldoTarjeta / costoPasajeAdulto)) (tarifa adulto)")
    imprimirSeccion("Historial de viajes")
    if historialDeViajes.isEmpty {
        imprimirNota("Aún no registras viajes pagados con la tarjeta.")
    } else {
        for (indice, viaje) in historialDeViajes.enumerated() {
            print("  " + cGris + String(format: "%02d", indice + 1) + " │ " + cReset + viaje)
        }
    }
    imprimirSeparador()
}

// Submenú de la tarjeta, para que cada acción tenga su propia pantalla
func menuTarjeta() {
    var seguirEnTarjeta = true
    while seguirEnTarjeta {
        imprimirTitulo("Mi tarjeta · saldo " + soles(saldoTarjeta))
        imprimirOpcion("1", "💳", "Ver saldo e historial")
        imprimirOpcion("2", "💰", "Recargar tarjeta")
        imprimirOpcion("3", "🚇", "Pagar un pasaje")
        imprimirOpcion("4", "↩️", "Volver al menú principal")
        imprimirSeparador()
        let opcionTarjeta = preguntar("Elige una opción (1-4):")
        switch opcionTarjeta {
        case "1":
            mostrarEstadoTarjeta()
            pausar()
        case "2":
            let montoTexto = preguntar("¿Cuánto quieres recargar (S/)?")
            if let monto = Double(montoTexto.replacingOccurrences(of: ",", with: ".")) {
                recargarTarjeta(monto: monto)
            } else {
                imprimirError("'\(montoTexto)' no es un monto válido. Escribe solo números, por ejemplo 10.50")
            }
            pausar()
        case "3":
            let origenViaje = preguntar("Estación de ORIGEN:")
            let destinoViaje = preguntar("Estación de DESTINO:")
            var trayecto = "Viaje simulado"
            if let origenReal = buscarNombreEstacion(origenViaje),
               let destinoReal = buscarNombreEstacion(destinoViaje) {
                trayecto = origenReal + " → " + destinoReal
            } else {
                imprimirAviso("No se reconocieron ambas estaciones; se registrará como viaje simulado.")
            }
            let respuestaEstudiante = preguntar("¿Eres estudiante? (s/n):")
            _ = pagarPasaje(esEstudiante: normalizar(respuestaEstudiante) == "s",
                            trayecto: trayecto)
            pausar()
        case "4":
            seguirEnTarjeta = false
        default:
            imprimirAviso("Opción no válida, intenta nuevamente.")
        }
    }
}

// ----------------------------------------------------------------------------
// 15. MODO ADMINISTRADOR (simulación de ampliaciones de la red)
// ----------------------------------------------------------------------------
// El administrador puede AGREGAR datos al sistema para simular cómo quedaría la
// red del Metro de Lima si creciera:
//   1) Insertar una estación NUEVA entre dos paraderos que ya existen.
//   2) Ampliar una línea agregando una estación al inicio o al final.
//   3) Crear una LÍNEA NUEVA simulada con sus estaciones y su horario.
//   4) Registrar el transbordo entre dos líneas para que el planificador funcione.
// Todo se guarda en los MISMOS diccionarios y arrays (sin struct ni class).

let claveAdministrador = "metro2026" // Clave simulada de acceso
var modoAdministradorActivo = false // Indica si la sesión está abierta
var bitacoraAdministrador: [String] = [] // Un texto por cada cambio realizado

func registrarEnBitacora(_ accion: String) {
    bitacoraAdministrador.append(accion)
}

// Quita espacios sobrantes (por si la función se llama fuera del menú)
func limpiarTexto(_ texto: String) -> String {
    return texto.trimmingCharacters(in: .whitespacesAndNewlines)
}

func iniciarSesionAdministrador(_ claveIngresada: String) -> Bool {
    if limpiarTexto(claveIngresada) == claveAdministrador {
        modoAdministradorActivo = true
        imprimirExito("Acceso concedido. Modo ADMINISTRADOR activado.")
        return true
    }
    imprimirError("Clave incorrecta. El modo administrador NO fue activado.")
    return false
}

func cerrarSesionAdministrador() {
    modoAdministradorActivo = false
    imprimirNota("Sesión de administrador cerrada.")
}

func hayPermisoDeAdministrador() -> Bool {
    if !modoAdministradorActivo {
        imprimirError("Esta acción es solo para el administrador. Inicia sesión primero.")
        return false
    }
    return true
}

// Guarda (o reemplaza) el detalle completo de una estación
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

// ---- 1) INSERTAR UNA ESTACIÓN ENTRE DOS PARADEROS EXISTENTES ---------------
func insertarEstacionEntre(estacionA: String, estacionB: String, nuevaEstacion: String,
                           distrito: String, referencias: String,
                           estado: String = "Simulada", ascensor: String = "No",
                           metropolitano: String = "No") {
    if !hayPermisoDeAdministrador() { return }
    let nombreNueva = limpiarTexto(nuevaEstacion)
    if nombreNueva.isEmpty {
        imprimirAviso("El nombre de la estación nueva no puede estar vacío.")
        return
    }
    guard let nombreA = buscarNombreEstacion(estacionA) else {
        imprimirError("El paradero '\(estacionA)' no existe en el sistema.")
        sugerirNombresParecidos(estacionA)
        return
    }
    guard let nombreB = buscarNombreEstacion(estacionB) else {
        imprimirError("El paradero '\(estacionB)' no existe en el sistema.")
        sugerirNombresParecidos(estacionB)
        return
    }
    if buscarNombreEstacion(nombreNueva) != nil {
        imprimirAviso("Ya existe una estación llamada '\(nombreNueva)'. Usa otro nombre.")
        return
    }
    let lineaA = estaciones[nombreA]?["linea"] ?? ""
    let lineaB = estaciones[nombreB]?["linea"] ?? ""
    if lineaA != lineaB {
        imprimirError("'\(nombreA)' es de \(lineaA) y '\(nombreB)' es de \(lineaB).")
        imprimirNota("Solo se puede insertar una estación entre dos paraderos de la MISMA línea.")
        return
    }
    var recorrido = lineas[lineaA] ?? []
    guard let indiceA = obtenerIndiceEnLinea(nombreA, recorrido),
          let indiceB = obtenerIndiceEnLinea(nombreB, recorrido) else {
        imprimirError("No se pudo ubicar alguno de los paraderos dentro de \(lineaA).")
        return
    }
    if abs(indiceA - indiceB) != 1 {
        imprimirError("'\(nombreA)' y '\(nombreB)' NO son paraderos consecutivos.")
        imprimirNota("Entre ellos hay \(abs(indiceA - indiceB) - 1) estación(es); elige dos que estén seguidas.")
        return
    }
    let posicionDeInsercion = max(indiceA, indiceB) // La nueva queda justo entre las dos
    recorrido.insert(nombreNueva, at: posicionDeInsercion)
    lineas[lineaA] = recorrido
    guardarDatosDeEstacion(nombre: nombreNueva, linea: lineaA, estado: estado,
                           ascensor: ascensor, metropolitano: metropolitano,
                           transbordo: "Ninguna",
                           distrito: limpiarTexto(distrito),
                           referencias: limpiarTexto(referencias))
    imprimirTitulo("Estación insertada: \(nombreNueva)")
    imprimirExito("'\(nombreNueva)' quedó registrada en \(lineaA).")
    imprimirDato("Entre los paraderos", "\(nombreA)  ↔  \(nombreB)")
    imprimirDato("Posición en el recorrido", "\(posicionDeInsercion + 1) de \(recorrido.count)")
    imprimirDato("Estado", etiquetaEstado(estado))
    imprimirDato("Distrito", limpiarTexto(distrito))
    imprimirSeccion("Nuevo recorrido de \(lineaA)")
    imprimirParrafo(recorrido.joined(separator: " → "))
    imprimirSeparador()
    registrarEnBitacora("Insertó '\(nombreNueva)' en \(lineaA), entre \(nombreA) y \(nombreB)")
}

// ---- 2) AMPLIAR UNA LÍNEA: NUEVA ESTACIÓN TERMINAL -------------------------
func agregarEstacionAlFinalDeLinea(nombreLinea: String, nuevaEstacion: String,
                                   distrito: String, referencias: String,
                                   alInicio: Bool = false, estado: String = "Simulada") {
    if !hayPermisoDeAdministrador() { return }
    guard let lineaReal = buscarNombreLinea(nombreLinea) else {
        imprimirError("No existe la línea '\(nombreLinea)'.")
        imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
        return
    }
    let nombreNueva = limpiarTexto(nuevaEstacion)
    if nombreNueva.isEmpty {
        imprimirAviso("El nombre de la estación nueva no puede estar vacío.")
        return
    }
    if buscarNombreEstacion(nombreNueva) != nil {
        imprimirAviso("Ya existe una estación llamada '\(nombreNueva)'. Usa otro nombre.")
        return
    }
    var recorrido = lineas[lineaReal] ?? []
    if alInicio {
        recorrido.insert(nombreNueva, at: 0) // Nuevo terminal al inicio
    } else {
        recorrido.append(nombreNueva) // Nuevo terminal al final
    }
    lineas[lineaReal] = recorrido
    guardarDatosDeEstacion(nombre: nombreNueva, linea: lineaReal, estado: estado,
                           ascensor: "No", metropolitano: "No", transbordo: "Ninguna",
                           distrito: limpiarTexto(distrito),
                           referencias: limpiarTexto(referencias))
    imprimirTitulo("Ampliación de \(lineaReal)")
    imprimirExito("'\(nombreNueva)' se agregó como nuevo terminal.")
    imprimirDato("Extremo", alInicio ? "Inicio del recorrido" : "Final del recorrido")
    imprimirDato("Estado", etiquetaEstado(estado))
    imprimirDato("Estaciones de la línea", "\(recorrido.count)")
    imprimirSeccion("Nuevo recorrido de \(lineaReal)")
    imprimirParrafo(recorrido.joined(separator: " → "))
    imprimirSeparador()
    registrarEnBitacora("Amplió \(lineaReal) con '\(nombreNueva)' al " + (alInicio ? "inicio" : "final"))
}

// ---- 3) CREAR UNA NUEVA LÍNEA SIMULADA -------------------------------------
// 'estacionesNuevas' es un ARRAY DE DICCIONARIOS: cada uno con "nombre",
// "distrito" y "referencias". Así se agrupan datos sin usar struct ni class.
func crearLineaSimulada(nombreLinea: String, estacionesNuevas: [[String: String]],
                        horarioLunesAViernes: String, horarioSabado: String,
                        horarioDomingo: String) {
    if !hayPermisoDeAdministrador() { return }
    let lineaLimpia = limpiarTexto(nombreLinea)
    if lineaLimpia.isEmpty {
        imprimirAviso("El nombre de la línea no puede estar vacío.")
        return
    }
    if buscarNombreLinea(lineaLimpia) != nil {
        imprimirAviso("La línea '\(lineaLimpia)' ya existe en el sistema.")
        return
    }
    if estacionesNuevas.count < 2 {
        imprimirAviso("Una línea necesita al menos 2 estaciones para poder simular viajes.")
        return
    }
    var recorrido: [String] = [] // Orden físico de la línea nueva
    var descartadas: [String] = [] // Nombres repetidos que no se registraron
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
        imprimirError("No se pudo crear '\(lineaLimpia)': quedaron menos de 2 estaciones válidas.")
        for nombreAgregado in recorrido { estaciones[nombreAgregado] = nil } // Deshace lo agregado
        return
    }
    lineas[lineaLimpia] = recorrido // Se registra el recorrido
    horariosPorLinea[lineaLimpia] = [ // Se registra su horario referencial
        "lunesAViernes": limpiarTexto(horarioLunesAViernes),
        "sabado": limpiarTexto(horarioSabado),
        "domingo": limpiarTexto(horarioDomingo)
    ]
    imprimirTitulo("Nueva línea simulada: \(lineaLimpia)")
    imprimirExito("Se creó \(lineaLimpia) con \(recorrido.count) estación(es).")
    imprimirSeccion("Estaciones registradas")
    for (indice, nombreEstacion) in recorrido.enumerated() {
        let distritoEstacion = estaciones[nombreEstacion]?["distrito"] ?? "N/D"
        print("  " + cGris + String(format: "%02d", indice + 1) + " │ " + cReset
              + rellenar(recortar(nombreEstacion, 25), 26) + " "
              + rellenar(etiquetaEstado("Simulada"), 20)
              + cGris + recortar(distritoEstacion, 22) + cReset)
    }
    imprimirSeccion("Recorrido")
    imprimirParrafo(recorrido.joined(separator: " → "))
    if !descartadas.isEmpty {
        imprimirAviso("No se agregaron (ya existían en otra línea): " + descartadas.joined(separator: ", "))
    }
    imprimirSeparador()
    imprimirInfo("Registra un TRANSBORDO (opción 4) para conectarla con otra línea.")
    imprimirSeparador()
    registrarEnBitacora("Creó la línea simulada '\(lineaLimpia)' con \(recorrido.count) estaciones")
}

// ---- 4) REGISTRAR TRANSBORDO ENTRE DOS LÍNEAS ------------------------------
// Sin esto, el planificador no sabe por dónde cambiar de una línea a otra.
func registrarTransbordoEntreLineas(lineaA: String, estacionA: String,
                                    lineaB: String, estacionB: String) {
    if !hayPermisoDeAdministrador() { return }
    guard let nombreLineaA = buscarNombreLinea(lineaA) else {
        imprimirError("No existe la línea '\(lineaA)'.")
        return
    }
    guard let nombreLineaB = buscarNombreLinea(lineaB) else {
        imprimirError("No existe la línea '\(lineaB)'.")
        return
    }
    if nombreLineaA == nombreLineaB {
        imprimirAviso("El transbordo debe ser entre DOS líneas diferentes.")
        return
    }
    guard let nombreEstacionA = buscarNombreEstacion(estacionA) else {
        imprimirError("La estación '\(estacionA)' no existe.")
        sugerirNombresParecidos(estacionA)
        return
    }
    guard let nombreEstacionB = buscarNombreEstacion(estacionB) else {
        imprimirError("La estación '\(estacionB)' no existe.")
        sugerirNombresParecidos(estacionB)
        return
    }
    if estaciones[nombreEstacionA]?["linea"] != nombreLineaA {
        imprimirError("'\(nombreEstacionA)' no pertenece a \(nombreLineaA).")
        return
    }
    if estaciones[nombreEstacionB]?["linea"] != nombreLineaB {
        imprimirError("'\(nombreEstacionB)' no pertenece a \(nombreLineaB).")
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
    imprimirTitulo("Transbordo registrado")
    imprimirExito("\(nombreLineaA)  ⇄  \(nombreLineaB)")
    imprimirDato("Punto en \(nombreLineaA)", nombreEstacionA)
    imprimirDato("Punto en \(nombreLineaB)", nombreEstacionB)
    imprimirNota("Ya puedes usar el planificador entre estaciones de ambas líneas.")
    imprimirSeparador()
    registrarEnBitacora("Conectó \(nombreLineaA) y \(nombreLineaB) vía \(nombreEstacionA) ⇄ \(nombreEstacionB)")
}

// ---- BITÁCORA: RESUMEN DE TODO LO QUE SE SIMULÓ -----------------------------
func mostrarBitacoraAdministrador() {
    imprimirTitulo("Bitácora de cambios del administrador")
    imprimirSeccion("Cambios de esta sesión")
    if bitacoraAdministrador.isEmpty {
        imprimirNota("Todavía no se registran cambios en esta sesión.")
    } else {
        for (indice, accion) in bitacoraAdministrador.enumerated() {
            print("  " + cGris + String(format: "%02d", indice + 1) + " │ " + cReset + accion)
        }
    }
    imprimirSeccion("Estado actual de la red")
    for nombreLinea in lineas.keys.sorted() {
        let recorrido = lineas[nombreLinea] ?? []
        imprimirDato(nombreLinea, "\(recorrido.count) estación(es)")
    }
    imprimirDato("Total de estaciones", "\(estaciones.count)")
    imprimirSeparador()
}

// ---- MENÚ DEL ADMINISTRADOR -------------------------------------------------
func menuAdministrador() {
    if !modoAdministradorActivo { // Pide la clave solo si la sesión no está abierta
        imprimirTitulo("Acceso de administrador")
        let claveIngresada = preguntar("Ingresa la clave de administrador:")
        if !iniciarSesionAdministrador(claveIngresada) {
            pausar()
            return
        }
    }
    var seguirEnAdmin = true
    while seguirEnAdmin {
        imprimirTitulo("Modo administrador · simulación de la red")
        imprimirOpcion("1", "➕", "Insertar una estación ENTRE dos paraderos existentes")
        imprimirOpcion("2", "🛤️", "Ampliar una línea (nuevo terminal al inicio o al final)")
        imprimirOpcion("3", "🆕", "Crear una NUEVA línea simulada")
        imprimirOpcion("4", "🔄", "Registrar transbordo entre dos líneas")
        imprimirOpcion("5", "📋", "Ver bitácora de cambios")
        imprimirOpcion("6", "🔒", "Cerrar sesión y volver al menú principal")
        imprimirSeparador()
        let opcionAdmin = preguntar("Elige una opción (1-6):")
        switch opcionAdmin {
        case "1":
            imprimirSeccion("Insertar estación entre dos paraderos")
            let paraderoA = preguntar("Primer paradero existente:")
            let paraderoB = preguntar("Segundo paradero (debe ir seguido del primero):")
            let nombreNuevo = preguntar("Nombre de la NUEVA estación:")
            let distritoNuevo = preguntar("Distrito de la nueva estación:")
            let referenciaNueva = preguntar("Referencia de ubicación:")
            insertarEstacionEntre(estacionA: paraderoA, estacionB: paraderoB,
                                  nuevaEstacion: nombreNuevo, distrito: distritoNuevo,
                                  referencias: referenciaNueva)
            pausar()
        case "2":
            imprimirSeccion("Ampliar una línea existente")
            imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
            let lineaAmpliar = preguntar("¿Qué línea quieres ampliar?")
            let nombreAmpliacion = preguntar("Nombre de la NUEVA estación:")
            let distritoAmpliacion = preguntar("Distrito:")
            let referenciaAmpliacion = preguntar("Referencia de ubicación:")
            let respuestaInicio = preguntar("¿Va al INICIO del recorrido? (s/n):")
            agregarEstacionAlFinalDeLinea(nombreLinea: lineaAmpliar,
                                          nuevaEstacion: nombreAmpliacion,
                                          distrito: distritoAmpliacion,
                                          referencias: referenciaAmpliacion,
                                          alInicio: normalizar(respuestaInicio) == "s")
            pausar()
        case "3":
            imprimirSeccion("Crear una nueva línea simulada")
            let nombreLineaNueva = preguntar("Nombre de la nueva línea (ej. Línea 3):")
            var estacionesCargadas: [[String: String]] = [] // Array de diccionarios
            var seguirCargando = true
            imprimirNota("Escribe las estaciones EN ORDEN. Escribe 'fin' cuando termines.")
            while seguirCargando {
                let nombreEstacionNueva = preguntar("Estación #\(estacionesCargadas.count + 1) (o 'fin'):")
                if normalizar(nombreEstacionNueva) == "fin" || nombreEstacionNueva.isEmpty {
                    seguirCargando = false
                } else {
                    let distritoEstacionNueva = preguntar("   Distrito de \(nombreEstacionNueva):")
                    let referenciaEstacionNueva = preguntar("   Referencia de ubicación:")
                    estacionesCargadas.append([
                        "nombre": nombreEstacionNueva,
                        "distrito": distritoEstacionNueva,
                        "referencias": referenciaEstacionNueva
                    ])
                }
            }
            let horarioSemana = preguntar("Horario de lunes a viernes:")
            let horarioSabado = preguntar("Horario de sábado:")
            let horarioDomingo = preguntar("Horario de domingo:")
            crearLineaSimulada(nombreLinea: nombreLineaNueva,
                               estacionesNuevas: estacionesCargadas,
                               horarioLunesAViernes: horarioSemana,
                               horarioSabado: horarioSabado,
                               horarioDomingo: horarioDomingo)
            pausar()
        case "4":
            imprimirSeccion("Registrar transbordo entre líneas")
            imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
            let primeraLinea = preguntar("Primera línea:")
            let primeraEstacion = preguntar("Estación de transbordo en esa línea:")
            let segundaLinea = preguntar("Segunda línea:")
            let segundaEstacion = preguntar("Estación de transbordo en la segunda línea:")
            registrarTransbordoEntreLineas(lineaA: primeraLinea, estacionA: primeraEstacion,
                                           lineaB: segundaLinea, estacionB: segundaEstacion)
            pausar()
        case "5":
            mostrarBitacoraAdministrador()
            pausar()
        case "6":
            cerrarSesionAdministrador()
            seguirEnAdmin = false
        default:
            imprimirAviso("Opción no válida, intenta nuevamente.")
        }
    }
}

// ----------------------------------------------------------------------------
// 16. MENÚ PRINCIPAL
// ----------------------------------------------------------------------------
// Cabecera con el resumen de la red, para que el usuario sepa siempre con
// cuántas líneas y estaciones está trabajando.
func imprimirCabecera() {
    var totalOperativas = 0
    for (_, detalle) in estaciones where detalle["estado"] == "Operativa" {
        totalOperativas += 1
    }
    print("")
    print(cCian + "╔" + String(repeating: "═", count: anchoPanel) + "╗" + cReset)
    print(cCian + "║" + cReset + cNegrita + rellenar("  🚇  SISTEMA DE CONSULTA · METRO DE LIMA", anchoPanel) + cReset + cCian + "║" + cReset)
    print(cCian + "║" + cReset + cGris + rellenar("     \(lineas.count) líneas · \(estaciones.count) estaciones · \(totalOperativas) operativas", anchoPanel) + cReset + cCian + "║" + cReset)
    print(cCian + "╚" + String(repeating: "═", count: anchoPanel) + "╝" + cReset)
    if modoAdministradorActivo {
        imprimirNota("Sesión de administrador ABIERTA")
    }
}

func menuPrincipal() {
    var continuarPrograma = true
    while continuarPrograma {
        imprimirCabecera()
        imprimirOpcion("1", "🚉", "Ver estaciones de una línea")
        imprimirOpcion("2", "🔎", "Ver detalle de una estación")
        imprimirOpcion("3", "🧭", "Buscar la mejor ruta entre dos estaciones")
        imprimirOpcion("4", "🕒", "Ver horario de una línea")
        imprimirOpcion("5", "📍", "Buscar cómo llegar a un distrito")
        imprimirOpcion("6", "🗺️", "Planificador de viaje (cuántas estaciones faltan)")
        imprimirOpcion("7", "💳", "Gestionar mi tarjeta (saldo / recarga / pasajes)")
        imprimirOpcion("8", "🔐", "Modo administrador (agregar estaciones y líneas)")
        imprimirOpcion("9", "🚪", "Salir")
        imprimirSeparador()
        let opcion = preguntar("Elige una opción (1-9):")
        switch opcion {
        case "1":
            imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
            let lineaIngresada = preguntar("¿Qué línea deseas consultar?")
            mostrarEstacionesDeLinea(lineaIngresada)
            pausar()
        case "2":
            let estacionIngresada = preguntar("Escribe el nombre de la estación:")
            mostrarDetalleEstacion(estacionIngresada)
            pausar()
        case "3":
            let origenIngresado = preguntar("Estación de ORIGEN:")
            let destinoIngresado = preguntar("Estación de DESTINO:")
            sugerirRuta(origen: origenIngresado, destino: destinoIngresado)
            pausar()
        case "4":
            imprimirNota("Líneas disponibles: " + lineas.keys.sorted().joined(separator: " · "))
            let lineaHorario = preguntar("¿Qué línea deseas consultar?")
            mostrarHorarioDeLinea(lineaHorario)
            pausar()
        case "5":
            let origenDistrito = preguntar("Estación de ORIGEN:")
            let distritoIngresado = preguntar("¿A qué DISTRITO quieres llegar?")
            sugerirRutaPorDistrito(origen: origenDistrito, distritoDestino: distritoIngresado)
            pausar()
        case "6":
            let origenPlan = preguntar("Estación de ORIGEN:")
            let destinoPlan = preguntar("Estación de DESTINO:")
            planificarViaje(origen: origenPlan, destino: destinoPlan)
            pausar()
        case "7":
            menuTarjeta()
        case "8":
            menuAdministrador()
        case "9":
            imprimirTitulo("Hasta pronto")
            imprimirNota("Gracias por usar el sistema de consulta del Metro de Lima.")
            print("")
            continuarPrograma = false
        default:
            imprimirAviso("Opción no válida, intenta nuevamente.")
        }
    }
}

// ----------------------------------------------------------------------------
// 17. EJECUCIÓN
// ----------------------------------------------------------------------------
// Para correrlo en la terminal:
//    swiftc -o metro SistemaConsultaEstacion.swift && ./metro
// o directamente, sin compilar:
//    swift SistemaConsultaEstacion.swift
//
// Pruebas rápidas sin el menú (descomenta la que quieras usar):
// planificarViaje(origen: "Villa El Salvador", destino: "Jorge Chávez")
// _ = iniciarSesionAdministrador("metro2026")
// insertarEstacionEntre(estacionA: "Angamos", estacionB: "San Borja Sur",
//                       nuevaEstacion: "Canadá", distrito: "San Borja",
//                       referencias: "Cruce de Av. Canadá con Av. Aviación")
menuPrincipal()
