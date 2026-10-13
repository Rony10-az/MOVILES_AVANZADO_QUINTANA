//
//  ViewController2.swift
//  Sem07_UItableView
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class ViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaNombres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //crear un objeto para que se muestre la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "miCell") as! PersonasTableViewCell
        cell.PersonasNombre.text = listaNombres[indexPath.row]
        cell.PersonaImagen.image = listaImagenes[indexPath.row]
        return cell
    }

    // Lista de Nombres
    var listaNombres = [
        "Jaime Gomez",
        "Jaime Farfan",
        "Juan Leon"
    ]

    // Lista de Imagenes
    var listaImagenes = [
        UIImage(named: "profesor"),
        UIImage(named: "profesor-4"),
        UIImage(named: "profesor-3")
    ]
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerta = UIAlertController(title: "El docente que selecciono es :", message: "\(listaNombres[indexPath.row])", preferredStyle: UIAlertController.Style.alert)
        
        alerta.addAction(UIAlertAction(title : "OK", style:UIAlertAction.Style.cancel,handler : {(action:UIAlertAction)in}))
        
        self.present(alerta,animated: true,completion: nil)
        
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
