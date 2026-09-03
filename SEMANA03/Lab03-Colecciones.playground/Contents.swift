import Foundation

// Desarrollado por: Rony Quintana Llanque
// Ejercicio 1: Arrays

// ===== TODO 1: Registro de 5 alumnos =====

var alumnos: [String] = []

for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}

print("Alumnos: \(alumnos)")

// ===== TODO 2: Buscar un alumno =====

print("Buscar alumno:")
let buscar = readLine() ?? ""

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ===== TODO 3: Notas con clasificación =====

var notasClase: [Double] = []

for i in 1...5 {
    print("Nota del alumno \(i):")
    let n = Double(readLine() ?? "") ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota

    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")

// ==== FIX: 3 errores ====

var frutas = ["manzana", "banana", "naranja"]

// Error 1:
// frutas.append(7)
// El array es de tipo String, por lo tanto no se puede agregar un Int.

frutas.append("Pera")

print("========================================")
print(frutas)
print("========================================")

// Error 2:
// let colores = ["rojo", "verde", "azul"]
// No se puede modificar un array declarado con let.

var colores = ["rojo", "verde", "azul"]

// Error:
// colores.append("amarillo", "morado")
// Para agregar varios elementos se utiliza contentsOf.

colores.append(contentsOf: ["amarillo", "morado"])

print("\n========================================")
print(colores)
print("========================================")

let numeros = [10, 20, 30, 40, 50]

// Error 3:
// print(numeros[5])
// Los índices empiezan desde 0, por lo que el último índice es 4.

print(numeros[4])

var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)
print(lista) // PREDICT 1: [2, 3, 4, 5, 6]
print(lista.count) // PREDICT 2: 5
var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted()) // PREDICT 3: ["Ana", "Beto", "Carlos"]
print(nombres) // PREDICT 4: ["Ana", "Carlos", "Beto"]
