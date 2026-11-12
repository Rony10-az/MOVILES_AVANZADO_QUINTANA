//
//  Extensiones.swift
//  VentasTecsup
//
//  Helpers compartidos por varias pantallas.
//

import UIKit

extension Double {
    /// Formatea un monto como "S/ 1,234.56".
    var comoMoneda: String {
        let formateador = NumberFormatter()
        formateador.numberStyle = .decimal
        formateador.minimumFractionDigits = 2
        formateador.maximumFractionDigits = 2
        formateador.groupingSeparator = ","
        formateador.decimalSeparator = "."
        let numero = formateador.string(from: NSNumber(value: self)) ?? String(format: "%.2f", self)
        return "S/ \(numero)"
    }
}

extension UIViewController {

    /// Muestra una alerta simple con un botón "OK".
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .default))
        present(alerta, animated: true)
    }
}

extension UIColor {
    static let tecsupAzul = UIColor.systemBlue
    static let tecsupVerde = UIColor.systemGreen
    static let tecsupAmbar = UIColor.systemOrange
    static let tecsupRojo = UIColor.systemRed
}
