//
//  ViewController.swift
//  Lab06-Segue
//
//  Created by Rony Jhostin on 12/10/26.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tfApellido: UITextField!
    
    @IBOutlet weak var tfNombre: UITextField!
    
    @IBOutlet weak var tfDni: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnContinuar(_ sender: Any) {
        let oCliente: ClienteModel = ClienteModel(pCodigo:0,pApellido:self.tfApellido.text!,pNombre:self.tfNombre.text!,pDni:self.tfDni.text!)
        // crear el storyboard con el nombre main , se asocia a la pantalla 2
        // le pasamos los datos del cliente
        let osb : UIStoryboard = UIStoryboard(name:"Main",bundle: nil)
        let oPantalla2 = osb.instantiateViewController(withIdentifier: "ViewControllerConfirmacion")as!ViewControllerConfirmacion
        oPantalla2.pCliente = oCliente
        self.present(oPantalla2,animated: true,completion: nil)
    }
    

}

