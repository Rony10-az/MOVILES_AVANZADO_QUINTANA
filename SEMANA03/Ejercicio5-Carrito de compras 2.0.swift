import Foundation

// Desarrollado por: Rony Jhostin Quintana

// ===== CARRITO DE COMPRAS 2.0 =====

var nombres: [String] = []
var precios: [Double] = []
var cantidades: [Int] = []

// ===== TODO 11: Pedir productos =====

print("¿Cuántos productos va a comprar?")

let totalProductos = Int(readLine() ?? "") ?? 0

// Evita el error si el usuario ingresa 0.
if totalProductos > 0 {

    for i in 1...totalProductos {

        print("\nProducto \(i) - Nombre:")
        nombres.append(readLine() ?? "")

        print("Precio unitario:")
        precios.append(Double(readLine() ?? "") ?? 0)

        print("Cantidad:")
        cantidades.append(Int(readLine() ?? "") ?? 0)
    }
}

// ===== TODO 12: Calcular subtotales =====

var subtotales: [Double] = []

for i in 0..<nombres.count {

    // Precio × cantidad = subtotal del producto.
    let sub = precios[i] * Double(cantidades[i])

    subtotales.append(sub)
}

// ===== TODO 13: Total del carrito =====

var totalCarrito = 0.0

for sub in subtotales {

    // Sumamos todos los subtotales.
    totalCarrito += sub
}

// ===== TODO 14: Nombre del cliente =====

print("\nNombre del cliente:")

let cliente = readLine() ?? ""

// ===== TODO 15: Descuento =====

// Se aplica descuento dependiendo del total de compra.

var descPct = 0.0

if totalCarrito >= 5000 {
    descPct = 0.15
} else if totalCarrito >= 2000 {
    descPct = 0.10
} else if totalCarrito >= 500 {
    descPct = 0.05
}

// Calculamos el descuento.
let descuento = totalCarrito * descPct

// Aplicamos el descuento.
let totalConDesc = totalCarrito - descuento

// ===== TODO 16: IGV y total =====

// Calculamos el IGV del 18%.
let igv = totalConDesc * 0.18

// Sumamos el IGV al total.
let totalFinal = totalConDesc + igv

// ===== TODO 17: Categoría =====

// Clasificamos al cliente según el total de compra.

var categoria = ""

switch Int(totalCarrito) {

case 0..<500:
    categoria = "Regular"

case 500..<2000:
    categoria = "Frecuente"

case 2000..<5000:
    categoria = "VIP"

default:
    categoria = "Premium"
}

// ===== TODO 18: Ticket =====

let sep = String(repeating: "=", count: 45)

print(sep)
print(" TICKET DE COMPRA 2.0")
print(" Cliente: \(cliente) (\(categoria))")
print(sep)

// Mostramos los productos comprados.

for i in 0..<nombres.count {

    print("\(nombres[i]) x\(cantidades[i]) S/. \(subtotales[i])")
}

print(sep)

print("Subtotal: S/. \(totalCarrito)")

// Mostramos el descuento solamente si existe.

if descPct > 0 {

    print("Descuento (\(descPct * 100)%): -S/. \(descuento)")
}

print("IGV (18%): S/. \(igv)")

print(sep)

print("TOTAL: S/. \(totalFinal)")

print(sep)

print("¡Gracias por su compra, \(cliente)!")
