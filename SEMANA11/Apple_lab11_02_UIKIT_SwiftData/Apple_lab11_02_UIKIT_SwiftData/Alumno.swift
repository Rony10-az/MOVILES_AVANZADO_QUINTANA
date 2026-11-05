//
//  Alumno.swift
//  Apple_lab11_02_UIKIT_SwiftData
//
//  Created by Rony Jhostin on 5/11/26.
//

import Foundation
// Importamos SwiftData para poder usar la anotación @Model y la persistencia automática
// Indicamos que esta clase representa una entidad persistente en la base de datos
import SwiftData

@Model
class Alumno {
    
    var idAlumno: UUID
    var apellido: String
    var nombre: String
    var dni: String
    var curso: Curso?    // Relación: un alumno pertenece a un curso (opcional)
    // Identificador único del alumno
    // Constructor que inicializa un nuevo objeto Alumno con los datos proporcionados
    init(idAlumno: UUID = UUID(), apellido: String, nombre: String, dni: String) {
         self.idAlumno = idAlumno
         self.apellido = apellido
         self.nombre = nombre
         self.dni = dni
   }
}
