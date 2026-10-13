//
//  PersonasTableViewCell.swift
//  Sem07_UItableView
//
//  Created by Rony Jhostin on 13/10/26.
//

import UIKit

class PersonasTableViewCell: UITableViewCell {


    @IBOutlet weak var PersonaImagen: UIImageView!

    @IBOutlet weak var PersonasNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
