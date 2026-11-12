//
//  ReglasNegocio.swift
//  VentasTecsup
//
//  Cálculos de negocio compartidos: categoría de cliente, descuento e IGV.
//

import Foundation

enum CategoriaCliente: String {
    case regular = "Regular"
    case frecuente = "Frecuente"
    case vip = "VIP"
}

extension Cliente {

    /// Suma de ventas no anuladas de este cliente.
    var totalComprado: Double {
        let ventas = (self.ventas as? Set<Venta>) ?? []
        return ventas.filter { !$0.anulada }.reduce(0) { $0 + $1.total }
    }

    /// Categoría calculada (no se guarda en Core Data): Regular < 1000, Frecuente desde 1000, VIP desde 5000.
    var categoria: CategoriaCliente {
        let total = totalComprado
        if total >= 5000 { return .vip }
        if total >= 1000 { return .frecuente }
        return .regular
    }
}

enum ReglasVenta {

    /// Calcula subtotal, descuento, IGV y total para una venta.
    /// VIP: 10% de descuento sobre el subtotal. Los demás: 0%. IGV: 18% sobre (subtotal - descuento).
    static func calcular(cantidad: Int, precioUnitario: Double, categoria: CategoriaCliente) -> (subtotal: Double, descuento: Double, igv: Double, total: Double) {
        let subtotal = Double(cantidad) * precioUnitario
        let descuento = categoria == .vip ? subtotal * 0.10 : 0
        let igv = (subtotal - descuento) * 0.18
        let total = subtotal - descuento + igv
        return (subtotal, descuento, igv, total)
    }
}
