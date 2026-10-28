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
}
