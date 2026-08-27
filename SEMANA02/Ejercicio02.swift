
import Foundation
//Framework de swift para el uso de comnados

// definir el promedio de pesos

let ExParcial = 0.3

let trabajo = 0.3

let ExFinal = 0.4

//Ingreso de datos

print("Nombre del Alumno ")
let alumno = readLine() ?? " "

print ("Nota del Examen Parcial : ")
let ExParcial = Double readLine() ?? " ") ?? 0.0

// Nota del examen final
print("Nota del Examen Final:")
let notaFinal = Double(readLine() ?? "") ?? 0.0

// Cálculo del promedio ponderado
let promedio = (notaParcial * pesoParcial) +
               (notaTrabajo * pesoTrabajo) +
               (notaFinal * pesoFinal)

// Mostrar los datos
print("\n----- RESULTADO -----")
print("Alumno: \(alumno)")
print("Nota Parcial: \(notaParcial)")
print("Nota Trabajo: \(notaTrabajo)")
print("Nota Final: \(notaFinal)")
print("Promedio Final: \(promedio)")



