//
//  Profesor.swift
//  Sem07_UItableView
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class Profesor: NSObject {
    
    var nombre : String = ""
    var cargo:String = ""
    var foto:UIImage!
    
    init(nombre: String, cargo: String, foto: UIImage!) {
        self.nombre = nombre
        self.cargo = cargo
        self.foto = foto
    }

}
