import Foundation

// Desarrollado por: Rony Jhostin Quintana

// ===== TODO 8: Eliminar duplicados =====

var numeros: [Int] = []

for i in 1...8 {
    print("Número \(i):")
    
    let n = Int(readLine() ?? "") ?? 0
    numeros.append(n)
}

print("Con duplicados: \(numeros)")

// Set elimina los valores repetidos.
// sorted() ordena los números de menor a mayor.
let sinDuplicados = Array(Set(numeros)).sorted()

print("Sin duplicados: \(sinDuplicados)")


// ===== TODO 9: Comparar asistencia =====

// Pide 4 nombres lunes y 4 nombres martes.
// Se pueden utilizar Sets para encontrar:
// - Personas que asistieron ambos días.
// - Personas que asistieron solo el lunes.
// - Personas que asistieron solo el martes.


// ===== PREDICT =====

let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

// intersection() devuelve los elementos que están
// presentes en ambos conjuntos.
// PREDICT 5: [4, 5]
print(a.intersection(b))

// union() une todos los elementos de ambos conjuntos.
// No se repiten los elementos.
// PREDICT 6: 8
print(a.union(b).count)

// subtracting() devuelve los elementos que están
// en 'a' pero NO están en 'b'.
// PREDICT 7: [1, 2, 3]
print(a.subtracting(b))

// Un Set no permite elementos duplicados.
// Aunque "A" y "B" aparecen dos veces,
// solo se guardan una vez.
// PREDICT 8: 3
var repetidos: Set = ["A", "B", "A", "C", "B"]

print(repetidos.count)
