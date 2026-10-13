//
//  DetalleViewController.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!

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

}
