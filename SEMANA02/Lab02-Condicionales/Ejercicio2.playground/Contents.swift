import Foundation
// ===== EJERCICIO 2: SWITCH =====
// --- Ejemplo (ya resuelto): ---
let diaSemana = 3
switch diaSemana {
case 1: print("Lunes")
case 2: print("Martes")
case 3: print("Miércoles")
case 4: print("Jueves")
case 5: print("Viernes")
case 6: print("Sábado")
case 7: print("Domingo")
default: print("Día inválido")
}
// --- TODO 4: Clasificar nota numérica a letra ---
let nota = 09
switch nota {
case 18...20: print("Aprobado Excellent")
case 15...17: print("Sobresaliente")
case 13...14: print("Aprobado")
case 11...12: print("Sigue intentando")
case 0...10: print("Cambiate de carrera")
default: print("Nota inválida")
}
// --- TODO 5: Calculadora simple con switch ---
let num1 = 20.0
let num2 = 5.0
let operacion = "+"
switch operacion {
case "+": print("Resultado: \(num1 + num2)")
case "-": print("Resultado: \(num1 - num2)")
case "*": print("Resultado: \(num1 * num2)")
case "/":
// // TODO: verificar que num2 no sea 0 antes de dividir
    if num2 != 0 {
        print("Resultado : \(num1 / num2)")
    } else {
        print("No se puede dividir por 0")
    }
default: print("Operación no válida")
}
// --- TODO 6: Categoría de producto por precio ---
let precio = 350.0
// Categorías: Económico (0-99), Medio (100-499),
// Premium (500-999), Lujo (1000+)
// Usa switch con rangos para clasificar
switch precio {
    case 0...99: print("Económico")
case 100...499: print("Medio")
case 500...999: print("Premium")
default: print("Lujo")
}
// PREDICT: Medio


let mes = 2
switch mes {
case 1, 3, 5, 7, 8, 10, 12: print("31 días")
case 4, 6, 9, 11: print("30 días")
case 2: print("28 o 29 días")
default: print("Mes inválido")
    
} // PREDICT 4: 28 o 19 dias

let letra: Character = "a"
switch letra {
case "a", "e", "i", "o", "u": print("Vocal")
default: print("Consonante")
} // PREDICT 5: Vocal
