import Foundation // Importa funcionalidades básicas del sistema como tipos y utilidades

let numeroSecreto = 42 // Define el número que el jugador debe adivinar

let intento1 = 20 // Primer intento del jugador
let intento2 = 50 // Segundo intento del jugador
let intento3 = 42 // Tercer intento del jugador
let intento4 = 10 // Cuarto intento del jugador
let intento5 = 60 // Quinto intento del jugador

var intentos = [intento1, intento2, intento3, intento4, intento5] // Lista simulada de intentos

var i = 0 // Índice para recorrer los intentos
var encontrado = false // Indica si el número fue adivinado
var contadorIntentos = 0 // Cuenta cuántos intentos se realizaron

while i < intentos.count { // Recorre los 5 intentos uno por uno
    
    let intentoActual = intentos[i] // Obtiene el intento actual según el índice
    contadorIntentos += 1 // Incrementa el número de intentos realizados
    
    if intentoActual == numeroSecreto { // Compara si el intento es igual al número secreto
        print("¡Correcto!") // Mensaje si adivinó el número
        encontrado = true // Marca que el número fue encontrado
        break // Termina el bucle porque ya ganó
    } else if intentoActual > numeroSecreto { // Si el número es mayor al secreto
        print("Muy alto") // Indica que el número ingresado es demasiado grande
    } else { // Si no es igual ni mayor
        print("Muy bajo") // Indica que el número es demasiado pequeño
    }
    
    i += 1 // Avanza al siguiente intento
}

if !encontrado { // Si después de los 5 intentos no lo adivinó
    print("Perdiste. El número era: \(numeroSecreto)") // Mensaje de derrota mostrando el número correcto
}

print("Intentos usados: \(contadorIntentos)") // Muestra cuántos intentos se realizaron
