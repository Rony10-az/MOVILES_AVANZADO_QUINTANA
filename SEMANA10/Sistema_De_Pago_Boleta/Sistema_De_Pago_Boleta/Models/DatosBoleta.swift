import Foundation

/// Sistema de pensión elegido por el trabajador.
enum SistemaPension: String, CaseIterable, Identifiable, Hashable {
    case onp = "ONP"
    case afp = "AFP"

    var id: String { rawValue }
}

/// Datos que llena el formulario, según docs/reglas-calculo.md.
struct DatosBoleta {
    var sueldoBasico: Double = 0
    var diasLaborados: Int = 30
    var tieneHijos: Bool = false
    var sistemaPension: SistemaPension = .onp
    var afpElegida: TipoAFP = .ejemplo
    var horasExtra25: Double = 0
    var horasExtra35: Double = 0
    var adelantos: Double = 0

    /// Nivel 3 (reto): encabezado ficticio, ONP/AFP lado a lado y renta de 5.ª categoría.
    var modoReto: Bool = false
    var nombreTrabajador: String = "Trabajador Ejemplo"
    var razonSocialEmpleador: String = "Empresa Ejemplo S.A.C."

    /// Valida los datos del nivel 1 (sueldo y días). Nil si todo está bien.
    func validarNivel1() -> String? {
        if sueldoBasico <= 0 {
            return "El sueldo básico debe ser mayor que cero."
        }
        if diasLaborados < 1 || diasLaborados > 30 {
            return "Los días laborados deben estar entre 1 y 30."
        }
        return nil
    }

    /// Valida los datos del nivel 2 (horas extra y adelantos). Nil si todo está bien.
    func validarNivel2() -> String? {
        if horasExtra25 < 0 || horasExtra35 < 0 {
            return "Las horas extra no pueden ser negativas."
        }
        if adelantos < 0 {
            return "El adelanto no puede ser negativo."
        }
        return nil
    }
}
