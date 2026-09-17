import Foundation

let prod = "Laptop" // Nombre del producto en el carrito
let precio = 3500.0 // Precio unitario del producto
let cantidad = 3 // Cantidad comprada del producto

if precio < 0 || cantidad <= 0 { // Validación de datos incorrectos
    print("Error: precio o cantidad inválida") // Mensaje de error si datos no son válidos
} else { // Si los datos son válidos, continuar cálculo
    
    var subtotal = precio * Double(cantidad) // Cálculo del subtotal sin descuentos
    
    var descuentoCantidad = 0.0 // Inicialización del descuento por cantidad
    
    if cantidad >= 3 { // Verifica si compra 3 o más unidades
        descuentoCantidad = subtotal * 0.05 // Aplica 5% de descuento adicional
    } // Fin del descuento por cantidad
    
    subtotal = subtotal - descuentoCantidad // Aplica descuento por cantidad al subtotal
    
    let cupon = "DESCUENTO20" // Código del cupón ingresado
    
    var descuentoCupon = 0.0 // Inicializa descuento por cupón
    
    if cupon == "DESCUENTO20" { // Verifica si el cupón es válido
        descuentoCupon = subtotal * 0.20 // Aplica 20% de descuento adicional
    } // Fin validación de cupón
    
    subtotal = subtotal - descuentoCupon // Aplica descuento del cupón
    
    var envio = 25.0 // Costo base de envío
    
    if subtotal > 3000 { // Verifica si supera el monto para envío gratis
        envio = 0.0 // Asigna envío gratis
    } // Fin validación de envío
    
    let igv = subtotal * 0.18 // Cálculo del impuesto IGV (18%)
    
    let total = subtotal + igv + envio // Cálculo del total final a pagar
    
    let puntos = Int(subtotal / 100) // Cálculo de puntos de fidelidad
    
    print("🧾 TICKET DE COMPRA")
    print("----------------------")
    print("Subtotal: \(subtotal)")
    print("IGV: \(igv)")
    print("Envío: \(envio)")//Muestra el costo de envío (0 si es gratis o 25 si aplica)
    print("TOTAL: \(total)")
    print("----------------------")
    print("⭐ Puntos ganados: \(puntos)")
}
