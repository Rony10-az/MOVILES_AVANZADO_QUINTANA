// Desarrollado por: Rony Jhostin Quintana

import Foundation

// ===== EJERCICIO 6: GESTIÓN DE NOTAS =====

// Creamos un diccionario donde la clave es el nombre del alumno.
var alumnos: [String: [Double]] = [:]

// Pedimos la cantidad de alumnos.
print("¿Cuántos alumnos desea registrar?")

// Convertimos la entrada del usuario a un número entero.
let cantidadAlumnos = Int(readLine() ?? "") ?? 0

// Verificamos que la cantidad sea mayor que cero.
if cantidadAlumnos > 0 {

    // Repetimos el proceso para cada alumno.
    for i in 1...cantidadAlumnos {

        // Mostramos el número del alumno.
        print("\nAlumno \(i) - Nombre:")

        // Guardamos el nombre ingresado.
        let nombre = readLine() ?? ""

        // Creamos un arreglo para almacenar las tres notas.
        var notas: [Double] = []

        // Indicamos que se deben ingresar tres notas.
        for j in 1...3 {

            // Pedimos la nota correspondiente.
            print("Nota \(j):")

            // Convertimos la nota ingresada a Double.
            let nota = Double(readLine() ?? "") ?? 0

            // Guardamos la nota en el arreglo.
            notas.append(nota)
        }

        // Guardamos el nombre y sus tres notas en el diccionario.
        alumnos[nombre] = notas
    }
}

// ===== 9. PROMEDIO Y CLASIFICACIÓN =====

// Creamos un diccionario para guardar el promedio de cada alumno.
var promedios: [String: Double] = [:]

// Recorremos todos los alumnos registrados.
for (nombre, notas) in alumnos {

    // Calculamos la suma de las tres notas.
    let suma = notas.reduce(0, +)

    // Calculamos el promedio del alumno.
    let promedio = suma / Double(notas.count)

    // Guardamos el promedio en el diccionario.
    promedios[nombre] = promedio

    // Creamos una variable para almacenar la clasificación.
    var clasificacion = ""

    // Clasificamos al alumno según su promedio.
    switch promedio {

    // Promedios de 18 a 20 son excelentes.
    case 18...20:
        clasificacion = "Excelente"

    // Promedios de 15 a menos de 18 son buenos.
    case 15..<18:
        clasificacion = "Bueno"

    // Promedios de 11 a menos de 15 son aprobados.
    case 11..<15:
        clasificacion = "Aprobado"

    // Promedios menores de 11 son desaprobados.
    default:
        clasificacion = "Desaprobado"
    }

    // Mostramos el resultado del alumno.
    print("\(nombre) - Promedio: \(promedio) - \(clasificacion)")
}

// ===== 10. ESTADÍSTICAS =====

// Creamos un arreglo con todos los promedios.
let listaPromedios = Array(promedios.values)

// Verificamos que existan alumnos registrados.
if !listaPromedios.isEmpty {

    // Calculamos el promedio general de todos los alumnos.
    let promedioGeneral = listaPromedios.reduce(0, +) / Double(listaPromedios.count)

    // Buscamos el promedio más alto.
    let promedioMasAlto = listaPromedios.max() ?? 0

    // Buscamos el promedio más bajo.
    let promedioMasBajo = listaPromedios.min() ?? 0

    // Contamos la cantidad de alumnos aprobados.
    let aprobados = listaPromedios.filter { $0 >= 11 }.count

    // Calculamos el porcentaje de alumnos aprobados.
    let porcentajeAprobados = Double(aprobados) / Double(listaPromedios.count) * 100

    // Mostramos las estadísticas generales.
    print("\n===== ESTADÍSTICAS =====")

    // Mostramos el promedio general.
    print("Promedio general: \(promedioGeneral)")

    // Mostramos el promedio más alto.
    print("Nota más alta: \(promedioMasAlto)")

    // Mostramos el promedio más bajo.
    print("Nota más baja: \(promedioMasBajo)")

    // Mostramos el porcentaje de aprobados.
    print("Porcentaje de aprobados: \(porcentajeAprobados)%")
}

// ===== 11. ORDENAR POR PROMEDIO =====

// Ordenamos los alumnos de mayor a menor promedio.
let alumnosOrdenados = promedios.sorted { primero, segundo in

    // Comparamos los promedios de cada alumno.
    primero.value > segundo.value
}

// Mostramos la lista ordenada.
print("\n===== ALUMNOS ORDENADOS POR PROMEDIO =====")

// Recorremos los alumnos ordenados.
for (nombre, promedio) in alumnosOrdenados {

    // Mostramos nombre y promedio.
    print("\(nombre): \(promedio)")
}
