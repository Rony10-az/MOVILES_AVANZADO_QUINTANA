import Foundation

// Desarrollado por: Rony Jhostin Quintana

// ===== TODO 10: Productos, precio y stock =====

// Pide N productos con nombre, precio y stock.
// Calcula el valor total de todos los productos.
// Muestra los productos que tienen stock menor a 5.

var precios: [String: Double] = [:]
var stocks: [String: Int] = [:]

print("¿Cuántos productos?")

let n = Int(readLine() ?? "") ?? 0

if n > 0 {
    for i in 1...n {
        
        print("Producto \(i) - Nombre:")
        let nombre = readLine() ?? ""
        
        print("Precio:")
        let precio = Double(readLine() ?? "") ?? 0
        
        print("Stock:")
        let stock = Int(readLine() ?? "") ?? 0
        
        precios[nombre] = precio
        stocks[nombre] = stock
    }
}


// ===== TODO: Calcular valor total =====

// Recorremos los productos.
// Multiplicamos el precio por el stock
// para obtener el valor total de cada producto.

var valorTotal = 0.0

for (nombre, precio) in precios {
    
    let stock = stocks[nombre] ?? 0
    
    valorTotal += precio * Double(stock)
}

print("========================================")
print("Valor total del inventario: S/. \(valorTotal)")
print("========================================")


// ===== TODO: Mostrar productos con stock bajo =====

// Mostramos los productos cuyo stock sea menor a 5.

print("===== STOCK BAJO =====")

for (nombre, stock) in stocks {
    
    if stock < 5 {
        print("\(nombre): \(stock) unidades")
    }
}
