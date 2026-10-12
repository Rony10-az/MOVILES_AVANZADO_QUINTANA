//
//  ViewControllerConfirmacion.swift
//  Lab06-Segue
//
//  Created by Rony Jhostin on 12/10/26.
//

import UIKit

class ViewControllerConfirmacion: UIViewController {
    //instanciar la clase clienteModel
    var pCliente:ClienteModel = ClienteModel()
    //definir los controles
    
    @IBOutlet weak var tfApellido: UILabel!
    
    @IBOutlet weak var tfnombre: UILabel!
    
    @IBOutlet weak var tfDNI: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfApellido.text = pCliente.Apellido
        self.tfnombre.text = pCliente.Nombre
        self.tfDNI.text = pCliente.Dni
    }
    // definir los controles
    
}
