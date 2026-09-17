//
//  Untitled.swift
//  
//
//  Created by Rony Jhostin on 16/09/26.
//

enum EstadoLibro{
    case disponible, prestado
}

struct Libro {
    let titulo : String
    let autor : String
    var estado : EstadoLibro = .disponible
}

class Biblioteca {
    var libros : [Libro] = []
    
    //Agregar un libro
    func Agregarlibro(libro: Libro){
        libros.append(libro)
        print("Libro agregado: \(libro.titulo)")
    }
    
    //Prestar un libro
    func PrestarLibro(titulo: String) -> Bool{
        for i in 0..<libros.count{
            if libros[i].titulo == titulo{
                if libros[i].estado == .disponible{
                    libros[i].estado = .prestado
                    print("Prestamo aprobado: \(libros[i].titulo)")
                    return true
                } else {
                    print("Error: El libro \(libros[i].titulo) ya esta prestado")
                    return false
                }
            }
        }
        print("Error: El libro \(titulo) no existe")
        return false
        
    }
}


