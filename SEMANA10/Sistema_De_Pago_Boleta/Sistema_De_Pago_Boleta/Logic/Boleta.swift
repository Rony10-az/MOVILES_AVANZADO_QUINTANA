import Foundation

/// Salida de la boleta: los 3 bloques del formato real.
struct ResultadoBoleta {
    // Remuneraciones
    var sueldoComputable: Double = 0
    var asignacionFamiliar: Double = 0
    var horasExtra25Monto: Double = 0
    var horasExtra35Monto: Double = 0
    var totalRemuneraciones: Double = 0

    // Retenciones / Descuentos
    var onp: Double = 0
    var afpFondo: Double = 0
    var afpComision: Double = 0
    var afpSeguro: Double = 0
    var adelantos: Double = 0
    var totalDescuentos: Double = 0
    var netoAPagar: Double = 0

    // Aportaciones del empleador
    var esSaludEmpleador: Double = 0
}

/// Aplica las fórmulas de docs/reglas-calculo.md sobre los datos de entrada.
/// Nivel 1: sueldo computable, asignación familiar, ONP, EsSalud y neto.
/// Horas extra, AFP y adelantos se agregan en el nivel 2.
struct Boleta {

    static func calcular(_ datos: DatosBoleta) -> ResultadoBoleta {
        var resultado = ResultadoBoleta()

        resultado.sueldoComputable = redondear(datos.sueldoBasico / 30 * Double(datos.diasLaborados))

        resultado.asignacionFamiliar = datos.tieneHijos
            ? redondear(Parametros.porcentajeAsignacionFamiliar * Parametros.rmv)
            : 0

        resultado.totalRemuneraciones = resultado.sueldoComputable + resultado.asignacionFamiliar

        resultado.onp = redondear(resultado.totalRemuneraciones * Parametros.porcentajeONP)
        resultado.totalDescuentos = resultado.onp
        resultado.netoAPagar = resultado.totalRemuneraciones - resultado.totalDescuentos

        resultado.esSaludEmpleador = redondear(resultado.totalRemuneraciones * Parametros.porcentajeEsSalud)

        return resultado
    }

    private static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }
}
