import Foundation

// Desarrollado por: Rony Jhostin Quintana

// ===== TODO 4: Catálogo de productos =====

var productos: [String: Double] = [:]

for i in 1...4 {
    print("Producto \(i) - Nombre:")
    let nombre = readLine() ?? ""

    print("Precio:")
    let precio = Double(readLine() ?? "") ?? 0

    productos[nombre] = precio
}

// ===== TODO 5: Mostrar catálogo =====

print("===== CATÁLOGO =====")

for (nombre, precio) in productos {
    print("\(nombre): S/. \(precio)")
}

// ===== TODO 6: Valor total =====

var valorTotal = 0.0

for (_, precio) in productos {
    valorTotal += precio
}

print("Valor total: S/. \(valorTotal)")

// ===== TODO 7: Buscar producto =====

print("Buscar producto:")

let buscarProd = readLine() ?? ""

if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}

// ===== ANALYZE 1: Mayores de 21 =====

var edades: [String: Int] = [
    "Ana": 20,
    "Luis": 22,
    "María": 19
]

var mayores: [String] = []

// Recorremos el diccionario y verificamos
// qué personas tienen 21 años o más.
for (nombre, edad) in edades {
    if edad >= 21 {
        mayores.append(nombre)
    }
}

// Solo Luis tiene 21 años o más.
print("Mayores de 21: \(mayores)")

// ANALYZE 1:
// ¿Qué hace?
// Busca y guarda en un array los nombres de las personas
// que tienen una edad mayor o igual a 21.
//
// ¿Qué imprime?
// Mayores de 21: ["Luis"]
