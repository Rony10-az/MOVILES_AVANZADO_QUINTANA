import Foundation
// ===== EJERCICIO 5: CARRITO DE COMPRAS =====
// --- Datos de productos (ya definidos): ---
let prod1 = "Laptop"
let precio1 = 3500.0
let cant1 = 1
let prod2 = "Mouse"
let precio2 = 45.50
let cant2 = 2
let prod3 = "Teclado"
let precio3 = 120.00
let cant3 = 1
let prod4 = "Monitor"
let precio4 = 890.00
let cant4 = 1
let prod5 = "USB Cable"
let precio5 = 15.00
let cant5 = 1


// --- TODO 14: Calcula el subtotal de cada producto ---
 let sub1 = (precio1 * Double(cant1))
 let sub2 = (precio2 * Double(cant2))
 let sub3 = (precio3 * Double(cant3))
 let sub4 = (precio4 * Double(cant4))
 let sub5 = (precio5 * Double(cant5))
// --- TODO 15: Calcula el subtotal general ---
let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5

// --- TODO 16: Aplica descuento según monto de compra ---
// Reglas:
// Compra >= 5000 → 15% de descuento
// Compra >= 2000 → 10% de descuento
// Compra >= 500 → 5% de descuento
// Compra < 500 → sin descuento
var porcentajeDescuento = 0.0
 if subtotalGeneral >= 5000{
 porcentajeDescuento = 0.15
 } else if subtotalGeneral >= 2000 {
     porcentajeDescuento = 0.10
 } else if subtotalGeneral >= 500 {
     porcentajeDescuento = 0.05
 } else{
     porcentajeDescuento = 0.0
 }
let descuento = subtotalGeneral * porcentajeDescuento
let subtotalConDescuento = subtotalGeneral - descuento

// --- TODO 17: Categoría de cliente según monto ---
// Usa switch con rangos para determinar la categoría:
// 0 - 499: "Regular"
// 500 - 1999: "Frecuente"
// 2000 - 4999: "VIP"
// 5000+: "Premium"
let montoParaCategoria = Int(subtotalGeneral)
var categoriaCliente = ""
switch montoParaCategoria {
case 0..<500: categoriaCliente = "Regular"
case 500..<2000: categoriaCliente = "Frecuente"
case 2000..<5000: categoriaCliente = "VIP"
default : categoriaCliente = "Premium"
}

// --- TODO 18: Calcula IGV y total ---
let igv = subtotalConDescuento * 0.18
let totalFinal = subtotalConDescuento + igv


//Usa un bucle for para imprimir la línea separadora
// y print con interpolación para los datos
var separador = ""
 for _ in 1...40 {
separador += "="
 }
 print(separador)
 print(" TICKET DE COMPRA")
 print(" Cliente: \(categoriaCliente)")
 print(separador)
 print("\(prod1) x\(cant1) S/. \(sub1)")
 // TODO: imprime los demás productos
 print(separador)
 print("Subtotal: S/. \(subtotalGeneral)")
 print("Descuento (\(porcentajeDescuento * 100)%): -S/. \(descuento)")
 print("Subtotal c/desc: S/. \(subtotalConDescuento)")
 print("IGV (18%): S/. \(igv)")
 print(separador)
 print("TOTAL: S/. \(totalFinal)")
 print(separador)
 print("¡Gracias por su compra!")
