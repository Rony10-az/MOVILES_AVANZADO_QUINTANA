import Foundation

/// Identifica la AFP elegida; sirve de llave para `Parametros.tasasAFP`.
enum TipoAFP: String, CaseIterable, Identifiable {
    case ejemplo = "AFP Ejemplo"

    var id: String { rawValue }
}

/// Tasas de una AFP sobre el total de remuneraciones.
struct TasasAFP {
    let fondo: Double
    let comision: Double
    let seguro: Double
}

/// Parámetros del cálculo, en un solo lugar (no se escriben dentro de las fórmulas).
/// Fuente y fecha de consulta junto a cada valor, según docs/reglas-calculo.md.
struct Parametros {

    /// RMV — D.S. de la RMV, vigente desde el 1 de octubre de 2026.
    static let rmv: Double = 1230.00

    /// Asignación familiar — Ley 25129. No se prorratea por días.
    static let porcentajeAsignacionFamiliar: Double = 0.10

    /// ONP — D.L. 19990.
    static let porcentajeONP: Double = 0.13

    /// EsSalud — Ley 26790. Lo paga el empleador, no se descuenta al trabajador.
    static let porcentajeEsSalud: Double = 0.09

    /// Recargo de horas extra — Normas de jornada y sobretiempo.
    static let recargoHoras25: Double = 1.25
    static let recargoHoras35: Double = 1.35

    /// Valores de prueba (no son los vigentes en la SBS); solo para los casos de prueba.
    static let tasasAFP: [TipoAFP: TasasAFP] = [
        .ejemplo: TasasAFP(fondo: 0.1000, comision: 0.0160, seguro: 0.0135)
    ]
}
