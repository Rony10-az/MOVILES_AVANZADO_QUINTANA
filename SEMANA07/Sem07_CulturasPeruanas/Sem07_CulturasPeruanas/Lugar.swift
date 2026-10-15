//
//  Lugar.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 15/10/26.
//

import UIKit

class Lugar: NSObject {

    var nombre: String = ""
    var ubicacion: String = ""
    var descripcion: String = ""
    var imagen: UIImage!

    init(nombre: String, ubicacion: String, descripcion: String, imagen: UIImage!) {
        self.nombre = nombre
        self.ubicacion = ubicacion
        self.descripcion = descripcion
        self.imagen = imagen
    }

}
