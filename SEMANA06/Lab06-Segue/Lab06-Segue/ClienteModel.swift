//
//  ClienteModel.swift
//  Lab06-Segue
//
//  Created by Rony Jhostin on 12/10/26.
//

import UIKit

class ClienteModel: NSObject {
    
    var Codigo: Int32 = 0
    var Apellido:String = ""
    var Nombre:String = ""
    var Dni:String = ""
    // Inicializador sin parametro y con parameotrs
    
    override init() {
        self.Codigo = 0
        self.Apellido = ""
        self.Nombre = ""
        self.Dni = ""
    }
    
    init(pCodigo: Int32, pApellido: String, pNombre: String, pDni: String) {
        self.Codigo = pCodigo
        self.Apellido = pApellido
        self.Nombre = pNombre
        self.Dni = pDni
    }
    
    

}
