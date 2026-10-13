//
//  CulturaTableViewCell.swift
//  Sem07_CulturasPeruanas
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class CulturaTableViewCell: UITableViewCell {

    @IBOutlet weak var fotoCultura: UIImageView!
    @IBOutlet weak var nombreCultura: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        fotoCultura.layer.cornerRadius = 10
        fotoCultura.clipsToBounds = true
        fotoCultura.contentMode = .scaleAspectFill
    }

}
