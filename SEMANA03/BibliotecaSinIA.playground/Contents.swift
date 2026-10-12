
import Foundation

// 1. Estado del libro
enum EstadoLibro {
    case disponible
    case prestado
}

// 2. Struct Libro
struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro = .disponible
}

// 3. Clase Biblioteca
class Biblioteca {
    
    var libros: [Libro] = []
    
    // Agregar un libro
    func agregar(libro: Libro) {
        libros.append(libro)
        print("Libro agregado: \(libro.titulo)")
    }
    
    // Prestar un libro
    func prestar(titulo: String) -> Bool {
        
        for i in 0..<libros.count {
            
            if libros[i].titulo == titulo {
                
                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(libros[i].titulo)")
                    return true
                } else {
                    print("Error: El libro \(libros[i].titulo) ya está prestado.")
                    return false
                }
            }
        }
        
        print("Error: El libro \(titulo) no existe.")
        return false
    }
    
    // Devolver un libro
    func devolver(titulo: String) -> Bool {
        
        for i in 0..<libros.count {
            
            if libros[i].titulo == titulo {
                
                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución aprobada: \(libros[i].titulo)\n")
                    return true
                } else {
                    print("Error: El libro \(libros[i].titulo) ya está disponible.")
                    return false
                }
            }
        }
        
        print("Error: El libro \(titulo) no existe.")
        return false
    }
    
    // Mostrar inventario
    func inventario() {
        
        print("\n===== INVENTARIO =====")
        
        for libro in libros {
            
            var estadoTexto = ""
            
            switch libro.estado {
            case .disponible:
                estadoTexto = "Disponible"
                
            case .prestado:
                estadoTexto = "Prestado"
            }
            
            print("Título: \(libro.titulo)")
            print("Autor: \(libro.autor)")
            print("Estado: \(estadoTexto)")
            print("----------------------\n")
        }
    }
}

// ===== PRUEBA =====

let biblioteca = Biblioteca()

let libro1 = Libro(
    titulo: "La ciudad y los perros",
    autor: "Mario Vargas Llosa"
)

let libro2 = Libro(
    titulo: "El Quijote",
    autor: "Miguel de Cervantes"
)

let libro3 = Libro(
    titulo: "El principito",
    autor: "Antoine de Saint-Exupéry"
)


biblioteca.agregar(libro: libro1)
biblioteca.agregar(libro: libro2)

biblioteca.inventario()

biblioteca.prestar(titulo: "La ciudad y los perros")
biblioteca.prestar(titulo: "La ciudad y los perros")
biblioteca.devolver(titulo: "La ciudad y los perros")

biblioteca.prestar(titulo: "El Quijote")
biblioteca.prestar(titulo: "El Quijote")

biblioteca.inventario()

