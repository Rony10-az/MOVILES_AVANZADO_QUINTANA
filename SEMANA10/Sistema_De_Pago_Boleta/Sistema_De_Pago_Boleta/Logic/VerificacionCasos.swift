import Foundation

/// Verifica Boleta.calcular contra los casos de prueba del enunciado (docs/reglas-calculo.md).
/// Se ejecuta en DEBUG al iniciar la app; revisa la consola de Xcode.
struct VerificacionCasos {

    static func ejecutar() {
        verificarCaso1()
        verificarCaso2()
    }

    /// Caso 1 · Sin hijos, ONP, mes completo.
    private static func verificarCaso1() {
        var datos = DatosBoleta()
        datos.sueldoBasico = 2500.00
        datos.diasLaborados = 30
        datos.tieneHijos = false
        datos.sistemaPension = .onp

        let r = Boleta.calcular(datos)
        comparar("Caso 1", "sueldoComputable", r.sueldoComputable, 2500.00)
        comparar("Caso 1", "totalRemuneraciones", r.totalRemuneraciones, 2500.00)
        comparar("Caso 1", "onp", r.onp, 325.00)
        comparar("Caso 1", "netoAPagar", r.netoAPagar, 2175.00)
        comparar("Caso 1", "esSaludEmpleador", r.esSaludEmpleador, 225.00)
    }

    /// Caso 2 · Con hijos, días incompletos.
    private static func verificarCaso2() {
        var datos = DatosBoleta()
        datos.sueldoBasico = 1800.00
        datos.diasLaborados = 27
        datos.tieneHijos = true
        datos.sistemaPension = .onp

        let r = Boleta.calcular(datos)
        comparar("Caso 2", "sueldoComputable", r.sueldoComputable, 1620.00)
        comparar("Caso 2", "asignacionFamiliar", r.asignacionFamiliar, 123.00)
        comparar("Caso 2", "totalRemuneraciones", r.totalRemuneraciones, 1743.00)
        comparar("Caso 2", "onp", r.onp, 226.59)
        comparar("Caso 2", "netoAPagar", r.netoAPagar, 1516.41)
        comparar("Caso 2", "esSaludEmpleador", r.esSaludEmpleador, 156.87)
    }

    private static func comparar(_ caso: String, _ concepto: String, _ obtenido: Double, _ esperado: Double) {
        let ok = abs(obtenido - esperado) < 0.005
        print("\(ok ? "✅" : "❌") \(caso) · \(concepto): obtenido \(obtenido) — esperado \(esperado)")
    }
}
