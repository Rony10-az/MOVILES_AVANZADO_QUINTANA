//
//  DetalleViewController.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class DetalleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cultura.lugares.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //crear un objeto para que se muestre la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaLugar") as! CulturaTableViewCell
        let lugar = cultura.lugares[indexPath.row]
        cell.nombreCultura.text = "\(lugar.nombre)\n\(lugar.ubicacion)"
        cell.fotoCultura.image = lugar.imagen
        return cell
    }

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var tableViewLugares: UITableView!

    var cultura: Cultura!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagenView.layer.cornerRadius = 16
        imagenView.clipsToBounds = true
        nombreLabel.text = cultura.nombre
        regionLabel.text = "Región: \(cultura.region)"
        descripcionLabel.text = cultura.descripcion
        imagenView.image = cultura.imagen
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "irADetalleLugar" {
            let celda = sender as! UITableViewCell
            let indexPath = tableViewLugares.indexPath(for: celda)!
            let lugarVC = segue.destination as! DetalleLugarViewController
            lugarVC.lugar = cultura.lugares[indexPath.row]
        }
    }

}
