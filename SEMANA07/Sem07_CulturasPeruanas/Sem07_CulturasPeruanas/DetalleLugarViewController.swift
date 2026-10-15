//
//  DetalleLugarViewController.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 15/10/26.
//

import UIKit

class DetalleLugarViewController: UIViewController {

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var ubicacionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var imagenView: UIImageView!

    var lugar: Lugar!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagenView.layer.cornerRadius = 16
        imagenView.clipsToBounds = true
        nombreLabel.text = lugar.nombre
        ubicacionLabel.text = "📍 \(lugar.ubicacion)"
        descripcionLabel.text = lugar.descripcion
        imagenView.image = lugar.imagen
    }

}
